{...}: {
  imports = [
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./ghostty.nix
    # other home-manager programs
    ./other.nix
  ];
}
