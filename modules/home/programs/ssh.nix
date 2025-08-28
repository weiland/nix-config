{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/Documents/Configs/ssh/private_ssh_config" ];
  };
}
