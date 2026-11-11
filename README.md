# dotfiles

Nix flake: [home-manager](https://github.com/nix-community/home-manager) homes for macOS and Linux, plus a NixOS host (`xps`) running sway.

## Bootstrap

1. Install [Nix](https://nixos.org/download/) with flakes enabled.
2. Clone to `~/dotfiles`. The path is hardcoded in `home/default.nix`.

   ```sh
   git clone <repo-url> ~/dotfiles
   ```

3. Apply the config for this machine. Existing files are backed up with an `.hm-bak` suffix.

   ```sh
   nix run home-manager -- switch --flake ~/dotfiles#jwallace@Jwallace-Macbook16 -b hm-bak
   ```

   Hosts: `jwallace@Jwallace-Macbook16` and `jacks@mac` (aarch64-darwin), `jwallace@linux` (x86_64-linux). Hosts with `isWork = true` in `flake.nix` get `home/work.nix` and skip the nix-managed Claude install.

   If Nix was installed without flakes enabled (official installer), the first run needs them turned on for just that invocation:

   ```sh
   NIX_CONFIG='experimental-features = nix-command flakes' \
     nix run home-manager -- switch --flake ~/dotfiles#jacks@mac -b hm-bak
   ```

   After the first switch, `nix.settings` in `home/default.nix` persists flakes to `~/.config/nix/nix.conf`, so later runs need no flag.

On macOS, casks and work tools still come from Homebrew.

## NixOS (xps)

System config lives in `hosts/xps/`, and home-manager runs as a NixOS module (home `jackson@xps`, with `home/sway.nix` on top of `home/`).

1. Use the graphical installer: wipe the disk, enable LUKS encryption, set user `jackson` and hostname `xps`.
2. Boot, then clone:

   ```sh
   nix-shell -p git --run 'git clone <repo-url> ~/dotfiles'
   ```

3. Replace the placeholder hardware config. If `/etc/nixos/configuration.nix` has any `boot.initrd.luks` lines, copy them into `hosts/xps/configuration.nix`. Also set `system.stateVersion` there to the installer's release.

   ```sh
   cp /etc/nixos/hardware-configuration.nix ~/dotfiles/hosts/xps/
   ```

4. Check the model and set the matching `nixos-hardware.nixosModules.dell-xps-13-<model>` in `flake.nix`:

   ```sh
   sudo dmidecode -s system-product-name
   ```

5. Apply, then commit the hardware config:

   ```sh
   sudo nixos-rebuild switch --flake ~/dotfiles#xps
   ```

After that, `sudo nixos-rebuild switch --flake ~/dotfiles` picks `xps` from the hostname. Kanata runs as root and reads `config/kanata/kanata.kbd` from the store, so changes to it need a rebuild. The other `config/` dirs are live links.

## Update

```sh
nix flake update --flake ~/dotfiles
home-manager switch --flake ~/dotfiles#jwallace@Jwallace-Macbook16
```

Files in `config/` are symlinked into `~/.config`, so edits apply without a switch. Changes to `home/*.nix`, including zsh, need a switch.
