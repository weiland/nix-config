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
}
