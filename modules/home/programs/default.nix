{ ... }:
{
  imports = [
    ../shell/default.nix
    ./jujutsu.nix
    ./ssh.nix
    # ./tmux.nix
    ./ghostty.nix
    # other home-manager programs
    ./other-programs.nix
  ];
}
