{...}: {
  programs.tmux = {
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
}
