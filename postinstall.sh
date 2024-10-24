#!/bin/bash

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

# install nvidia drivers for Maxwell (NV110) series and newer