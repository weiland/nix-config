{config, ...}: {
  launchd.agents.load-ssh-keys = {
    enable = true;
    config = {
      UserName = "${config.home.username}";
      ProgramArguments = [
        "/usr/bin/ssh-add"
        "--apple-load-keychain"
      ];
      RunAtLoad = true;
    };
  };

  xdg.enable = true;

  # prevents errors
  manual.manpages.enable = false;
}
