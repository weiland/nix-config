{ pkgs, ... }:
{
  home.packages = with pkgs; [
    comic-mono
    departure-mono

    input-fonts
    julia-mono

    monaspace

    nerd-fonts.anonymice
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove # Cascadia-Code
    nerd-fonts.commit-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.hasklug
    nerd-fonts.geist-mono
    nerd-fonts.monaspace
    nerd-fonts.intone-mono
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.sauce-code-pro
    nerd-fonts.zed-mono
  ];
}
