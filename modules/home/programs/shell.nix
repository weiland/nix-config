{ pkgs, ... }: 
{
    programs = {

    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
      # loginShellInit = "" 
      shellInit = ''
        # Set syntax highlighting colours; var names defined here:
        #set fish_color_normal normal
        #set fish_color_command white
        #set fish_color_quote brgreen
        #set fish_color_redirection brblue
        #set fish_color_end white
        #set fish_color_error -o brred
        #set fish_color_param brpurple
        #set fish_color_comment --italics brblack
        #set fish_color_match cyan
        #set fish_color_search_match --background=brblack
        #set fish_color_operator cyan
        #set fish_color_escape white
        #set fish_color_autosuggestion brblack

        any-nix-shell fish --info-right | source

        # fix done command for ghostty
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
  };
}
