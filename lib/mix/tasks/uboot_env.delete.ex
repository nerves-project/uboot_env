defmodule Mix.Tasks.UbootEnv.Delete do
  use Mix.Task
  import Mix.UbootEnv.Utils
  import UBootEnv.Config, only: [parse_int: 1]

  @shortdoc "Delete a key-value pair from a U-Boot environment"

  @moduledoc """
  Delete a key-value pair from a U-Boot environment.

  Pass either a path to a configuration file like `/etc/fw_env.config` or the
  path to the file or device containing the U-Boot environment and its offset
  and size.

  Usage:
    mix uboot_env.write PATH_TO_DEVICE DEV_OFFSET ENV_SIZE KEY
    mix uboot_env.write PATH_TO_CONFIG_FILE KEY
  """

  def run([config_path, key]) do
    with {:ok, kv} <- UBootEnv.read(config_path),
         %{} = kv <- Map.delete(kv, key),
         :ok <- UBootEnv.write(kv, config_path) do
      render_kv(kv)
    else
      {:error, reason} -> Mix.raise(reason)
    end
  end

  def run([dev_name, dev_offset, env_size, key]) do
    with dev_offset <- parse_int(dev_offset),
         env_size <- parse_int(env_size),
         {:ok, kv} <- UBootEnv.load(dev_name, dev_offset, env_size),
         %{} = kv <- Map.delete(kv, key),
         {:ok, fd} <- File.open(dev_name, [:raw, :binary, :write]),
         uboot_env <- UBootEnv.encode(kv, env_size),
         :ok <- :file.pwrite(fd, dev_offset, uboot_env),
         :ok <- File.close(fd) do
      render_kv(kv)
    else
      {:error, reason} -> Mix.raise(reason)
    end
  end
end
