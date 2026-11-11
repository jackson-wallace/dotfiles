{ pkgs, link, ... }:
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

  imports = [ ./firefox.nix ];

  fonts.fontconfig.enable = true;

  xdg.configFile = {
    sway.source = link "config/sway";
    fuzzel.source = link "config/fuzzel";
    i3status-rust.source = link "config/i3status-rust";
    mako.source = link "config/mako";
  };
}
