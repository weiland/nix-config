{...}: {
  imports = [
    ./homebrew.nix
    ./system.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };
  nix.settings.experimental-features = "nix-command flakes";

  time.timeZone = "Europe/Berlin";

  # Make sure the nix daemon always runs
  # services.nix-daemon.enable = true;

  #   services.nix.package = pkgs.nixFlakes; # causes errors

  #   nix = {
  #       package = pkgs.nixFlakes;
  # 	  extraOptions = "experimental-features = nix-command flakes";
  # 	};

  environment = {
    # loginShell = pkgs.fish;
    # systemPackages = [ pkgs.rectangle ];
  };

  programs.zsh.enable = true; # for fallback Terminal
  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  launchd.user.agents.SSH-ADD.serviceConfig = {
    # serviceConfig.enable = true;
    Program = "/usr/bin/ssh-add";
    ProgramArguments = [
      "--apple-load-keychain"
    ];
    RunAtLoad = true;
    KeepAlive = false;
    StandardErrorPath = "/var/log/ssh-add-err.log";
    StandardOutPath = "/var/log/ssh-add-out.log";
  };
}
