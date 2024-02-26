{ pkgs, ... }: {

  imports = [
    ../../modules/darwin
    {
      networking.computerName = "Kare MBP";
      networking.hostName = "Kare";
      networking.localHostName = "Kare";
      system.defaults.smb.NetBIOSName = "Kare";
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
