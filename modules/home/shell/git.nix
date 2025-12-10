{
  ...
}:
{
  programs.git = {
    enable = true;
    # default user (using GitHub noreply email)
    settings = {
      user = {
        email = "weiland@users.noreply.github.com";
        name = "Pascal Weiland";
      };
      aliases = {
        identity = ''! git config user.name "$(git config user.$1.name)"; git config user.email "$(git config user.$1.email)"; git config user.signingkey "$(git config user.$1.signingkey)"; :'';
        prettylog = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        branches = "branch -a";
        remotes = "remote -v";
      };
      branch.sort = "-committerdate";
      core = {
        editor = "nvim";
        # faster `git status` (but rather locally)
        # fsmonitor = true;
        # untrackedCache = true;
      };
      credential.helper = "osxkeychain";
      commit = {
        # show the diff
        verbose = true;
      };
      column.ui = "auto";
      color = {
        ui = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      difftool.prompt = false;
      fetch = {
        all = true;
        prune = true;
        pruneTags = true;
      };
      help = {
        autocorrect = "prompt";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        log = true;
        conflictStyle = "zdiff3";
      };
      push = {
        default = "current"; # vs "simple"
        # autoSetupRemote = true; # not required if default is "current"
        followTags = true;
      };
      pull = {
        default = "current";
        ff = "only";
        # rebase = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      remote.origin = {
        prune = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      status = {
        showUntrackedFiles = "normal";
      };
      tag.sort = "version:refname";
      user.gmail = {
        email = "pasweiland@gmail.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdCIgV4GeKOXvYs4aPCQ4li8/5xLu7cpIpWzJIsFkb9";
      };
      user.gh = {
        email = "weiland@users.noreply.github.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdCIgV4GeKOXvYs4aPCQ4li8/5xLu7cpIpWzJIsFkb9";
      };
      # this used to break Swift Packages in Xcode
      url."git@github.com:" = {
        insteadOf = "https://github.com/";
        pushInsteadOf = "https://github.com/";
      };
    };
    ignores = [
      ".DS_Store"
      ".idea"
      # ignore jujutsu directories
      ".jj"
    ];
    includes = [
      {
        condition = "gitdir:~/Documents/Code/swrlab";
        contents = {
          user = {
            email = "pascal.weiland@ard.de";
          };
        };
      }
    ];
    lfs.enable = true;
    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdCIgV4GeKOXvYs4aPCQ4li8/5xLu7cpIpWzJIsFkb9";
      signByDefault = true;
    };
  };
  programs.delta = {
    enable = false;
    options = {
      navigate = true;
      line-numbers = true;
      syntax-theme = "Solarized (dark)";
    };
  };
  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
    };
  };
}
