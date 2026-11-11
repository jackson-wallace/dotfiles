{ config, lib, pkgs, username, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  # live symlink into the repo so edits apply without a switch
  link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles/${path}";
in {
  imports = [ ./claude.nix ./languages.nix ./work.nix ];

  _module.args.link = link;

  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home.packages = with pkgs; [
    # cli
    btop fd fzf gh git grpcurl kubectl kubernetes-helm lazygit neovim
    oras ripgrep skopeo tmux tree yq-go
    tree-sitter
  ];

  xdg.configFile = {
    nvim.source = link "config/nvim";
    ghostty.source = link "config/ghostty";
    git.source = link "config/git";
    tmux.source = link "config/tmux";
  } // lib.optionalAttrs isDarwin {
    aerospace.source = link "config/aerospace";
    karabiner.source = link "config/karabiner";
  };

  home.file.".local/scripts".source = link "scripts";

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.local/scripts"
    "$HOME/go/bin"
  ] ++ lib.optionals isDarwin [ "$HOME/Library/pnpm" ];

  home.sessionVariables = lib.optionalAttrs isDarwin {
    PNPM_HOME = "$HOME/Library/pnpm";
  };

  programs.zsh = {
    enable = true;
    localVariables = {
      VI_MODE_RESET_PROMPT_ON_CHANGE = true;
      VI_MODE_SET_CURSOR = true;
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "vi-mode" ];
    };
    shellAliases = {
      ta = "tmux attach";
      tt = "tmux attach -t";
      tl = "tmux list-sessions";
      tn = "tmux new-session -s";
      lg = "lazygit";
      ld = "lazydocker";
      k = "kubectl";
    };
    profileExtra = lib.optionalString isDarwin ''
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
      # keep the nix profile ahead of homebrew so nix-managed tools always win
      export PATH="$HOME/.nix-profile/bin:$PATH"
    '';
    initContent = ''
      bindkey -v
      bindkey -s ^f "tmux-sessionizer\n"

      hp() {
        local selected
        selected=$(history 1 | awk '{$1="";print substr($0,2)}' | fzf --tac --no-sort --height=40% --reverse --prompt="History > ")
        if [[ -n "$selected" ]]; then
          print -z "$selected"
        fi
      }

      [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
    '';
  };
}
