{ pkgs, ... }: {

  imports = [ ../../modules/darwin ];

  users.users.pw = {
    name = "pw";
    home = "/Users/pw";
  };

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.pw.imports =
    [ ../../modules/home { home.stateVersion = "23.11"; } ];

}
