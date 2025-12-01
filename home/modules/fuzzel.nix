{ config, pkgs, lib, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        line-height = 25;
        letter-spacing = 1;

        # 主题配色
        background = "1e1e2eff";
        text = "cdd6f4ff";
        match = "89b4faff";
        selection = "45475aff";
        selection-text = "cdd6f4ff";
        selection-match = "89b4faff";
        border = "89b4faff";

        # 布局
        lines = 15;
        width = 50;
        horizontal-pad = 15;
        vertical-pad = 15;
        inner-pad = 5;

        # 边框
        border-radius = 10;
        border-width = 2;

        # 图标
        icon-theme = "Papirus-Dark";
        show-icons = true;
        icon-size = 16;

        # 过滤
        terminal = "ghostty";
        launch-prefix = "exec";
        layer = "overlay";
        exclusive-zone = -1;

        # 动画
        fields = "filename,name,exec,categories,keywords";
        fuzzy = true;
      };

      keybindings = {
        # 退出
        "Control+Return" = "launch";
        "Control+Shift+Return" = "launch+shift";
        "Escape" = "quit+clear";

        # 导航
        "Control+Up" = "cursor-up";
        "Control+Down" = "cursor-down";
        "Up" = "cursor-up";
        "Down" = "cursor-down";
        "Control+Home" = "cursor-home";
        "Control+End" = "cursor-end";
        "Home" = "cursor-home";
        "End" = "cursor-end";
        "PageUp" = "cursor-page-up";
        "PageDown" = "cursor-page-down";
        "Control+PageUp" = "cursor-page-up";
        "Control+PageDown" = "cursor-page-down";

        # 文本编辑
        "Control+Left" = "cursor-left";
        "Control+Right" = "cursor-right";
        "Left" = "cursor-left";
        "Right" = "cursor-right";
        "Control+Backspace" = "delete-word-back";
        "Control+Delete" = "delete-word-forward";
        "Backspace" = "delete-char-back";
        "Delete" = "delete-char-forward";
        "Control+u" = "clear";
        "Control+w" = "delete-to-end-of-word";

        # 历史记录
        "Control+r" = "history-prev";
        "Control+s" = "history-next";

        # 其他
        "Control+Shift+p" = "custom-1";
        "Control+Shift+q" = "custom-2";
        "Control+Shift+t" = "custom-3";
        "Control+Shift+w" = "custom-4";
        "Control+Shift+f" = "custom-5";
        "Control+Shift+c" = "custom-6";
        "Control+Shift+v" = "custom-7";
        "Control+Shift+d" = "custom-8";
        "Control+Shift+n" = "custom-9";
        "Control+Shift+l" = "custom-10";

        # 焦点切换
        "Control+Tab" = "custom-11";
        "Control+Shift+Tab" = "custom-12";

        # 撤销
        "Control+z" = "custom-13";

        # 重新加载数据库
        "Control+F5" = "custom-14";
      };

      # 自定义操作
      custom-1 = {
        action = "run";
        command = "gtk-launch";
        arg = "firefox.desktop";
      };

      custom-2 = {
        action = "quit";
      };

      custom-3 = {
        action = "run";
        command = "gtk-launch";
        arg = "org.gnome.Console.desktop";
      };

      custom-4 = {
        action = "run";
        command = "gtk-launch";
        arg = "org.gnome.Geary.desktop";
      };

      custom-5 = {
        action = "run";
        command = "gtk-launch";
        arg = "org.gnome.FileRoller.desktop";
      };

      custom-6 = {
        action = "run";
        command = "gtk-launch";
        arg = "org.gnome.Cheese.desktop";
      };

      custom-7 = {
        action = "run";
        command = "gtk-launch";
        arg = "org.gnome.SimpleScan.desktop";
      };

      custom-8 = {
        action = "run";
        command = "gtk-launch";
        arg = "org.gnome.Calculator.desktop";
      };

      custom-9 = {
        action = "run";
        command = "gtk-launch";
        arg = "org.gnome.Nautilus.desktop";
      };

      custom-10 = {
        action = "run";
        command = "gtk-launch";
        arg = "niri.desktop";
      };

      custom-11 = {
        action = "next-match";
      };

      custom-12 = {
        action = "prev-match";
      };

      custom-13 = {
        action = "none";
      };

      custom-14 = {
        action = "reload";
      };

      # 应用分类
      categories = {
        AudioVideo = "🎬";
        Audio = "🎵";
        Video = "🎬";
        Development = "💻";
        Education = "📚";
        Game = "🎮";
        Graphics = "🎨";
        Network = "🌐";
        Office = "📄";
        Science = "🔬";
        Settings = "⚙️";
        System = "⚙️";
        Utility = "🛠️";
      };

      # 模糊匹配权重
      [matches]
      term = "Terminal Emulator"
      dev = "Development"
      web = "Web Browser"
      game = "Game"
      media = "Audio/Video"
      office = "Office"
      system = "System"
      utility = "Utility"
    };
  };

  # 启动脚本
  home.file.".config/fuzzel/fuzzel.sh".text = ''
    #!/bin/sh
    # Fuzzel启动脚本，用于自定义环境变量

    export GTK_THEME="Catppuccin-Mocha-Standard-Blue-Dark"
    export ICON_THEME="Papirus-Dark"
    export CURSOR_THEME="Catppuccin-Mocha-Dark"

    # 启动fuzzel
    exec fuzzel "$@"
  '';

  # 可选：桌面文件
  home.file.".local/share/applications/fuzzel.desktop".text = ''
    [Desktop Entry]
    Name=Fuzzel
    GenericName=Application Launcher
    Comment=Start applications
    Exec=fuzzel
    Terminal=false
    Type=Application
    Categories=System;Utility;
    Keywords=launcher;run;applications;apps;
    Icon=fuzzel
  '';

  # 使启动脚本可执行
  home.file.".config/fuzzel/fuzzel.sh".executable = true;
}