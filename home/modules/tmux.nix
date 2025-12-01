{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    terminal = "tmux-256color";

    # 快捷键设置
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 50000;

    # 额外配置
    extraConfig = ''
      # Catppuccin Mocha主题
      # 颜色定义
      set -g @catppuccin_flavour 'mocha'

      # 基础设置
      set -g mouse on
      set -g focus-events on
      set -g default-terminal "tmux-256color"
      set -sa terminal-overrides ",*256col*:Tc"

      # 状态栏
      set -g status-position bottom
      set -g status-justify left
      set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
      set -g status-left-length 40
      set -g status-right-length 50

      # 状态栏左侧
      set -g status-left "#[fg=#89b4fa,bg=#1e1e2e,bold] #S #[fg=#a6e3a1,bg=#1e1e2e] #(whoami) #[fg=#cba6f7,bg=#1e1e2e] #I:#P "

      # 状态栏右侧
      set -g status-right "#[fg=#f9e2af,bg=#1e1e2e] %H:%M #[fg=#94e2d5,bg=#1e1e2e] %Y-%m-%d "

      # 窗口标签
      set -g window-status-format "#[fg=#a6adc8,bg=#313244] #I #[fg=#a6adc8,bg=#313244] #W #[fg=#a6adc8,bg=#313244] #F "
      set -g window-status-current-format "#[fg=#cdd6f4,bg=#89b4fa,bold] #I #[fg=#cdd6f4,bg=#89b4fa] #W #[fg=#cdd6f4,bg=#89b4fa] #F "
      set -g window-status-separator ""

      # 窗格分隔符
      set -g pane-active-border-style "fg=#89b4fa"
      set -g pane-border-style "fg=#585b70"

      # 命令行
      set -g message-style "fg=#cdd6f4,bg=#45475a"
      set -g message-command-style "fg=#cdd6f4,bg=#45475a"

      # 复制模式
      setw -g mode-style "fg=#cdd6f4,bg=#45475a"

      # 窗格编号显示
      set -g display-panes-active-colour "#89b4fa"
      set -g display-panes-colour "#a6e3a1"

      # 时钟
      setw -g clock-mode-colour "#f9e2af"

      # 快捷键绑定
      # 修改前缀键为Ctrl-Space
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      # 窗格操作
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # 窗格导航
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # 窗格大小调整
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # 窗格重排
      bind Space next-layout
      bind b previous-layout

      # 复制模式
      bind Enter copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi r send -X rectangle-toggle
      bind -T copy-mode-vi Escape send -X cancel
      bind p paste-buffer

      # 窗口导航
      bind -r n next-window
      bind -r p previous-window
      bind 0 select-window -t :10

      # 窗口交换
      bind -r < swap-window -t -1
      bind -r > swap-window -t +1

      # 会话操作
      bind d detach-client
      bind D choose-client

      # 重加载配置
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # 同步窗格
      bind e setw synchronize-panes on
      bind E setw synchronize-panes off

      # 清理历史记录
      bind C-l send-keys "C-l"

      # 监控活动
      setw -g monitor-activity on
      set -g visual-activity on

      # 自动窗口重命名
      setw -g automatic-rename on
      set -g renumber-windows on

      # 环境变量
      set-environment -g COLORTERM "truecolor"
      set-environment -g TERM "tmux-256color"

      # tmux插件管理器配置（如果使用）
      # 在插件列表中添加：tmuxPlugins.catppuccin
      # 然后取消下面的注释
      # set -g @catppuccin_window_tabs_enabled on
      # set -g @catppuccin_status_left_separator "█"
      # set -g @catppuccin_status_right_separator ""
      # set -g @catppuccin_status_middle_separator "█"
    '';

    # 插件
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_middle_separator "█"
          set -g @catppuccin_status_modules "application session user host date_time"
          set -g @catppuccin_application_icon " "
          set -g @catppuccin_session_icon " "
        '';
      }

      tmuxPlugins.yank
      tmuxPlugins.sensible
      tmuxPlugins.pain-control
      tmuxPlugins.copycat
      tmuxPlugins.open
    ];
  };

  # tmux会话管理脚本
  home.packages = with pkgs; [
    (writeShellScriptBin "tmux-sessionizer" ''
      #!/bin/sh
      # tmux会话管理脚本

      if [[ $# -eq 1 ]]; then
          selected=$1
      else
          # 使用fzf选择目录
          selected=$(find ~/ ~/work ~/projects -mindepth 1 -maxdepth 1 -type d | fzf)
      fi

      if [[ -z $selected ]]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux)

      if [[ -z $tmux_running ]]; then
          tmux new-session -s $selected_name -c $selected
          exit 0
      fi

      if ! tmux has-session -t=$selected_name 2>/dev/null; then
          tmux new-session -ds $selected_name -c $selected
      fi

      tmux switch-client -t $selected_name
    '')

    (writeShellScriptBin "tmux-kill-session" ''
      #!/bin/sh
      # tmux会话终止脚本

      if [[ $# -eq 0 ]]; then
          session=$(tmux list-sessions -F "#{session_name}" | fzf --header="Select session to kill")
      else
          session=$1
      fi

      if [[ -n $session ]]; then
          tmux kill-session -t "$session"
          echo "Killed session: $session"
      fi
    '')

    (writeShellScriptBin "tmux-attach" ''
      #!/bin/sh
      # tmux会话连接脚本

      if [[ $# -eq 0 ]]; then
          if tmux has-session 2>/dev/null; then
              session=$(tmux list-sessions -F "#{session_name}" | fzf --header="Select session to attach")
          else
              echo "No tmux sessions found"
              exit 1
          fi
      else
          session=$1
      fi

      if [[ -n $session ]]; then
          tmux attach-session -t "$session"
      fi
    '')
  ];

  # 配置tmuxinator（项目管理工具）
  programs.tmuxinator = {
    enable = true;

    # 示例项目配置
    configurations = {
      dev = {
        name = "dev";
        root = "~/work";
        windows = [
          {
            editor = "nvim";
          }
          {
            terminal = "";
          }
          {
            server = "";
          }
        ];
      };

      nixos = {
        name = "nixos";
        root = "~/nixos-config";
        windows = [
          {
            editor = "nvim";
          }
          {
            config = "cd /etc/nixos && sudo nvim configuration.nix";
          }
          {
            terminal = "";
          }
        ];
      };
    };
  };
}