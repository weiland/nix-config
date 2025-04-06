{ ... }:
let
  username = "pw";
in
{

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  home-manager.users.${username}.imports = [
    ../../../modules/home
    {
      home.stateVersion = "23.11";
      home.username = username;
    }
  ];

}
