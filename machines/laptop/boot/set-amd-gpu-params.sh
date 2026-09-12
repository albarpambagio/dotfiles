#!/usr/bin/env bash
# set-amd-gpu-params.sh — Append AMD GPU kernel parameters to Limine bootloader config.
#
# This is NOT applied automatically by install.sh because the ESP is a
# FAT32 partition that can't be symlinked. Run this manually after install
# on machines with AMD GPUs.
#
# Parameters:
#   amdgpu.ppfeaturemask=0xffffffff  — Enable all power management features (overdrive)
#   amdgpu.gpu_recovery=1            — Enable GPU reset on hang
#
# Usage: sudo ./machines/laptop/boot/set-amd-gpu-params.sh
set -euo pipefail

LIMINE_CONF="/boot/limine.conf"
PARAMS="amdgpu.gpu_recovery=1 amdgpu.ppfeaturemask=0xffffffff"

if [ ! -f "$LIMINE_CONF" ]; then
  echo "Error: $LIMINE_CONF not found. Is the ESP mounted at /boot?" >&2
  exit 1
fi

if grep -q "amdgpu.ppfeaturemask" "$LIMINE_CONF"; then
  echo "AMD GPU parameters already present in $LIMINE_CONF"
  exit 0
fi

echo "Appending AMD GPU parameters to kernel command line..."
echo "  $PARAMS"

# Backup
cp "$LIMINE_CONF" "${LIMINE_CONF}.bak.$(date +%s)"

# Append to the KERNEL_CMDLINE line
sed -i "/^KERNEL_CMDLINE/s|$| $PARAMS|" "$LIMINE_CONF"

echo "Done. Reboot to apply."
