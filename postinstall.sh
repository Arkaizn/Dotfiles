#!/bin/bash

# Set up OpenRGB
echo -e "${YELLOW}Do you want to install OpenRGB? (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            bash ./additions/openrgb/openrgb.sh
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            ;;
    esac

# Install some other applications
echo -e "${YELLOW}Do you want to install some other apps that you probably need? (browser, etc.) (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            bash ./additions/apps.sh
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            ;;
    esac

# Install Zsh
echo -e "${YELLOW}When you install Zsh, it will prompt you to start using it. If you choose to do so, you can type 'exit' in Zsh to return to your previous shell, allowing the script to continue running.${NC}"
echo -e "${YELLOW}Do you want to install Zsh and configure it? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Installing and configuring Zsh...${NC}"
        bash ./scripts/zshinstall.sh
        ;;
    *)
        echo -e "${YELLOW}Skipping Zsh installation.${NC}"
        ;;
esac

# Install NVIDIA drivers for Maxwell (NV110) series and newer
# Install Zsh
echo -e "${YELLOW}Do you want to install Nvidia Drivers for Maxwell (NV110) series and newer? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Installing and configuring Nvidia Drivers...${NC}"
        bash ./additions/nvidia-dkms.sh
        ;;
    *)
        echo -e "${YELLOW}Skipping Nvidia Driver installation.${NC}"
        ;;
esac

# add greeter with autologin and hyprlock

echo -e "${YELLOW}Do you want to set up greetd autologin with Hyprland? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Setting up greetd autologin...${NC}"
        sudo systemctl enable greetd.service
        sudo systemctl disable getty@tty1.service

        sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[initial_session]
command = "agreety --cmd Hyprland"
user = "greeter"

[default_session]
command = "Hyprland"
user = "arkaizn"
EOF
        echo -e "${GREEN}greetd autologin has been configured successfully.${NC}"
        ;;
    *)
        echo -e "${YELLOW}Skipping greetd setup.${NC}"
        ;;
esac
