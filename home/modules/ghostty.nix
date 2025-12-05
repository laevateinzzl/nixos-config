{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      # 基础设置
      font-family = "JetBrains Maple Mono";
      font-size = 12;
      font-weight = 400;
      font-style = "normal";

      # 行高和间距
      line-height = 1.2;
      letter-spacing = 0;

      # 主题配色（Catppuccin Mocha）
      theme = "Catppuccin-Mocha";

      # 自定义颜色覆盖
      background = "1e1e2e";
      foreground = "cdd6f4";
      cursor = "f5e0dc";
      cursor-background = "1e1e2e";
      cursor-foreground = "f5e0dc";

      # ANSI颜色
      color0 = "45475a";   # black
      color1 = "f38ba8";   # red
      color2 = "a6e3a1";   # green
      color3 = "f9e2af";   # yellow
      color4 = "89b4fa";   # blue
      color5 = "cba6f7";   # magenta
      color6 = "94e2d5";   # cyan
      color7 = "bac2de";   # white

      color8 = "585b70";   # bright black
      color9 = "f38ba8";   # bright red
      color10 = "a6e3a1";  # bright green
      color11 = "f9e2af";  # bright yellow
      color12 = "89b4fa";  # bright blue
      color13 = "cba6f7";  # bright magenta
      color14 = "94e2d5";  # bright cyan
      color15 = "a6e3e0";  # bright white

      # 透明度
      background-opacity = 0.95;
      window-opacity = 0.98;

      # 模糊效果
      background-blur = 10;
      window-blur = 5;

      # 边框和圆角
      window-border-width = 2;
      window-border-color = "89b4fa";
      window-border-radius = 8;
      padding-x = 8;
      padding-y = 8;

      # 标题栏
      window-theme = "dark";
      window-decoration = true;
      window-title-font-family = "JetBrains Maple Mono";
      window-title-font-size = 12;
      window-title-background-color = "1e1e2e";
      window-title-foreground-color = "cdd6f4";

      # 光标设置
      cursor-style = "block";
      cursor-blink = true;
      cursor-blink-rate = 500;
      cursor-color-blink = true;

      # 选择
      selection-foreground = "1e1e2e";
      selection-background = "89b4fa";
      selection-bold = true;

      # 滚动设置
      scroll-speed = 3;
      mouse-scroll-speed = 3;
      touch-scroll-speed = 3;
      smooth-scrolling = true;
      multi-scroll = true;

      # 历史记录
      history-limit = 100000;
      scroll-limit = 10000;
      unlimited-scrollback = true;

      # 键盘设置
      keybind = [
        # 基础操作
        "ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        # 标签页操作
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_tab"
        "ctrl+tab=next_tab"
        "ctrl+shift+tab=previous_tab"
        "ctrl+1=goto_tab:1"
        "ctrl+2=goto_tab:2"
        "ctrl+3=goto_tab:3"
        "ctrl+4=goto_tab:4"
        "ctrl+5=goto_tab:5"
        "ctrl+6=goto_tab:6"
        "ctrl+7=goto_tab:7"
        "ctrl+8=goto_tab:8"
        "ctrl+9=goto_tab:9"

        # 窗口操作
        "ctrl+shift+n=new_window"
        "ctrl+shift+q=quit"
        "ctrl+shift+r=reload_config"

        # 搜索
        "ctrl+shift+f=find"
        "ctrl+f=find_next"
        "ctrl+shift+g=find_previous"

        # 分割窗格
        "ctrl+shift+vertical=split:vertical"
        "ctrl+shift+horizontal=split:horizontal"
        "ctrl+shift+close=close_pane"
        "ctrl+shift+focus=focus_next_pane"

        # 字体大小
        "ctrl+equal=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+0=reset_font_size"

        # 其他
        "ctrl+shift+enter=spawn:ghostty --new-session"
        "ctrl+shift+o=browse"
        "f11=toggle_fullscreen"
      ];

      # 鼠标设置
      mouse-hide-while-typing = true;
      mouse-autohide = true;
      copy-on-select = true;
      paste-on-right-click = false;

      # 链接设置
      confirm-close-surface = false;
      command = ["zsh"];
      shell-integration = "detect";

      # 通知
      bell-style = "visual";
      bell-command = "notify-send -i utilities-terminal 'Ghostty' 'Bell rang'";
      audible-bell = false;

      # 窗口行为
      window-inherit-working-directory = true;
      window-inherit-font-size = false;
      window-save-state = "size,position,font-size";
      window-default-width = 800;
      window-default-height = 600;

      # 会话设置
      session = "default";
      confirm-close-surface = false;
      quit-after-last-window-closed = false;

      # 性能设置
      resize-delay = 0;
      redraw-delay = 0;
      gpu-acceleration = true;
      max-fps = 144;

      # Unicode和字体
      font-features = ["calt=1" "liga=1"];
      emoji-fallback = true;
      box-drawings = "both";

      # 终端特性
      term = "xterm-256color";
      COLORTERM = "truecolor";
      TERMINAL = "ghostty";

      # 调试选项
      debug-rendering = false;
      debug-keyboard = false;
      debug-fonts = false;

      # 高级设置
      custom-shell-integration-commands = ["zsh"];
      shell-integration-features = "cursor,sudo";
      spawn-first-pane-cwd = "current";

      # 扩展设置
      adjust-cursor-thickness = true;
      adjust-cell-width = true;
      adjust-font-baseline = true;

      # 主题变体（如果使用不同的Catppuccin变体）
      # theme = "Catppuccin-Frappe";  # 可选：Frappe
      # theme = "Catppuccin-Latte";   # 可选：Latte
      # theme = "Catppuccin-Macchiato"; # 可选：Macchiato
    };
  };

  # 附加配置文件
  home.file.".config/ghostty/themes/Catppuccin-Mocha".text = ''
    # Catppuccin Mocha主题
    background = 1e1e2e
    foreground = cdd6f4
    cursor = f5e0dc

    # Normal colors
    color0 = 45475a   # black (surface1)
    color1 = f38ba8   # red
    color2 = a6e3a1   # green
    color3 = f9e2af   # yellow
    color4 = 89b4fa   # blue
    color5 = cba6f7   # magenta
    color6 = 94e2d5   # cyan
    color7 = bac2de   # white (subtext1)

    # Bright colors
    color8 = 585b70   # bright black (surface2)
    color9 = f38ba8   # bright red
    color10 = a6e3a1  # bright green
    color11 = f9e2af  # bright yellow
    color12 = 89b4fa  # bright blue
    color13 = cba6f7  # bright magenta
    color14 = 94e2d5  # bright cyan
    color15 = a6e3e0  # bright white
  '';

  # 配置脚本
  home.packages = with pkgs; [
    # 相关工具
    wl-clipboard
    xclip
  ];
}
