defmodule UBootEnvTest do
  use ExUnit.Case
  doctest UBootEnv
  @fixtures Path.expand("fixtures", __DIR__)

  # Most testing is done in other modules. This is a spot check that the main API
  # basically works.

  test "write and reread" do
    path = Path.join(["..", "tmp_#{:random.uniform(10000)}"]) |> Path.expand(__DIR__)
    File.write!(path, :binary.copy(<<0xFF>>, 1024))
    config = UBootEnv.Config.from_string!("#{path} 0 1024")

    test_map = %{"a" => "b"}
    :ok = UBootEnv.write(%{"a" => "b"}, config)
    {:ok, result} = UBootEnv.read(config)

    assert result == test_map
  end

  test "reading U-Boot sample environment" do
    config =
      UBootEnv.Config.from_string!("#{@fixtures}/fixture_uboot.bin	0x1000  	0x2000		0x200			16")

    {:ok, result} = UBootEnv.read(config)

    assert result == %{
             "a.nerves_fw_application_part0_devpath" => "/dev/mmcblk0p4",
             "nerves_serial_number" => "12345"
           }
  end

  test "reading fwup sample environment" do
    config =
      UBootEnv.Config.from_string!("#{@fixtures}/fixture_fwup.bin	0x1000  	0x2000		0x200			16")

    {:ok, result} = UBootEnv.read(config)

    assert result == %{
             "a.nerves_fw_application_part0_devpath" => "/dev/mmcblk0p4",
             "nerves_serial_number" => "112233"
           }
  end

  test "reading a redundant U-Boot sample environment" do
    config =
      UBootEnv.Config.from_string!(
        "#{@fixtures}/fixture_redundant_uboot.bin	0x1000  	0x2000\n#{@fixtures}/fixture_redundant_uboot.bin	0x4000  	0x2000"
      )

    {:ok, result} = UBootEnv.read(config)

    assert result == %{
             "a.nerves_fw_application_part0_devpath" => "/dev/mmcblk0p4",
             "nerves_serial_number" => "12345"
           }
  end

  test "reading a redundant fwup sample environment" do
    config =
      UBootEnv.Config.from_string!(
        "#{@fixtures}/fixture_redundant_fwup.bin	0x1000  	0x2000\n#{@fixtures}/fixture_redundant_fwup.bin	0x4000  	0x2000"
      )

    {:ok, result} = UBootEnv.read(config)

    assert result == %{
             "a.nerves_fw_application_part0_devpath" => "/dev/mmcblk0p4",
             "nerves_serial_number" => "112233"
           }
  end
end
