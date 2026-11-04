# dotfiles

Standalone [home-manager](https://github.com/nix-community/home-manager) flake.

## Bootstrap

1. Install [Nix](https://nixos.org/download/) with flakes enabled.
2. Clone to `~/dotfiles`. The path is hardcoded in `home.nix`.

   ```sh
   git clone <repo-url> ~/dotfiles
   ```

3. Apply the config for this machine. Existing files are backed up with an `.hm-bak` suffix.

   ```sh
   nix run home-manager -- switch --flake ~/dotfiles#jwallace@Jwallace-Macbook16 -b hm-bak
   ```

   On Linux, use `#jwallace@linux`.

On macOS, casks and work tools still come from Homebrew.

## Update

```sh
nix flake update --flake ~/dotfiles
home-manager switch --flake ~/dotfiles#jwallace@Jwallace-Macbook16
```

Files in `config/` are symlinked into `~/.config`, so edits apply without a switch. Changes to `home.nix`, including zsh, need a switch.
