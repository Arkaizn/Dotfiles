#!/bin/bash

# Enable multilib repository
echo "Enabling multilib repository..."

# Use sed to uncomment the multilib lines in /etc/pacman.conf
sudo sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
sudo sed -i '/#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf

# Update package databases
echo "Updating package databases..."
sudo pacman -Sy

# Enable nvidia-drm.modeset=1 in GRUB for NVIDIA drivers
echo "Configuring GRUB to enable nvidia-drm.modeset=1..."

# Use sed to append nvidia-drm.modeset=1 to GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/"$/ nvidia-drm.modeset=1"/' /etc/default/grub

# Update GRUB configuration
echo "Updating GRUB configuration..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Add Early Loading of NVIDIA Modules
echo "Configuring mkinitcpio for early loading of NVIDIA modules..."

# Update MODULES line in /etc/mkinitcpio.conf
sudo sed -i 's/^MODULES=(.*)/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf

# Remove 'kms' from HOOKS line in /etc/mkinitcpio.conf
sudo sed -i 's/\(HOOKS=\(.*\)kms\(.*\)\)/\1\2/' /etc/mkinitcpio.conf

# Regenerate initramfs
echo "Regenerating initramfs..."
sudo mkinitcpio -P

# Adding the Pacman Hook
echo "Downloading and configuring the Pacman hook..."

# Download the nvidia.hook file while preserving the current directory
wget -O ~/nvidia.hook https://raw.githubusercontent.com/korvahannu/arch-nvidia-drivers-installation-guide/main/nvidia.hook

# Edit the nvidia.hook file to replace the target driver
echo "Editing nvidia.hook to set the target driver..."
sed -i 's/^Target=nvidia/Target=nvidia-470xx-dkms/' ~/nvidia.hook  # Replace nvidia with your installed driver

# Move the hook file to /etc/pacman.d/hooks/
echo "Moving nvidia.hook to /etc/pacman.d/hooks/..."
sudo mkdir -p /etc/pacman.d/hooks/ && sudo mv ~/nvidia.hook /etc/pacman.d/hooks/

# Cleanup: Remove the nvidia.hook file if it exists
if [ -f ~/nvidia.hook ]; then
    rm ~/nvidia.hook
    echo "Cleanup: Removed temporary nvidia.hook file."
fi

echo "Multilib repository enabled, package databases updated, GRUB configuration updated, mkinitcpio configured, and Pacman hook added successfully!"
