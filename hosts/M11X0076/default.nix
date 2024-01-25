{ pkgs, ... }: {

  imports = [ ../../modules/darwin ];

  users.users."weiland.p" = {
    name = "Weiland, Pascal";
    home = "/Users/weiland.p";
  };

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."weiland.p".imports =
    [ ../../modules/home { home.stateVersion = "23.11"; } ];

}
