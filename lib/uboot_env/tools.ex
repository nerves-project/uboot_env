defmodule UBootEnv.Tools do
  @moduledoc """
  This module uses U-boot tools' `fw_printenv` to read environment blocks.  It
  is only useful if OTP 21 is not available. This module has a known issue with
  parsing key-value pairs with embedded newlines.
  """

  @doc """
  Decode a U-Boot environment block using `fw_printenv`
  """
  @spec fw_printenv() :: {:ok, map()} | {:error, reason :: String.t()}
  def fw_printenv() do
    case exec("fw_printenv") do
      {:ok, env} -> {:ok, decode(env)}
      error -> error
    end
  end

  @doc """
  Set a U-Boot variable using `fw_setenv`.
  """
  @spec fw_setenv(String.t(), String.t()) ::
          :ok
          | {:error, reason :: String.t()}
  def fw_setenv(key, value) do
    case exec("fw_setenv", [key, value]) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  @doc """
  Decode a list of fw_env.config key value pairs into a map
  """
  @spec decode(String.t()) :: map()
  def decode(env) do
    env
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "=", parts: 2))
    |> Enum.map(fn [k, v] -> {k, v} end)
    |> Enum.into(%{})
  end

  defp exec(cmd, args \\ []) do
    if exec = System.find_executable(cmd) do
      case System.cmd(exec, args) do
        {result, 0} ->
          {:ok, String.trim(result)}

        {result, _code} ->
          {:error, result}
      end
    else
      {:error, cmd <> " not found"}
    end
  end
end
