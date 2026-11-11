{ lib, isWork, link, ... }:
lib.mkIf isWork {
  home.file.".claude/rules/work.md".source = link "config/claude/work.md";

  programs.zsh.initContent = lib.mkAfter ''
    secrets="''${XDG_CONFIG_HOME:-$HOME/.config}/secrets/work.env"
    [[ -r $secrets ]] && { set -a; source "$secrets"; set +a; }

    [[ -r ~/.kube-tools/kubech ]] && source ~/.kube-tools/kubech

    if command -v dx >/dev/null 2>&1 && dx env >/dev/null 2>&1; then
      eval "$(dx env)"
    fi
  '';
}
