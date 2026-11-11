{
  lib,
  pkgs,
  isWork,
  link,
  ...
}:
lib.mkMerge [
  {
    home.file.".claude/CLAUDE.md".source = link "config/claude/CLAUDE.md";
  }

  # on work hosts dx owns the claude install and settings.json
  (lib.mkIf (!isWork) {
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
        spinnerTipsEnabled = false;
        disableBundledSkills = true;
        disableWorkflows = true;
        disableRemoteControl = true;
        disableClaudeAiConnectors = true;
        disableArtifact = true;
        permissions.defaultMode = "acceptEdits";
        permissions.allow = [
          "Bash(ls:*)"
          "Bash(cat:*)"
          "Bash(head:*)"
          "Bash(tail:*)"
          "Bash(grep:*)"
          "Bash(rg:*)"
          "Bash(find:*)"
          "Bash(wc:*)"
          "Bash(which:*)"
          "Bash(tree:*)"
          "Bash(git status:*)"
          "Bash(git diff:*)"
          "Bash(git log:*)"
          "Bash(git show:*)"
          "Bash(git branch:*)"
          "Bash(npm test:*)"
          "Bash(npm run lint:*)"
          "Bash(tsc:*)"
          "WebFetch"
          "WebSearch"
        ];
        permissions.ask = [
          "Bash(git push:*)"
          "Bash(git reset --hard:*)"
          "Bash(rm:*)"
          "Bash(git add:*)"
          "Bash(git commit:*)"
        ];
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
