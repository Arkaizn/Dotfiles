#!/bin/bash
#use this site to make: https://github.com/korvahannu/arch-nvidia-drivers-installation-guide/tree/main
sudo pacman -Syu
sudo pacman -S base-devel linux-headers git nano --needed
yay -Syu

# for 4070 graphics card
yay -S nvidia-dkms nvidia-utils lib32-nvidia-utils

set -euo pipefail

# If you pass a driver name, it’ll use that; otherwise default to nvidia-dkms
DRIVER="${1:-nvidia-dkms}"
HOOK_URL="https://raw.githubusercontent.com/korvahannu/arch-nvidia-drivers-installation-guide/main/nvidia.hook"
HOOK_FILE="nvidia.hook"
DEST_DIR="/etc/pacman.d/hooks"

echo "➤ Downloading nvidia.hook…"
wget -qO "${HOOK_FILE}" "${HOOK_URL}" \
  || { echo "❌ Download failed."; exit 2; }

echo "➤ Rewriting Target to '${DRIVER}'…"
if grep -q '^Target=nvidia$' "${HOOK_FILE}"; then
  sed -i "s/^Target=nvidia$/Target=${DRIVER}/" "${HOOK_FILE}"
else
  echo "⚠️  Couldn’t find 'Target=nvidia'—check the hook file."
fi

echo "➤ Installing hook into ${DEST_DIR}…"
sudo mkdir -p "${DEST_DIR}"
sudo mv "./${HOOK_FILE}" "${DEST_DIR}/"

echo "✅ Hook live at ${DEST_DIR}/${HOOK_FILE} targeting ${DRIVER}"