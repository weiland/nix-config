{ ... }:
let
  hostname = "Hopper";
in
{
  imports = [
    ../../modules/darwin
    {
      networking.computerName = hostname;
      networking.hostName = hostname;
      networking.localHostName = hostname;
      system.defaults.smb.NetBIOSName = hostname;
      system.primaryUser = "pw";
    }
    ../users/pw
  ];

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-backup";
}
