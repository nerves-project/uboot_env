#!/bin/sh

# Create the test environment file manually so that users of nerves_runtime
# don't need uboot-tools and fwup installed.

set -e

FIXTURE_UBOOT=fixture_uboot.bin
FIXTURE_REDUNDANT_UBOOT=fixture_redundant_uboot.bin
FIXTURE_FWUP=fixture_fwup.bin
FIXTURE_REDUNDANT_FWUP=fixture_redundant_fwup.bin

rm -f $FIXTURE_UBOOT $FIXTURE_REDUNDANT_UBOOT $FIXTURE_FWUP $FIXTURE_REDUNDANT_FWUP

# Create a U-boot environment block using the uboot-tools
mkenvimage -s 8192 -o env.bin support/fixture_env.script
dd if=/dev/zero of=gap.bin bs=1024 count=4
cat gap.bin env.bin > $FIXTURE_UBOOT
rm -f gap.bin env.bin

# Create a redundant U-boot environment block using uboot-tools
# This one is created so that the second environment has the right data
mkenvimage -r -s 8192 -o env.bin support/fixture_env.script
dd if=/dev/zero of=gap.bin bs=1024 count=4
cat gap.bin env.bin gap.bin env.bin > $FIXTURE_REDUNDANT_UBOOT
rm -f gap.bin env.bin
fw_setenv -c support/fixture_redundant_env.config nerves_serial_number wrong2
fw_setenv -c support/fixture_redundant_env.config nerves_serial_number wrong
fw_setenv -c support/fixture_redundant_env.config nerves_serial_number 12345

# Create U-boot environment blocks using fwup
fwup -c -f support/fixture_env_fwup.conf -o fixture_env_fwup.fw
fwup -d $FIXTURE_FWUP fixture_env_fwup.fw
rm -f fixture_env_fwup.fw

fwup -c -f support/fixture_redundant_env_fwup.conf -o fixture_redundant_env_fwup.fw
fwup -d $FIXTURE_REDUNDANT_FWUP fixture_redundant_env_fwup.fw
rm -f fixture_redundant_env_fwup.fw
