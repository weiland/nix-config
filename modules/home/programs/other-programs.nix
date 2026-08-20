{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;

    # not as fast up to date as on homebrew
    bun.enable = true;

    eza = {
      enable = true;
    };

    fd = {
      enable = true;
      # follow symlinks
      extraOptions = [ "--follow" ];
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

    opencode = {
      enable = true;
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

    yt-dlp = {
      enable = false;
      extraConfig = ''
        --output ~/Downloads/Videos/%(webpage_url_domain)s--%(playlist|no-playlist)s--%(title)s--%(id)s.%(ext)s

        # Use only ASCII characters, and avoid "&" and spaces in filenames
        --restrict-filenames

        # --download-archive ~/Downloads/Videos/ytdlp-already-downloaded-videos.txt

        # mark watched (even with --simulate) NOTE: can be annoying when playing around
        --mark-watched
      '';
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # home.packages = with pkgs; [ ollama ];
}
