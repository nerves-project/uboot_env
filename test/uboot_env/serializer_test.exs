# SPDX-FileCopyrightText: 2020 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule UBootEnv.SerializerTest do
  use ExUnit.Case
  alias UBootEnv.Serializer

  @test_kv %{
    "test_value_with_whitespace" => "a b\nc\td e",
    "test_empty_value" => "",
    "" => "empty key",
    "a.nerves_fw_application_part0_devpath" => "/dev/mmcblk0p3",
    "a.nerves_fw_application_part0_fstype" => "ext4",
    "a.nerves_fw_application_part0_target" => "/root",
    "a.nerves_fw_architecture" => "arm",
    "a.nerves_fw_author" => "The Nerves Team",
    "a.nerves_fw_description" => "",
    "a.nerves_fw_platform" => "rpi",
    "a.nerves_fw_product" => "Nerves Firmware",
    "a.nerves_fw_version" => "",
    "nerves_fw_active" => "a",
    "nerves_fw_devpath" => "/dev/mmcblk0"
  }

  defp transcode(kv) do
    kv
    |> Serializer.encode()
    |> IO.iodata_to_binary()
    |> Serializer.decode()
  end

  test "decoding what is encoded" do
    assert %{} == transcode(%{})

    assert @test_kv == transcode(@test_kv)
  end

  test "handle key-only data from mkenvimage" do
    # I'm not sure whether this is valid or not, but mkenvimage can create it, so
    # don't blow up.
    kv = Serializer.decode(<<"hello", 0, 0>>)
    assert kv == %{"hello" => ""}
  end
end
