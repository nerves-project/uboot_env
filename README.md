# UBootEnv

```elixir
iex()> File.read!("/home/connor/farmbot/os/os/deps/rpi3/farmbot_system_rpi3/rootfs_overlay/etc/fw_env.config") 
...()> |> String.replace("/dev/mmcblk0", hd(hd(Fwup.get_devices())))
iex()> UBootEnv.read("/tmp/fw_env.config")
{:ok, %{                                               
   "a.nerves_fw_application_part0_devpath" => "/dev/mmcblk0p3", 
   "a.nerves_fw_application_part0_fstype" => "ext4",
   "a.nerves_fw_application_part0_target" => "/root",
   "a.nerves_fw_architecture" => "arm",
   "a.nerves_fw_author" => "The Farmbot Team",
   "a.nerves_fw_description" => "The Brains of the Farmbot Project",
   "a.nerves_fw_misc" => "",
   "a.nerves_fw_platform" => "rpi3",
   "a.nerves_fw_product" => "farmbot",
   "a.nerves_fw_uuid" => "d20c0429-81a9-5d01-f3bf-c03f72a74c7b",
   "a.nerves_fw_vcs_identifier" => "",
   "a.nerves_fw_version" => "6.4.11",
   "b.nerves_fw_application_part0_devpath" => "/dev/mmcblk0p3",
   "b.nerves_fw_application_part0_fstype" => "ext4",
   "b.nerves_fw_application_part0_target" => "/root",
   "b.nerves_fw_architecture" => "arm",
   "b.nerves_fw_author" => "The Farmbot Team",
   "b.nerves_fw_description" => "The Brains of the Farmbot Project",
   "b.nerves_fw_misc" => "staging",
   "b.nerves_fw_platform" => "rpi3",
   "b.nerves_fw_product" => "farmbot",
   "b.nerves_fw_uuid" => "347dfe94-9c3c-5e51-204a-eea64f629227",
   "b.nerves_fw_vcs_identifier" => "0e24382fa4251eb89359ba0f7ee731eb66739c6b",
   "b.nerves_fw_version" => "6.4.12",
   "nerves_fw_active" => "b",
   "nerves_fw_devpath" => "/dev/mmcblk0",
   "nerves_fw_serial_number" => "000000008d60fd86",
   "nerves_hub_cert" => "",
   "nerves_hub_key" => "",
   "nerves_serial_number" => "000000008d60fd86"
 }}
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

