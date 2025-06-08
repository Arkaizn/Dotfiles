{ pkgs, lib, ... }:
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

  ## Program configurations

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ../.config/kitty/kitty.conf;
  };

  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../.config/alacritty/alacritty.toml);
  };

  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../.config/fastfetch/config.jsonc);
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../.config/hypr/hyprland.conf;
  };

  programs.waybar.enable = true;

  programs.wlogout = {
    enable = true;
    style = builtins.readFile ../.config/wlogout/style.css;
    layout = [
      { label = "lock"; action = "~/.config/hypr/hyprlock/hyprlock.sh"; keybind = "l"; }
      { label = "hibernate"; action = "systemctl hibernate || loginctl hibernate"; keybind = "h"; }
      { label = "logout"; action = "hyprctl dispatch exit"; keybind = "e"; }
      { label = "shutdown"; action = "poweroff"; keybind = "s"; }
      { label = "suspend"; action = "systemctl suspend || loginctl suspend"; keybind = "u"; }
      { label = "reboot"; action = "systemctl reboot || loginctl reboot"; keybind = "r"; }
    ];
  };

  programs.wofi.enable = true;

  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../.config/swaync/config.json);
    style = builtins.readFile ../.config/swaync/style.css;
  };

  services.wayvnc.enable = true;

  ## Copy configuration files that don't have modules
  xdg.configFile = {
    "wal" = { source = ../.config/wal; recursive = true; };
    "waybar/config.jsonc".source = ../.config/waybar/config.jsonc;
    "waybar/style.css".source = ../.config/waybar/style.css;
    "waybar/scripts" = { source = ../.config/waybar/scripts; recursive = true; };
    "waybar/refresh.sh".source = ../.config/waybar/refresh.sh;
    "wofi/config".source = ../.config/wofi/config;
    "wofi/style.css".source = ../.config/wofi/style.css;
    "wlogout"."logout.png".source = ../.config/wlogout/logout.png;
    "wlogout"."power.png".source = ../.config/wlogout/power.png;
    "wlogout"."lock.png".source = ../.config/wlogout/lock.png;
    "wlogout"."pause.png".source = ../.config/wlogout/pause.png;
    "wlogout"."restart.png".source = ../.config/wlogout/restart.png;
    "wlogout"."sleep.png".source = ../.config/wlogout/sleep.png;
    "hypr/custom" = { source = ../.config/hypr/custom; recursive = true; };
    "hypr/hypridle.conf".source = ../.config/hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ../.config/hypr/hyprlock.conf;
    "hypr/hyprlock" = { source = ../.config/hypr/hyprlock; recursive = true; };
    "hypr/hyprshade.toml".source = ../.config/hypr/hyprshade.toml;
    "hypr/pyprland.toml".source = ../.config/hypr/pyprland.toml;
    "hypr/shaders" = { source = ../.config/hypr/shaders; recursive = true; };
    "hypr/wallpapers" = { source = ../.config/hypr/wallpapers; recursive = true; };
    "hypr/hyprland.conf.new".source = ../.config/hypr/hyprland.conf.new;
    "wayvnc/config".source = ../.config/wayvnc/config;
  };

  home.stateVersion = "23.11";
}
