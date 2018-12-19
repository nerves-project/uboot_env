defmodule Mix.UBootEnv.Utils do
  def render_kv(%{} = kv) do
    for {key, val} <- kv do
      Mix.shell().info("\t #{key} = #{inspect(val, limit: :infinity)}")
    end
  end

  def parse_int(<<"0x", hex_int::binary()>>), do: String.to_integer(hex_int, 16)
  def parse_int(decimal_int), do: String.to_integer(decimal_int)
end
