{
  pkgs,
  ...
}: {

  home.packages = with pkgs; [
      gemini-cli
  ];

  home.file = {
    ".gemini/settings.json" = {
      text = builtins.toJSON {
        general = {
          vimMode = true;
          enableAutoUpdate = false;
          enableAutoUpdateNotification = false;
          checkpointing = {
            enabled = true;
          };
          enablePromptCompletion = false;
          retryFetchErrors = false;
          debugKeystrokeLogging = false;
          sessionRetention = {
            enabled = true;
            maxAge = "2w";
            minRetention = "1d";
          };
          previewFeatures = true;
        };
        output = {
          format = "text";
        };
        ui = {
          theme = "ANSI";
          autoThemeSwitching = true;
          terminalBackgroundPollingInterval = 60;
          hideWindowTitle = false;
          inlineThinkingMode = "off";
          showStatusInTitle = false;
          dynamicWindowTitle = false;
          showHomeDirectoryWarning = true;
          hideTips = true;
          showShortcutsHint = true;
          hideBanner = true;
          hideContextSummary = false;
          footer = {
            hideCWD = false;
            hideSandboxStatus = false;
            hideModelInfo = false;
            hideContextPercentage = false;
          };
          hideFooter = false;
          showMemoryUsage = true;
          showLineNumbers = true;
          showCitations = false;
          showModelInfoInChat = false;
          showUserIdentity = true;
          useAlternateBuffer = false;
          useBackgroundColor = true;
          incrementalRendering = true;
          showSpinner = true;
          customWittyPhrases = [];
          accessibility = {
            enableLoadingPhrases = true;
            screenReader = false;
          };
        };
        ide = {
          enabled = false;
          hasSeenNudge = false;
        };
        privacy = {
          usageStatisticsEnabled = false;
        };
        tools = {
          shell = {
            enableInteractiveShell = true;
            pager = "bat";
            showColor = true;
            inactivityTimeout = 300;
            enableShellOutputEfficiency = true;
          };
        };
        useWriteTodos = true;
        security = {
          auth.selectedType = "oauth-personal";
          disableYoloMode = false;
          enablePermanentToolApproval = false;
          folderTrust = {
            enabled = true;
          };
        };
        context = {
          fileName = ["AGENTS.md" "GEMINI.md"];
        };
        experimental = {
          toolOutputMasking = {
            enabled = true;
            protectLatestTurn = true;
          };
          enableAgents = true;
          extensionManagement = true;
          extensionConfig = true;
          plan = true;
        };
        skills = {
          enabled = true;
        };
        hooksConfig = {
          enabled = true;
          notifications = true;
        };
        telemetry = {
          enabled = false;
        };
      };
    };
  };
}
