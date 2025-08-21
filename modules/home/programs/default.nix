{ ... }:
{
  imports = [
    ./shell.nix
    ./bat.nix
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./ghostty.nix
    # other home-manager programs
    ./other-programs.nix
  ];
}
