# dotfiles

Nix flake: [home-manager](https://github.com/nix-community/home-manager) homes for macOS, plus a NixOS host (`xps`) running sway.

| Machine | Flake target | OS |
| --- | --- | --- |
| Work MacBook | `jwallace@Jwallace-Macbook16` | macOS (aarch64), `isWork = true` |
| Personal Mac | `jacks@mac` | macOS (aarch64) |
| Dell XPS | `xps` | NixOS |

The repo must live at `~/repos/dotfiles`. The path is hardcoded in `home/default.nix`.

## Work MacBook (`jwallace@Jwallace-Macbook16`)

Gets `home/work.nix` and skips the nix-managed Claude install (settings still merge into dx's `settings.json`).

1. Install [Nix](https://nixos.org/download/).
2. Clone and apply. Existing files are backed up with an `.hm-bak` suffix.

   ```sh
   git clone https://github.com/jackson-wallace/dotfiles.git ~/repos/dotfiles
   NIX_CONFIG='experimental-features = nix-command flakes' \
     nix run home-manager -- switch --flake ~/repos/dotfiles#jwallace@Jwallace-Macbook16 -b hm-bak
   ```

Update:

```sh
nix flake update --flake ~/repos/dotfiles
home-manager switch --flake ~/repos/dotfiles#jwallace@Jwallace-Macbook16 -b hm-bak
```

## Personal Mac (`jacks@mac`)

1. Install [Nix](https://nixos.org/download/).
2. Clone and apply:

   ```sh
   git clone https://github.com/jackson-wallace/dotfiles.git ~/repos/dotfiles
   NIX_CONFIG='experimental-features = nix-command flakes' \
     nix run home-manager -- switch --flake ~/repos/dotfiles#jacks@mac -b hm-bak
   ```

Update:

```sh
nix flake update --flake ~/repos/dotfiles
home-manager switch --flake ~/repos/dotfiles#jacks@mac -b hm-bak
```

On both Macs, casks and work tools still come from Homebrew. You only need `NIX_CONFIG` on the first run. After that, `nix.settings` in `home/default.nix` keeps flakes enabled through `~/.config/nix/nix.conf`.

## Dell XPS (`xps`, NixOS)

System config lives in `hosts/xps/`. Home-manager runs as a NixOS module (user `jackson`, with `home/sway.nix` added on top of `home/`).

1. Use the graphical installer: wipe the disk, enable LUKS encryption, and set user `jackson` and hostname `xps`.
2. Boot, then clone:

   ```sh
   nix-shell -p git --run 'git clone https://github.com/jackson-wallace/dotfiles.git ~/repos/dotfiles'
   ```

3. Replace the placeholder hardware config. If `/etc/nixos/configuration.nix` has any `boot.initrd.luks` lines, copy them into `hosts/xps/configuration.nix`. Also set `system.stateVersion` there to the installer's release.

   ```sh
   cp /etc/nixos/hardware-configuration.nix ~/repos/dotfiles/hosts/xps/
   ```

4. Check the model. If it isn't `7390`, change `nixos-hardware.nixosModules.dell-xps-13-7390` in `flake.nix` to match.

   ```sh
   sudo dmidecode -s system-product-name
   ```

5. Apply, then commit the hardware config:

   ```sh
   sudo nixos-rebuild switch --flake ~/repos/dotfiles#xps
   ```

Update:

```sh
nix flake update --flake ~/repos/dotfiles
sudo nixos-rebuild switch --flake ~/repos/dotfiles#xps
```

Kanata runs as root and reads `config/kanata/kanata.kbd` from the store, so changes to it need a rebuild.

## Editing

Files in `config/` are symlinked into `~/.config`, so edits apply without a switch. Changes to `home/*.nix`, including zsh, need a switch (or a rebuild on the xps).
