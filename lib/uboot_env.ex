defmodule UBootEnv do
  @moduledoc """
  UBootEnv reads a non-replicated U-Boot environment block for
  storing firmware and provisioning information.

  The U-Boot environment format looks like this:

    * CRC32 of bytes 4 through to the end
    * `"<key>=<value>\0"` for each key-value pair
    * `"\0"` an empty key-value pair to terminate the list.
      This looks like "\0\0" when you're viewing the file in a hex editor.
    * Filler bytes to the end of the environment block. These are usually `0xff`.

  The U-Boot environment configuration is loaded from `/etc/fw_env.config`.
  If you are using OTP >= 21, the contents of the U-Boot environment will be
  read directly from the device. If not, the code falls back to `fw_printenv`,
  but be aware that there's a known issue with values that have embedded
  newlines.
  """

  alias UBootEnv.Config

  @doc """
  Read the U-Boot environment into a map or key value pairs

  Optionally specify the path to the `fw_env.config` file that describes the
  U-Boot environment block.  If unspecified, the default path
  `/etc/fw_env.config` will be used.
  """
  @spec read(Path.t() | nil) :: {:ok, map()} | {:error, reason :: binary()}
  def read(file_or_nil \\ nil) do
    with {:ok, {dev_name, dev_offset, env_size}} <- do_config_read(file_or_nil),
         {:ok, kv} <- load(dev_name, dev_offset, env_size) do
      {:ok, kv}
    end
  end

  @doc """
  Write a map of key value pairs to the U-Boot environment

  Optionally specify the path to the `fw_env.config` file that describes the
  U-Boot environment block.
  """
  @spec write(kv :: map(), Path.t() | nil) :: :ok | {:error, reason :: any()}
  def write(kv, config_file_or_nil \\ nil) do
    case do_config_read(config_file_or_nil) do
      {:ok, {dev_name, dev_offset, env_size}} ->
        uboot_env = encode(kv, env_size)
        pwrite_file(dev_name, dev_offset, uboot_env)

      error ->
        error
    end
  end

  @doc """
  Encode a list of key value pairs into the binary form of the U-Boot
  environment block.
  """
  @spec encode(map(), pos_integer()) :: iodata()
  def encode(kv, env_size) when is_map(kv) do
    encoded_kv = [Enum.map(kv, &kv_to_encoded/1), <<0>>]
    encoded_kv_len = IO.iodata_length(encoded_kv)

    padding_len = env_size - encoded_kv_len - 4
    padding = :binary.copy(<<-1>>, padding_len)

    crc = :erlang.crc32([encoded_kv, padding])
    [<<crc::little-size(32)>>, encoded_kv, padding]
  end

  defp kv_to_encoded({k, v}) do
    [k, "=", v, <<0>>]
  end

  @doc """
  Decode a a U-Boot environment block to a map
  """
  @spec decode(binary()) ::
          {:ok, map()} | {:error, reason :: atom()}
  def decode(bin) when is_binary(bin) do
    <<expected_crc::little-size(32), contents::binary>> = bin
    actual_crc = :erlang.crc32(contents)

    if actual_crc == expected_crc do
      decode_kv_pairs(contents, %{})
    else
      {:error, :invalid_crc}
    end
  end

  def decode_kv_pairs(contents, map) do
    case :binary.split(contents, <<0>>) do
      ["" | _rest] ->
        {:ok, map}

      [kv, rest] ->
        [k, v] = :binary.split(kv, "=")
        decode_kv_pairs(rest, Map.put(map, k, v))
    end
  end

  @doc """
  Load key-value pairs from U-Boot environment

  Specify the filename, byte offset and size of the U-Boot environment to load.
  If you have a `fw_env.config` file, then consider using `read/1` instead.

  This function requires OTP 21 or later.
  """
  @spec load(Path.t(), non_neg_integer(), pos_integer()) ::
          {:ok, map()} | {:error, reason :: atom()}
  def load(dev_name, dev_offset, env_size) do
    with {:ok, contents} <- pread_file(dev_name, dev_offset, env_size) do
      decode(contents)
    end
  end

  defp pread_file(path, offset, size) do
    case File.open(path, [:raw, :binary, :read]) do
      {:ok, fd} ->
        rc = :file.pread(fd, offset, size) |> eof_is_error()
        File.close(fd)
        rc

      error ->
        error
    end
  end

  defp pwrite_file(path, offset, contents) do
    case File.open(path, [:raw, :binary, :write, :read]) do
      {:ok, fd} ->
        rc = :file.pwrite(fd, offset, contents)
        File.close(fd)
        rc

      error ->
        error
    end
  end

  defp eof_is_error(:eof), do: {:error, :empty}
  defp eof_is_error(other), do: other

  defp do_config_read(nil), do: Config.read()
  defp do_config_read(path), do: Config.read(path)
end
