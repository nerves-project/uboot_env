defmodule Mix.UbootEnv.Utils do
  @moduledoc false
  def render_kv(%{} = kv) do
    for {key, val} <- kv do
      Mix.shell().info("  #{key} = #{inspect(val, limit: :infinity)}")
    end
  end
end
