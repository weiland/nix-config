{ pkgs, ... }:
{

  imports = [
    ../../modules/darwin
    {
      networking.computerName = "Hopper";
      networking.hostName = "Hopper";
      networking.localHostName = "Hopper";
      system.defaults.smb.NetBIOSName = "Hopper";
    }
    ../users/pw
  ];

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

}
