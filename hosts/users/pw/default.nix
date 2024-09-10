{ ... }:
{

  users.users.pw = {
    name = "pw";
    home = "/Users/pw";
  };

  home-manager.users.pw.imports = [
    ../../../modules/home
    {
      home.stateVersion = "23.11";
      home.username = "pw";
    }
  ];

}
