# SPDX-FileCopyrightText: 2020 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule UBootEnv.ConfigTest do
  use ExUnit.Case
  alias UBootEnv.{Config, Location}
  doctest Config

  @fixtures Path.expand("../fixtures", __DIR__)

  describe "from_file/1" do
    test "can parse fw_env.config for common systems" do
      {:ok, config} = Config.from_file(Path.join(@fixtures, "fw_env.config"))

      assert config == %Config{
               locations: [
                 %Location{path: "/dev/mmcblk0", offset: 0x100000, size: 0x2000}
               ]
             }
    end

    test "can parse fw_env.config with spaces" do
      {:ok, config} = Config.from_file(Path.join(@fixtures, "spaces_fw_env.config"))

      assert config == %Config{
               locations: [%Location{path: "/dev/mtd3", offset: 0, size: 0x1000}]
             }
    end
  end

  describe "from_string/1" do
    test "parsing nonredundant config" do
      {:ok, config} = Config.from_string("invalid.bin 0 1024")

      assert config == %Config{
               locations: [%Location{path: "invalid.bin", offset: 0, size: 1024}]
             }
    end

    test "parsing redundant config" do
      {:ok, config} = Config.from_string("invalid.bin 0 1024\ninvalid.bin 1024 1024")

      assert config == %Config{
               locations: [
                 %Location{path: "invalid.bin", offset: 0, size: 1024},
                 %Location{path: "invalid.bin", offset: 1024, size: 1024}
               ]
             }
    end
  end

  test "format/1" do
    config = Config.from_string!("invalid.bin 0 1024")
    assert Config.format(config) == :nonredundant

    config = Config.from_string!("invalid.bin 0 1024\ninvalid.bin 1024 1024")
    assert Config.format(config) == :redundant
  end
end
