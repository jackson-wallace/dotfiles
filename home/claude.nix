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

  # on work hosts dx owns the claude install; settings merge into its settings.json
  (lib.mkIf (!isWork) {
    nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";
  })

  {
    programs.claude-code = {
      enable = true;
      package = lib.mkIf isWork null;
      mutableSettings = true;
      settings = {
        editorMode = "vim";
        tui = "default"; # classic renderer so tmux copy-mode can scroll the session
        statusLine = {
          type = "command";
          command = toString (pkgs.writeShellScript "claude-statusline" ''
            input=$(cat)
            dir=$(echo "$input" | ${lib.getExe pkgs.jq} -r '.workspace.current_dir // .cwd')
            branch=$(${lib.getExe pkgs.git} -C "$dir" branch --show-current 2>/dev/null)
            echo "$input" | ${lib.getExe pkgs.jq} -r --arg b "$branch" '"\(if $b != "" then "\($b) | " else "" end)\(.model.display_name) | \(.context_window.used_percentage // 0 | floor)%"'
          '');
        };
        effortLevel = "medium";
        attribution.commit = "";
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
          "Bash(git clean:*)"
          "Bash(git branch -D:*)"
          "Bash(git checkout .:*)"
          "Bash(git restore .:*)"
          "Bash(git stash drop:*)"
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
  }
]
