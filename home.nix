{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  # live symlink into the repo so edits apply without a switch
  link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
in {
  home.username = "jwallace";
  home.homeDirectory = if isDarwin then "/Users/jwallace" else "/home/jwallace";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # cli
    btop fd fzf gh git glow go grpcurl kubectl kubernetes-helm lazygit neovim
    oras ripgrep skopeo tmux tree uv yq-go
    cargo rustc
    nodejs pnpm
    tree-sitter

    # lsp
    bash-language-server clang-tools gopls lua-language-server nil pyright
    rust-analyzer terraform-ls typescript-language-server
    vscode-langservers-extracted yaml-language-server

    # formatters
    black isort prettier stylua
  ] ++ lib.optionals isLinux [ gcc ];

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

      secrets="''${XDG_CONFIG_HOME:-$HOME/.config}/secrets/work.env"
      [[ -r $secrets ]] && { set -a; source "$secrets"; set +a; }

      [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
      [[ -r ~/.kube-tools/kubech ]] && source ~/.kube-tools/kubech

      if command -v dx >/dev/null 2>&1 && dx env >/dev/null 2>&1; then
        eval "$(dx env)"
      fi
    '';
  };
}
