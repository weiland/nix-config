{...}: {
  imports = [
    ./homebrew.nix
    ./system.nix
    ../common/nix.nix
  ];

  time.timeZone = "Europe/Berlin";

  programs.zsh.enable = true;
  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  launchd.user.agents.SSH-ADD.serviceConfig = {
    ProgramArguments = [
      "/usr/bin/ssh-add"
      "--apple-load-keychain"
    ];
    RunAtLoad = true;
    KeepAlive = false;
    StandardErrorPath = "/var/log/ssh-add-err.log";
    StandardOutPath = "/var/log/ssh-add-out.log";
  };
}
