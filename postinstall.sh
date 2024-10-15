#!/bin/bash

# install gnome themes and icons...
echo -e "${YELLOW}Do you want to install gnome tweaks? (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            sudo pacman -S gnome-tweaks --noconfirm
            mkdir ~/.themes
            mkdir ~/.icons
            cp -r ./systemconfig/themes/* ~/.themes/
            cp -r ./systemconfig/icons/* ~/.icons/
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            ;;
    esac

# setup openrgb
echo -e "${YELLOW}Do you want to install openrgb? (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            bash ./dotfiles/openrgbconf/openrgb.sh
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            ;;
    esac

# install some other apps
echo -e "${YELLOW}Do you want to install some other apps that you probably need?(browser,...) (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            bash ./systemconfig/apps.sh
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            ;;
    esac

# install extensions
echo -e "${YELLOW}Do you want to install gnome extensions, is needed for the theme of gnome. (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            bash ./systemconfig/gnomeextensions.sh
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            ;;
    esac

# install nvidia drivers for Maxwell (NV110) series and newer