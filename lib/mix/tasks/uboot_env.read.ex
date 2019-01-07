defmodule Mix.Tasks.UBootEnv.Read do
  use Mix.Task
  import Mix.UBootEnv.Utils
  import UBootEnv.Config, only: [parse_int: 1]

  @shortdoc "Read UBootEnv of a device."

  @moduledoc """
  Read UBootEnv of a device. 

  Usage:
    mix uboot_env.read PATH_TO_DEVICE DEV_OFFSET ENV_SIZE
    mix uboot_env.read PATH_TO_CONFIG_FILE
  """

  def run([config_path]) do
    with {:ok, kv} <- UBootEnv.read(config_path) do
      render_kv(kv)
    else
      {:error, reason} -> Mix.raise(reason)
    end
  end

  def run([dev_name, dev_offset, env_size]) do
    with dev_offset <- parse_int(dev_offset),
         env_size <- parse_int(env_size),
         {:ok, kv} <- UBootEnv.load(dev_name, dev_offset, env_size) do
      render_kv(kv)
    else
      {:error, reason} -> Mix.raise(reason)
    end
  end
end
