{ config, pkgs, link, ... }:
{
  home.packages = with pkgs; [
    # desktop
    fuzzel i3status-rust mako libnotify
    swaylock swayidle
    grim slurp wl-clipboard
    brightnessctl bluetuith

    # apps
    ghostty
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };

  xdg.configFile = {
    sway.source = link "config/sway";
    fuzzel.source = link "config/fuzzel";
    i3status-rust.source = link "config/i3status-rust";
    mako.source = link "config/mako";
  };
}
