{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "xps";
  networking.networkmanager.enable = true;

  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  users.users.jackson = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # sway itself; user-side tools and config come from home/sway.nix
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
  };

  # caps: esc on tap, ctrl on hold; esc: caps
  services.kanata = {
    enable = true;
    keyboards.default.config = builtins.readFile ../../config/kanata/kanata.kbd;
    # needed so tap-hold-press sees other keys and triggers ctrl
    keyboards.default.extraDefCfg = "process-unmapped-keys yes";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [ git ];

  # match the nixos release the installer used; never bump after install
  system.stateVersion = "26.05";
}
