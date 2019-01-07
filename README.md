# UBootEnv

[![CircleCI](https://circleci.com/gh/nerves-project/uboot_env.svg?style=svg)](https://circleci.com/gh/nerves-project/uboot_env)
[![Hex version](https://img.shields.io/hexpm/v/uboot_env.svg "Hex version")](https://hex.pm/packages/uboot_env)

This library lets you read and write [U-Boot](https://www.denx.de/wiki/U-Boot)
environment blocks from Elixir. U-Boot environment blocks are simple key-value
stores used by the U-Boot bootloader and applications that need to communicate
with it. Nerves uses U-Boot environment blocks to store settings related to the
device and running firmware. Nerves uses the format even for boards (like the
Raspberry Pis) that don't use the U-Boot bootloader.

This library has the following features:

* Create, read, and write to U-Boot environment blocks in pure Elixir with OTP
  21 and later
* Fallback to `uboot-tools` for prior OTP versions (this has a known bug for
  multi-line values)
* Support for `/etc/fw_env.config` for environment block parameters
* `mix` utilities to manipulate the block offline

Not all U-Boot environment features are supported. The primary omissions are
around support for raw NAND features like redundant environment blocks and
awareness of erase block sizes. If you don't know what this means, it doesn't
affect you.

## Installation

Install by adding `uboot_env` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:uboot_env, "~> 0.1.0"}
  ]
end
```

## Mix tooling

The mix tooling is useful for inspecting and updating provisioning-related
parameters on MicroSD cards and on raw images. For example, to inspect the
environment block on a Raspberry Pi's MicroSD card, insert that MicroSD card in
your computer. In the following example, the MicroSD card showed up at
`/dev/sdc`. The U-Boot environment offset and size were found in the Nerves
system's `fwup.conf` file.

```bash
$ mix uboot_env.read /dev/sdc 0x2000 0x2000
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

Information about most of these variables is in the [nerves_runtime
README.md](https://github.com/nerves-project/nerves_runtime#nerves-system-and-firmware-metadata).
Of course, projects can add their own custom keys to this section too.

To write a new key-value pair, run the following:

```bash
$ mix uboot_env.write /dev/sdc 0x2000 0x2000 test "abc"
  ...
  test = "abc"
```

To delete that key-value pair, run:

```bash
mix uboot_env.delete /dev/sdc 0x2000 0x2000 test
```

## License

This code is Apache 2 licensed.
