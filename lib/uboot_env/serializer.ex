# SPDX-FileCopyrightText: 2020 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule UBootEnv.Serializer do
  @moduledoc """
  Encode and decode a U-Boot environment data

  The U-Boot environment data looks like this:

    * `"<key>=<value>\\0"` for each key-value pair
    * `"\\0"` an empty key-value pair to terminate the list.
      This looks like `"\\0\\0"` when viewing the file in a hex editor.
  """

  @doc """
  Encode a list of key value pairs into their binary form.

  Raises `ArgumentError` when a key contains `NUL` or `=`, or when a value
  contains `NUL`.
  """
  @spec encode(UBootEnv.kv_map()) :: binary()
  def encode(kv) when is_map(kv) do
    Enum.each(kv, &validate_kv!/1)

    [Enum.map(kv, &kv_to_encoded/1), <<0>>] |> IO.iodata_to_binary()
  end

  defp kv_to_encoded({k, v}), do: [k, ?=, v, 0]

  defp validate_kv!({key, value}) do
    flat_key = IO.iodata_to_binary(key)
    flat_value = IO.iodata_to_binary(value)

    if contains_nul?(flat_key) or :binary.match(key, "=") != :nomatch,
      do: raise(ArgumentError, "invalid U-Boot environment key: #{inspect(flat_key)}")

    if contains_nul?(flat_value),
      do: raise(ArgumentError, "invalid U-Boot environment value: #{inspect(flat_value)}")
  end

  defp contains_nul?(value), do: :binary.match(value, <<0>>) != :nomatch

  @doc """
  Decode a U-Boot environment binary data to a map of key/value pairs
  """
  @spec decode(binary()) :: map()
  def decode(data) do
    data
    |> decode_contents()
    |> Map.new()
  end

  defp decode_contents(contents, acc \\ []) do
    case :binary.split(contents, <<0>>) do
      ["" | _rest] ->
        acc

      [kv, rest] ->
        decode_contents(rest, [parse_kv(kv) | acc])
    end
  end

  defp parse_kv(kv) do
    case :binary.split(kv, "=") do
      [k, v] -> {k, v}
      [k] -> {k, ""}
    end
  end
end
