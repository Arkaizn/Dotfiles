{ pkgs, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "alanpeabody";
      plugins = [ "git" "zsh-autosuggestions" "zsh-syntax-highlighting" ];
    };
  };

  home.packages = with pkgs; [
    nano curl wget fastfetch hyprland kitty hyprlock hyprcursor hyprshot hyprpicker
    xdg-desktop-portal-hyprland pacman-contrib pamixer ntfs3g p7zip wofi thunar
    waybar wlogout swaync cliphist swww cmake meson cpio pkg-config openssh iwd
    pavucontrol blueman gnome-calculator qimgv gdu
  ];

  home.file.".config" = {
    source = ../.config;
    recursive = true;
  };

  home.stateVersion = "23.11";
}
