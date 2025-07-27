{ pkgs, ... }:
{

  imports = [
    ./homebrew.nix
    ./system.nix
  ];

  system.stateVersion = 5;

  nixpkgs.config = {
    allowUnfree = true;
    # for input-fonts https://input.djr.com/
    input-fonts.acceptLicense = true;
  };
  #nixpkgs.hostPlatform = "aarch64-darwin";

  time.timeZone = "Europe/Berlin";

  # TODO: Wireguard

  # networking.dns = [ "1.1.1.1" "1.0.0.1" ]

  # Make sure the nix daemon always runs
  # services.nix-daemon.enable = true;

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

  security.pam.services.sudo_local.touchIdAuth = true;

  launchd.agents.load-ssh-keys = {
    enable = true;
    config = {
      UserName = "pw";
      RunAtLoad = true;
      ProgramArguments = [ "/usr/bin/ssh-add" "--apple-load-keychain" ];
      StandardErrorPath = "/var/log/ssh-add-err.log";
      StandardOutPath = "/var/log/ssh-add-out.log";
    };
  };
}
