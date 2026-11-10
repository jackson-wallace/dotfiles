# dxManagesClaude: on work machines dx owns the claude install and settings.json
{ config, lib, dxManagesClaude, ... }:
lib.mkMerge [
  {
    home.file.".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/CLAUDE.md";
  }

  (lib.mkIf (!dxManagesClaude) {
    nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";

    programs.claude-code = {
      enable = true;
      mutableSettings = true; # merge into settings.json, keep it writable
      settings.enabledPlugins = {
        "mattpocock-skills@claude-plugins-official" = true;
      };
    };
  })
]
