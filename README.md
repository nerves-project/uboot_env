# UBootEnv

[![CircleCI](https://circleci.com/gh/nerves-project/uboot_env.svg?style=svg)](https://circleci.com/gh/nerves-project/uboot_env)
[![Hex version](https://img.shields.io/hexpm/v/uboot_env.svg "Hex version")](https://hex.pm/packages/uboot_env)

Read and write UBoot environment block

## Read
```bash
mix u_boot_env.read /dev/sdc 0x2000 0x2000
	 a.nerves_fw_application_part0_devpath = "/dev/mmcblk0p3"
	 a.nerves_fw_application_part0_fstype = "ext4"
	 a.nerves_fw_application_part0_target = "/root"
	 a.nerves_fw_architecture = "arm"
	 a.nerves_fw_author = "The Farmbot Team"
	 a.nerves_fw_description = "The Brains of the Farmbot Project"
	 a.nerves_fw_misc = "beta"
	 a.nerves_fw_platform = "rpi3"
	 a.nerves_fw_product = "farmbot"
	 a.nerves_fw_uuid = "7fd0682a-3294-521c-bfdc-9dafd2cfa558"
	 a.nerves_fw_vcs_identifier = "f540f8d319ec10c20cf7870d3ad2bf907f67389d"
	 a.nerves_fw_version = "6.4.12"
	 b.nerves_fw_application_part0_devpath = "/dev/mmcblk0p3"
	 b.nerves_fw_application_part0_fstype = "ext4"
	 b.nerves_fw_application_part0_target = "/root"
	 b.nerves_fw_architecture = "arm"
	 b.nerves_fw_author = "The Farmbot Team"
	 b.nerves_fw_description = "The Brains of the Farmbot Project"
	 b.nerves_fw_misc = "beta"
	 b.nerves_fw_platform = "rpi3"
	 b.nerves_fw_product = "farmbot"
	 b.nerves_fw_uuid = "005fdb61-d0ca-5c4d-051f-0ce127be7e7c"
	 b.nerves_fw_vcs_identifier = "f2fe6481783740470d6a22fb1b7e7993e475239f"
	 b.nerves_fw_version = "6.4.12"
	 nerves_fw_active = "a"
	 nerves_fw_devpath = "/dev/mmcblk0"
	 nerves_fw_serial_number = "000000008d60fd86"
	 nerves_hub_cert = ""
	 nerves_hub_key = ""
	 nerves_serial_number = "000000008d60fd86"
```

## Write
```bash
mix u_boot_env.write /dev/sdc 0x2000 0x2000 test "abc"
	 a.nerves_fw_application_part0_devpath = "/dev/mmcblk0p3"
	 a.nerves_fw_application_part0_fstype = "ext4"
	 a.nerves_fw_application_part0_target = "/root"
	 a.nerves_fw_architecture = "arm"
	 a.nerves_fw_author = "The Farmbot Team"
	 a.nerves_fw_description = "The Brains of the Farmbot Project"
	 a.nerves_fw_misc = "beta"
	 a.nerves_fw_platform = "rpi3"
	 a.nerves_fw_product = "farmbot"
	 a.nerves_fw_uuid = "7fd0682a-3294-521c-bfdc-9dafd2cfa558"
	 a.nerves_fw_vcs_identifier = "f540f8d319ec10c20cf7870d3ad2bf907f67389d"
	 a.nerves_fw_version = "6.4.12"
	 b.nerves_fw_application_part0_devpath = "/dev/mmcblk0p3"
	 b.nerves_fw_application_part0_fstype = "ext4"
	 b.nerves_fw_application_part0_target = "/root"
	 b.nerves_fw_architecture = "arm"
	 b.nerves_fw_author = "The Farmbot Team"
	 b.nerves_fw_description = "The Brains of the Farmbot Project"
	 b.nerves_fw_misc = "beta"
	 b.nerves_fw_platform = "rpi3"
	 b.nerves_fw_product = "farmbot"
	 b.nerves_fw_uuid = "005fdb61-d0ca-5c4d-051f-0ce127be7e7c"
	 b.nerves_fw_vcs_identifier = "f2fe6481783740470d6a22fb1b7e7993e475239f"
	 b.nerves_fw_version = "6.4.12"
	 nerves_fw_active = "a"
	 nerves_fw_devpath = "/dev/mmcblk0"
	 nerves_fw_serial_number = "000000008d60fd86"
	 nerves_hub_cert = ""
	 nerves_hub_key = ""
	 nerves_serial_number = "000000008d60fd86"
	 test = "abc"
```

## Delete
```bash
mix u_boot_env.delete /dev/sdc 0x2000 0x2000 test 
	 a.nerves_fw_application_part0_devpath = "/dev/mmcblk0p3"
	 a.nerves_fw_application_part0_fstype = "ext4"
	 a.nerves_fw_application_part0_target = "/root"
	 a.nerves_fw_architecture = "arm"
	 a.nerves_fw_author = "The Farmbot Team"
	 a.nerves_fw_description = "The Brains of the Farmbot Project"
	 a.nerves_fw_misc = "beta"
	 a.nerves_fw_platform = "rpi3"
	 a.nerves_fw_product = "farmbot"
	 a.nerves_fw_uuid = "7fd0682a-3294-521c-bfdc-9dafd2cfa558"
	 a.nerves_fw_vcs_identifier = "f540f8d319ec10c20cf7870d3ad2bf907f67389d"
	 a.nerves_fw_version = "6.4.12"
	 b.nerves_fw_application_part0_devpath = "/dev/mmcblk0p3"
	 b.nerves_fw_application_part0_fstype = "ext4"
	 b.nerves_fw_application_part0_target = "/root"
	 b.nerves_fw_architecture = "arm"
	 b.nerves_fw_author = "The Farmbot Team"
	 b.nerves_fw_description = "The Brains of the Farmbot Project"
	 b.nerves_fw_misc = "beta"
	 b.nerves_fw_platform = "rpi3"
	 b.nerves_fw_product = "farmbot"
	 b.nerves_fw_uuid = "005fdb61-d0ca-5c4d-051f-0ce127be7e7c"
	 b.nerves_fw_vcs_identifier = "f2fe6481783740470d6a22fb1b7e7993e475239f"
	 b.nerves_fw_version = "6.4.12"
	 nerves_fw_active = "a"
	 nerves_fw_devpath = "/dev/mmcblk0"
	 nerves_fw_serial_number = "000000008d60fd86"
	 nerves_hub_cert = ""
	 nerves_hub_key = ""
	 nerves_serial_number = "000000008d60fd86"
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `uboot_env` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:uboot_env, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/uboot_env](https://hexdocs.pm/uboot_env).

