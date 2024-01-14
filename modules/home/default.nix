{
#   self,
inputs, config, pkgs, ... }: {
  imports = [ ../neovim ./home.nix ./programs.nix ];
}
