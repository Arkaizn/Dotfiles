#!/bin/bash

# setup openrgb
echo -e "${YELLOW}Do you want to install openrgb? (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            bash ./additions/openrgb/openrgb.sh
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
            bash ./additions/apps.sh
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            ;;
    esac

# 3. install zsh
echo -e "${YELLOW}When you install Zsh, it will prompt you to start using it. If you choose to do so, you can type 'exit' in Zsh to return to your previous shell, allowing the script to continue running.${NC}"
echo -e "${YELLOW}Do you want to install zsh and configure it? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Installing and configuring zsh...${NC}"
        bash ./scripts/zshinstall.sh
        ;;
    *)
        echo -e "${YELLOW}Skipping zsh installation.${NC}"
        ;;
esac

# install nvidia drivers for Maxwell (NV110) series and newer