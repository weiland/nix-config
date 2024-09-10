{ pkgs, ... }:
{

  imports = [
    ../../modules/darwin
    {
      networking.computerName = "M11X0076";
      networking.hostName = "M11X0076";
      networking.localHostName = "M11X0076";
      system.defaults.smb.NetBIOSName = "M11X0076";
    }
  ];

  users.users."weiland.p" = {
    name = "weiland.p";
    description = "Weiland, Pascal";
    home = "/Users/weiland.p";
  };

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."weiland.p".imports = [
    ../../modules/home
    {
      home.stateVersion = "23.11";
      home.username = "weiland.p";
    }
  ];

}
