defmodule UBootEnvTest do
  use ExUnit.Case
  doctest UBootEnv

  test "greets the world" do
    assert UBootEnv.hello() == :world
  end
end
