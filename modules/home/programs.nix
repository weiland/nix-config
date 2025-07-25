{ pkgs, ... }:
{
  programs = {
    # TODO: disable next line? (since hm is controlled and invoked via nix-darwin)
    home-manager.enable = true;

    bat = {
      enable = true;
      config = {
        theme = "Solarized (dark)";
        italic-text = "always";
      };
    };

    # often out of date
    # bun.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

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

    fish = {
      enable = true;
      plugins = [
        {
          name = "nix-env";
          src = pkgs.fetchFromGitHub {
            owner = "lilyball";
            repo = "nix-env.fish";
            rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
            sha256 = "069ybzdj29s320wzdyxqjhmpm9ir5815yx6n522adav0z2nz8vs4";
          };
        }
        {
          name = "done";
          src = pkgs.fetchFromGitHub {
            owner = "franciscolourenco";
            repo = "done";
            rev = "0bfe402753681f705a482694fcaf20c2bfc6deb7";
            sha256 = "0snjrqwa5ajv5fsx7sjx9lvpsclxdr0fbd43jr479ff1nc3863jq";
          };
        }
      ];
      # loginShellInit = '' # is invoked too often and too slowing down shell startup
      # ssh-add --apple-load-keychain
      # '';
      shellInit = ''
        # Set syntax highlighting colours; var names defined here:
        set fish_color_normal normal
        set fish_color_command white
        set fish_color_quote brgreen
        set fish_color_redirection brblue
        set fish_color_end white
        set fish_color_error -o brred
        set fish_color_param brpurple
        set fish_color_comment --italics brblack
        set fish_color_match cyan
        set fish_color_search_match --background=brblack
        set fish_color_operator cyan
        set fish_color_escape white
        set fish_color_autosuggestion brblack

        any-nix-shell fish --info-right | source

        # fix ghostty
        if test "$TERM_PROGRAM" = "ghostty"
          set __done_notification_command "echo -e \"\033]777;notify;\$title;\$message\a\""
        end
      '';
      interactiveShellInit = "";
      shellAliases = {
        afk = "open -a /System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine";
        dl = "cd ~/Downloads";
        du = "du -hs";
        rm = "rm -i";
        ping = "ping -c 5";
        la = "eza --long --all";
        ls = "eza";
        ll = "eza --long --sort newest";
        lla = "eza --long --all --sort newest";
        lock = "pmset sleepnow";
        mkdir = "mkdir -p";
        wifiname = "ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'";
        ql = "qlmanage -p 2>/dev/null";
      };

      shellAbbrs = {
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
        cat = "bat";
        ndsh = "nix run nix-darwin -- switch --flake .~/Documents/Code/nix-config#Hopper";
        ga = "git add";
        gap = "git add -p";
        gb = "git branch";
        gc = "git commit -v";
        gcm = "git switch main";
        gco = "git checkout";
        gcp = "git commit -vp";
        gd = "git diff";
        gds = "git diff --staged";
        gl = "git pull";
        gp = "git push";
        gpf = "git push --force-with-lease";
        gr = "git restore";
        gs = "git status";
        gss = "git status -sb";
        gsw = "git switch";
        gcb = "git switch -c";
        gsc = "git switch -c";
        npx = "npx --yes";
        rge = "rg -e";
        rgi = "rg -i";
        youtube-dl = "yt-dlp";
        ytdl = "yt-dlp --restrict-filenames -o '%(title)s.%(ext)s'";
      };
      functions = {
        cdf = {
          description = "Change to directory opened by Finder";
          body = ''
            if [ -x /usr/bin/osascript ]
              set -l target (osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
              if [ "$target" != "" ]
                cd "$target"; pwd
              else
                echo 'No Finder window found' >&2
              end
            end
          '';
        };
        ctrlp = {
          description = "Launch Neovim file finder from the shell";
          argumentNames = "hidden";
          body = ''
            if test -n "$hidden"
              nvim -c 'lua require(\'telescope.builtin\').find_files({hidden = true})'
            else
              nvim -c 'lua require(\'telescope.builtin\').find_files()'
            end
          '';
        };
        reload = {
          description = "reload fish config";
          body = "source ~/.config/fish/config.fish";
        };
        fish_greeting.body = "";
        fish_user_key_bindings = {
          description = "Set custom key bindings";
          body = ''
            bind \cp ctrlp
            # bind \cl 'ctrlp --hidden' # trouble in ghostty using cmd+k
          '';
        };
        k = {
          description = "Go to knowledge";
          body = ''
            cd ~/Documents/Code/knowledge
            nvim '+Telescope fd'
          '';
        };
        kk = {
          description = "Go to knowledge and livegrep";
          body = ''
            cd ~/Documents/Code/knowledge
            nvim '+Telescope live_grep'
          '';
        };
        til = {
          description = "Add TIL entry to Bear.app";
          body = ''
            open 'bear://x-callback-url/create?title=TIL&float=yes&new_window=yes&&timestamp=yes&edit=yes&tags=til,development%2Ftil&text='(string escape --style=url $argv)
          '';
        };
        tree = {
          description = "Tree of directory (aliasing eza)";
          body = ''
            command eza --tree --git-ignore --all --ignore-glob .git $argv
          '';
        };
        lastfm = {
          description = "Show lasftm data";
          body = ''
            set -q RECENTTRACKS || set RECENTTRACKS "/Users/$USER/.local/share/recenttracks.csv"

            if not test -f "$RECENTTRACKS"
              echo "Tracks $RECENTTRACKS file does not exist yet."
              echo 'Perhaps download new file? https://lastfm.ghan.nl/export/'
              return 1
            end

            if not type -q xan
              echo '"xan" is not installed'
              return 1
            end

            xan search -i "$argv" "$RECENTTRACKS" | xan select utc_time,artist,track,album | xan view --all
          '';
        };
        mkd = {
          description = "MKdir and cd into it.";
          body = ''
            mkdir -p $argv; and cd $argv
          '';
        };
        data_left = {
          description = "Display data volume left for Telekom Mobile. (Requires `htmlq` and a Telekom Mobile connection)";
          body = ''
            curl -sL https://pass.telekom.de | htmlq --text '.volume.fit-text-to-container, .remaining-duration'
          '';
        };
        sncf_login = {
          description = "sncf wifi login script";
          body = ''
            curl 'https://wifi.sncf/router/api/connection/activate/auto' -H 'Pragma: no-cache' -H 'Origin: https://wifi.sncf' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en,en-US;q=0.9,de;q=0.8,fr;q=0.7' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36' -H 'content-type: application/json' -H 'accept: application/json' -H 'Cache-Control: no-cache' -H 'Referer: https://wifi.sncf/en/internet/bot' -H 'Cookie: iob-context=f9vk6j; tracking-id=667b21ab-5f87-491b-ada7-9b2fa55ef7b4; io=ri3dEpOFq4J_m8VjAAAg; x-vsc-correlation-id=fbb43bed-4558-47f0-b610-8f4afda29cbe; gdpr-preferences={%22tracking%22:true%2C%22error%22:true%2C%22feedback%22:true}' -H 'Connection: keep-alive' -H 'DNT: 1' --data-binary '{}' --compressed
          '';
        };
        woi_login = {
          description = "Wifi@DB / WifiOnICE login script";
          body = ''
            curl -vk 'https://10.101.64.10/en/' -H 'Host: wifi.bahn.de' -H 'Cookie: csrf=asdf' --data 'login=true&CSRFToken=asdf'
          '';
        };
        zws = {
          description = "Puts a zero width joiner into the clipboard";
          body = "echo -n 'u200D' | pbcopy";
        };
      };
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

    git = {
      enable = true;
      userName = "Pascal Weiland";
      userEmail = "weiland@users.noreply.github.com";
      aliases = {
        identity = ''! git config user.name "$(git config user.$1.name)"; git config user.email "$(git config user.$1.email)"; git config user.signingkey "$(git config user.$1.signingkey)"; :'';
        prettylog = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        branches = "branch -a";
        remotes = "remote -v";
      };
      delta = {
        enable = false;
        options = {
          navigate = true;
          line-numbers = true;
          syntax-theme = "Solarized (dark)";
        };
      };
      difftastic = {
        enable = true;
      };
      extraConfig = {
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
        # gpg = {
        #   format = "ssh";
        #   ssh = {
        #     allowedSignersFile = "~/.ssh/allowed_signers";
        #   };
        # };
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
        # this breaks Swift Packages in Xcode
        # url."git@github.com:" = {
        #   insteadOf = "https://github.com/";
        #   pushInsteadOf = "https://github.com/";
        #};
      };
      ignores = [
        ".DS_Store"
        ".idea"
      ];
      includes = [
        {
          condition = "gitdir:~/Documents/Code";
          contents = {
            user = {
              email = "weiland@users.noreply.github.com";
            };
          };
        }
        {
          condition = "gitdir:~/src/weiland";
          contents = {
            user = {
              email = "weiland@users.noreply.github.com";
            };
          };
        }
        {
          condition = "gitdir:~/Documents/Code/rp-online";
          contents = {
            user = {
              email = "pascal.weiland@rp-digital.de";
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

    neovim = {
      enable = false; # done via xdg for proper lua support
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        command_timeout = 128;
        directory = {
          truncation_length = 5;
          truncation_symbol = "…/";
        };
        git_status.conflicted = "🤯";
        add_newline = true;
        right_format = "$time";
        time = {
          disabled = false;
          format = "[ $time ]($style) ";
          time_format = "%T";
        };
      };
    };

    ssh = {
      enable = true;

      includes = [ "~/Documents/Configs/ssh/private_ssh_config" ];

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

    tmux = {
      enable = true;

      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 133742;
      keyMode = "emacs"; # the vi mode does not yet feel right

      prefix = "C-s";
      newSession = true;
      terminal = "screen-256color";

      extraConfig = ''
        # Start window numbering at 1 (it hurts but it's faster to type)
        set -g base-index 1
        set -g pane-base-index 0
        set -g renumber-windows on
        set-window-option -g pane-base-index 1

        set-window-option -g automatic-rename on
        set -g set-titles on
        set -g set-titles-string '#T'

        # basic
        set -g status-keys "emacs" # the vim emulation is not as good

        # Switche between panes (without prefix key)
        # See: https://github.com/christoomey/vim-tmux-navigator
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'M-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        bind-key -n 'C-\' if-shell "$is_vim" 'send-keys C-\\\\'  'select-pane -l'

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l

        # re-bind existing new-window shortcut to open current directory
        bind c new-window -c '#{pane_current_path}'

        # reload tmux config
        bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"

        # kill it with fire
        bind Q send-keys "tmux kill-server" Enter

        bind-key s split-window -v -c '#{pane_current_path}'
        bind-key v split-window -h -c '#{pane_current_path}'

        # not so often used, but good
        bind-key - split-window -fv -c '#{pane_current_path}'
        bind-key \\ split-window -fh -c '#{pane_current_path}'

        # modify window size with Shift and Arrow keys
        bind -n S-Left resize-pane -L 2
        bind -n S-Right resize-pane -R 2
        bind -n S-Down resize-pane -D 1
        bind -n S-Up resize-pane -U 1

        # resize panes size with larger sizes using Shift and Arrow keys
        bind -n C-Left resize-pane -L 10
        bind -n C-Right resize-pane -R 10
        bind -n C-Down resize-pane -D 5
        bind -n C-Up resize-pane -U 5

        bind-key -r < swap-window -t -1
        bind-key -r > swap-window -t +1

        # break pane out detached (move it to new window in the background)
        bind b break-pane -d

        # bind C-j split-window -v "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
        # jump to another session/window/pane (or just see what's going on)
        bind C-j choose-tree

        # toggle mouse mode
        # bind-key m setw mouse

        # improve scrolling and mouse support
        set -g mouse on
        set -g terminal-overrides 'xterm*:smcup@:rmcup@' # does the same as mouse on
        bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e; send-keys -M'"

        # Statusbar
        set -g status on
        set -g status-position top
        set -g status-justify centre # center window list for clarity
        set -g status-bg colour235 #base02
        set -g status-fg '#eeeeee'
        # set -g status-attr dim #invalid TODO

        set -g status-left-length 75
        set -g status-left "[#{session_name}] #[fg=green]#h  #[fg=brightblue]#(dig +short myip.opendns.com @resolver1.opendns.com) #[fg=yellow]#(ifconfig en0 | grep 'inet ' | awk '{print \"en0 \" $2}') #(ifconfig en1 | grep 'inet ' | awk '{print \"en1 \" $2}') #(ifconfig en3 | grep 'inet ' | awk '{print \"en3 \" $2}') #[fg=red]#(ifconfig tun0 | grep 'inet ' | awk '{print \"vpn \" $2}') #[fg=green]#(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk -F': ' '/ SSID/{print $2}') "

        set-window-option -g clock-mode-style 24

        set -g status-right-length 75
        # set -g status-right "#[fg=blue]#S #I:#P #[fg=yellow]: %d %b %Y #[fg=green]: %l:%M %p : #(date -u | awk '{print $4}') :"
        # set -g status-right "#{?client_prefix,PREFIX ,}#{?window_zoomed_flag,🔍, } #{weather} #(battery -t) %a %d. %b  %H:%M"
        # set-option -g @tmux-weather-location "Darmstadt"


        set-option -g window-status-format '#{window_index}:#{window_name}'
        set-option -g window-status-current-format '[#{window_index}:#{window_name}]'

        # window status
        set-window-option -g window-status-style fg=brightblue #base0
        set-window-option -g window-status-style bg=colour236
        set-window-option -g window-status-style dim

        set-window-option -g window-status-current-style fg=brightred #orange
        set-window-option -g window-status-current-style bg=colour236
        set-window-option -g window-status-current-style bright

        # using clipboard and scrolling
        # Use vim keybindings in copy mode
        setw -g mode-keys vi

        # Set that stupid Esc-Wait off, so VI works again
        set-option -sg escape-time 0

        # set -g default-command 'fish' # is not necessary

        # Setup 'v' to begin selection as in Vim
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "pbcopy"
        bind-key -T copy-mode-vi 'V' send -X select-line

        # Update default binding of `Enter` to also use copy-pipe
        # bind-key -T copy-mode-vi Enter copy-pipe "reattach-to-user-namespace pbcopy"

      '';
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
