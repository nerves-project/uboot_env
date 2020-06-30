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
* Support for `/etc/fw_env.config` for environment block parameters

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

## License

This code is Apache 2 licensed.
