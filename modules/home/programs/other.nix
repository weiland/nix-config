{...}: {
  programs = {
    # TODO: disable next line? (since hm is controlled and invoked via nix-darwin)
    home-manager.enable = true;

    bat = {
      enable = true;
      config = {
        theme = "catppuccin-latte";
        italic-text = "always";
      };
    };

    # not as fast up to date as on homebrew
    # bun.enable = true;

    eza = {
      enable = true;
    };

    fd = {
      enable = true;
      # follow symlinks
      extraOptions = ["--follow"];
      # search for hidden dot-files
      hidden = true;
      # however ignore git and backups
      ignores = [
        ".git/"
        "*.bak"
      ];
    };

    gh = {
      enable = true;
      settings = {
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
        git_protocol = "ssh";
      };
    };

    ripgrep = {
      enable = true;
      arguments = [
        # "--hidden"
        "--max-columns=256"
        "--max-columns-preview"
        "--colors=line:style:bold"
        "--smart-case"
      ];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
