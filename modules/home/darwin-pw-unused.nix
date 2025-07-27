# TODO: remove if unsued
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
      home.stateVersion = "25.05";
      home.username = username;
    }
  ];

}
