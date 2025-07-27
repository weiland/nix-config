{...}: {
  programs.ssh = {
    enable = true;

    includes = ["~/Documents/Configs/ssh/private_ssh_config"];

    matchBlocks = {
      "*" = {
        identityFile = "~/Documents/Configs/ssh/id_pw";
        extraOptions = {
          HashKnownHosts = "yes";
          AddKeysToAgent = "yes";
          IgnoreUnknown = "UseKeychain";
          UseKeychain = "yes";
        };
      };
      "y" = {
        "hostname" = "spahr.uberspace.de";
        "user" = "y";
        extraOptions = {
          SetEnv = "LC_ALL=C";
        };
      };
    };
  };
}
