{
  config,
  lib,
  pkgs,
  host,
  ...
}:
let
  # on work machine dx owns the claude install and settings.json
  shouldInstallClaude = host != "jwallace@Jwallace-Macbook16";
in
lib.mkMerge [
  {
    home.file.".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/CLAUDE.md";
  }

  (lib.mkIf (shouldInstallClaude) {
    nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";

    programs.claude-code = {
      enable = true;
      mutableSettings = true;
      settings = {
        editorMode = "vim";
        tui = "default"; # classic renderer so tmux copy-mode can scroll the session
        statusLine = {
          type = "command";
          command = ''${lib.getExe pkgs.jq} -r '"\(.model.display_name) | \(.context_window.used_percentage // 0 | floor)%"' '';
        };
        enabledPlugins = {
          "mattpocock-skills@claude-plugins-official" = true;
        };
        autoMemoryEnabled = false;
        disableBundledSkills = true;
        disableWorkflows = true;
        disableRemoteControl = true;
        disableClaudeAiConnectors = true;
        disableArtifact = true;
        permissions.deny = [
          "EnterPlanMode"
          "ExitPlanMode"
          "DesignSync"
          "NotebookEdit"
          "SendMessage"
          "PushNotification"
          "RemoteTrigger"
          "ReportFindings"
          "ScheduleWakeup"
          "AskUserQuestion"
          "CronCreate"
          "CronDelete"
          "CronList"
        ];
      };
    };
  })
]
