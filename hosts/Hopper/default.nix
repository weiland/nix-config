{ ... }:
let
  hostname = "Hopper";
  username = "pw";
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
    # ./darwin-pw
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # home-manager
  home-manager.users.${username}.imports = [
    ../../modules/home
    # set/overwrite the username
    {
      home.username = username;
    }
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-backup";
}
