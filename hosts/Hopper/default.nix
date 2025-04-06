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
    }
    ../users/pw
  ];

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
