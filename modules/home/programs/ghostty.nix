{config, ...}: {
  programs.ghostty = {
    # is marked as broken :c
    # enable = true;
    # enableFishIntegration = true;
    settings = {
      maximize = true;

      clipboard-read = "allow";
      clipboard-write = "allow";

      # clipboard-paste-protection = false
      copy-on-select = "clipboard";

      link-url = true;

      window-colorspace = "display-p3";
      window-theme = "system";

      theme = "light:catppuccin-latte,dark:catppuccin-macchiato";

      font-family = "JetBrainsMono NFM Regular";
      font-size = 12;
      cursor-style-blink = false;

      macos-non-native-fullscreen = true;

      macos-titlebar-style = "tabs";

      quit-after-last-window-closed = true;

      auto-update = "check";

      command = "/etc/profiles/per-user/${config.home.username}/bin/fish --login --interactive";
      # shell-integration = fish # default is detect

      keybind = ["global:alt+space=toggle_visibility"];
    };
  };
}
