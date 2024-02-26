{ pkgs, ... }: {

  imports = [
    ../../modules/darwin
    {
      networking.computerName = "Hopper MBP";
      networking.hostName = "Hopper";
      networking.localHostName = "Hopper";
      system.defaults.smb.NetBIOSName = "Hopper";
    }
  ];

  users.users.pw = {
    name = "pw";
    home = "/Users/pw";
  };

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.pw.imports = [
    ../../modules/home
    {
      home.stateVersion = "23.11";
      home.username = "pw";
    }
  ];

}
