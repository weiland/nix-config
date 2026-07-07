{ ... }:
{
  imports = [
    ./homebrew.nix
    ./system.nix
    ../common/nix.nix
  ];

  # FIXME: remove when resolved https://github.com/nix-darwin/nix-darwin/issues/1817#issuecomment-4887465960
  # documentation.enable = false;
  # system.tools.darwin-uninstaller.enable = false;

  time.timeZone = "Europe/Berlin";

  programs.zsh.enable = true;
  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;
}
