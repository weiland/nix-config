{...}: let
  hostname = "Hopper";
  username = "pw";
in {
  imports = [
    ../../modules/darwin
    {
      networking.computerName = hostname;
      networking.hostName = hostname;
      networking.localHostName = hostname;
      system.defaults.smb.NetBIOSName = hostname;
      system.primaryUser = username;
    }
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # home-manager
  home-manager.users.${username}.imports = [
    ../../modules/home
    {
      home.username = username;
      home.homeDirectory = "/Users/${username}";
    }
  ];
}
