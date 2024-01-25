{ pkgs, ... }: {

  imports = [ ./homebrew.nix ./system.nix ];

  system.stateVersion = 4;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Berlin";

  # TODO: Wireguard

  # networking.dns = [ "1.1.1.1" "1.0.0.1" ]

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;

  #   services.nix.package = pkgs.nixFlakes; # causes errors

  #   nix = {
  #       package = pkgs.nixFlakes;
  # 	  extraOptions = "experimental-features = nix-command flakes";
  # 	};

  # TODO: look into build-machines (i.e. VM or even GitHub Action running macOS)

  environment = {
    # 		loginShell = pkgs.fish;
    # 		systemPackages = my_software_pgks.nix;
    # systemPackages = [ pkgs.rectangle ]; # TODO: does it work?
  };

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true; # for fallback Terminal
  programs.fish.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  launchd.user.agents.SSH-ADD = {
    serviceConfig.ProgramArguments =
      [ "/usr/bin/ssh-add" "--apple-load-keychain" ];
    serviceConfig.RunAtLoad = true;
    serviceConfig.StandardErrorPath = "/var/log/ssh-add-err.log";
    serviceConfig.StandardOutPath = "/var/log/ssh-add-out.log";
  };

  # users.users.pw = {
  # 	name = "pw";
  # 	home = "/Users/pw";
  # };

  # home-manager
  #  home-manager.useGlobalPkgs = true;
  #   home-manager.useUserPackages = true;
  #   home-manager.users.pw.imports = [../../modules/home { home.stateVersion = "23.05"; }];
  # https://github.com/sxyazi/dotfiles/blob/main/nix/flake.nix

}
