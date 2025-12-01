{ config, pkgs, lib, ... }:

{
  # Catppuccin 主题配置

  # 颜色变量定义
  home.sessionVariables = {
    # Catppuccin Mocha 颜色
    CATPPUCCIN_MOCHA_BASE = "#1e1e2e";
    CATPPUCCIN_MOCHA_MANTLE = "#181825";
    CATPPUCCIN_MOCHA_CRUST = "#11111b";
    CATPPUCCIN_MOCHA_TEXT = "#cdd6f4";
    CATPPUCCIN_MOCHA_SUBTEXT1 = "#bac2de";
    CATPPUCCIN_MOCHA_SUBTEXT0 = "#a6adc8";
    CATPPUCCIN_MOCHA_OVERLAY2 = "#9399b2";
    CATPPUCCIN_MOCHA_OVERLAY1 = "#7f849c";
    CATPPUCCIN_MOCHA_OVERLAY0 = "#6c7086";
    CATPPUCCIN_MOCHA_SURFACE2 = "#585b70";
    CATPPUCCIN_MOCHA_SURFACE1 = "#45475a";
    CATPPUCCIN_MOCHA_SURFACE0 = "#313244";
    CATPPUCCIN_MOCHA_BLUE = "#89b4fa";
    CATPPUCCIN_MOCHA_LAVENDER = "#b4befe";
    CATPPUCCIN_MOCHA_SAPPHIRE = "#74c7ec";
    CATPPUCCIN_MOCHA_SKY = "#89dceb";
    CATPPUCCIN_MOCHA_TEAL = "#94e2d5";
    CATPPUCCIN_MOCHA_GREEN = "#a6e3a1";
    CATPPUCCIN_MOCHA_YELLOW = "#f9e2af";
    CATPPUCCIN_MOCHA_PEACH = "#fab387";
    CATPPUCCIN_MOCHA_MAROON = "#eba0ac";
    CATPPUCCIN_MOCHA_RED = "#f38ba8";
    CATPPUCCIN_MOCHA_MAUVE = "#cba6f7";
    CATPPUCCIN_MOCHA_PINK = "#f5c2e7";
    CATPPUCCIN_MOCHA_FLAMINGO = "#f2cdcd";
    CATPPUCCIN_MOCHA_ROSEWATER = "#f5e0dc";
  };

  # GTK 主题
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark";
      package = pkgs.catppuccin-cursors;
    };
    font = {
      name = "Noto Sans CJK SC";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
      gtk-cursor-theme-size = 24;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt 主题
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # 安装 Catppuccin 相关包与脚本
  home.packages = with pkgs; [
    # 主题包
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-papirus-folders
    catppuccin-cursors
    catppuccin-kde

    # 图标主题
    papirus-icon-theme

    # 颜色工具
    catppuccin-whiskers

    # 字体
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "SourceCodePro"
        "Hack"
        "Ubuntu"
      ];
    })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    jetbrains-mono

    # 壁纸切换脚本
    (writeShellScriptBin "wallpaper-cycle" ''
      #!/bin/sh
      # 随机壁纸切换脚本

      WALLPAPER_DIR="$HOME/Pictures/wallpapers"
      CONFIG_DIR="$HOME/.config/wallpapers"

      if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Wallpaper directory not found: $WALLPAPER_DIR"
        exit 1
      fi

      # 获取随机壁纸
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

      if [ -z "$WALLPAPER" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
      fi

      echo "Setting wallpaper: $WALLPAPER"

      # 使用 swww 设置壁纸
      if command -v swww > /dev/null 2>&1; then
        swww img "$WALLPAPER" \
          --transition-type random \
          --transition-fps 60 \
          --transition-duration 2
      else
        echo "swww not found. Please install swww."
        exit 1
      fi

      # 保存当前壁纸信息
      mkdir -p "$CONFIG_DIR"
      echo "$WALLPAPER" > "$CONFIG_DIR/current"

      # 发送通知
      if command -v notify-send > /dev/null 2>&1; then
        WALLPAPER_NAME=$(basename "$WALLPAPER")
        notify-send "Wallpaper Changed" "Current wallpaper: $WALLPAPER_NAME" -u low
      fi
    '')

    (writeShellScriptBin "wallpaper-set" ''
      #!/bin/sh
      # 设置指定壁纸

      if [ $# -eq 0 ]; then
        echo "Usage: $0 <wallpaper_path>"
        echo "Or use without arguments to select from menu"
        exit 1
      fi

      WALLPAPER_DIR="$HOME/Pictures/wallpapers"
      CONFIG_DIR="$HOME/.config/wallpapers"

      if [ "$1" = "--select" ] || [ $# -eq 0 ]; then
        if command -v fzf > /dev/null 2>&1; then
          WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | fzf --preview="swww img {} --transition-type none")
        else
          echo "fzf not found. Please specify wallpaper path directly."
          exit 1
        fi
      else
        WALLPAPER="$1"
      fi

      if [ ! -f "$WALLPAPER" ]; then
        echo "Wallpaper not found: $WALLPAPER"
        exit 1
      fi

      # 使用 swww 设置壁纸
      if command -v swww > /dev/null 2>&1; then
        swww img "$WALLPAPER" \
          --transition-type random \
          --transition-fps 60 \
          --transition-duration 2
      else
        echo "swww not found. Please install swww."
        exit 1
      fi

      # 保存当前壁纸信息
      mkdir -p "$CONFIG_DIR"
      echo "$WALLPAPER" > "$CONFIG_DIR/current"

      # 发送通知
      if command -v notify-send > /dev/null 2>&1; then
        WALLPAPER_NAME=$(basename "$WALLPAPER")
        notify-send "Wallpaper Set" "Current wallpaper: $WALLPAPER_NAME" -u low
      fi
    '')

    (writeShellScriptBin "wallpaper-restore" ''
      #!/bin/sh
      # 恢复上次的壁纸

      CONFIG_DIR="$HOME/.config/wallpapers"
      CURRENT_FILE="$CONFIG_DIR/current"

      if [ ! -f "$CURRENT_FILE" ]; then
        echo "No previous wallpaper found"
        exit 1
      fi

      WALLPAPER=$(cat "$CURRENT_FILE")

      if [ ! -f "$WALLPAPER" ]; then
        echo "Previous wallpaper not found: $WALLPAPER"
        exit 1
      fi

      echo "Restoring wallpaper: $WALLPAPER"

      # 使用 swww 设置壁纸
      if command -v swww > /dev/null 2>&1; then
        swww img "$WALLPAPER"
      else
        echo "swww not found. Please install swww."
        exit 1
      fi
    '')

    # pywal 颜色生成（可选）
    (writeShellScriptBin "generate-wal-colors" ''
      #!/bin/sh
      # 生成 pywal 颜色配置

      catppuccin_colors="$HOME/.config/theme/colors.sh"

      if [ ! -f "$catppuccin_colors" ]; then
        echo "Catppuccin colors not found"
        exit 1
      fi

      # 加载颜色变量
      . "$catppuccin_colors"

      # 生成 wal 颜色文件
      cat > "$HOME/.cache/wal/colors" << EOF
#000000
#f38ba8
#a6e3a1
#f9e2af
#89b4fa
#cba6f7
#94e2d5
#cdd6f4
#45475a
#f38ba8
#a6e3a1
#f9e2af
#89b4fa
#cba6f7
#94e2d5
#bac2de
EOF

      # 生成 wal 颜色配置
      cat > "$HOME/.cache/wal/colors.json" << EOF
{
  "special": {
    "background": "$BASE",
    "foreground": "$TEXT",
    "cursor": "$ROSEWATER"
  },
  "colors": {
    "color0": "$SURFACE1",
    "color1": "$RED",
    "color2": "$GREEN",
    "color3": "$YELLOW",
    "color4": "$BLUE",
    "color5": "$MAUVE",
    "color6": "$TEAL",
    "color7": "$TEXT",
    "color8": "$SURFACE2",
    "color9": "$RED",
    "color10": "$GREEN",
    "color11": "$YELLOW",
    "color12": "$BLUE",
    "color13": "$MAUVE",
    "color14": "$TEAL",
    "color15": "$TEXT"
  }
}
EOF

      echo "Wal colors generated successfully"
    '')
  ];

  # Kvantum 主题配置
  home.file.".config/Kvantum/catppuccin-mocha".source = pkgs.catppuccin-kvantum;
  home.file.".config/Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Catppuccin-Mocha-Blue
  '';

  # 壁纸管理（文件由 home-manager 管理，内容由你自行放置）
  home.file.".config/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };

  # 启动时设置壁纸
  home.file.".config/autostart-scripts/wallpaper.sh".text = ''
    #!/bin/sh
    # 启动时设置壁纸

    CONFIG_DIR="$HOME/.config/wallpapers"
    CURRENT_FILE="$CONFIG_DIR/current"

    # 等待 swww 启动
    sleep 2

    if [ -f "$CURRENT_FILE" ]; then
      WALLPAPER=$(cat "$CURRENT_FILE")
      if [ -f "$WALLPAPER" ]; then
        swww img "$WALLPAPER"
      fi
    else
      # 设置默认壁纸
      WALLPAPER_DIR="$HOME/Pictures/wallpapers"
      if [ -d "$WALLPAPER_DIR" ]; then
        DEFAULT_WALLPAPER=$(find "$WALLPAPER_DIR" -name "*.png" -o -name "*.jpg" | head -n 1)
        if [ -f "$DEFAULT_WALLPAPER" ]; then
          swww img "$DEFAULT_WALLPAPER" --transition-type random
          mkdir -p "$CONFIG_DIR"
          echo "$DEFAULT_WALLPAPER" > "$CURRENT_FILE"
        fi
      fi
    fi
  '';

  home.file.".config/autostart-scripts/wallpaper.sh".executable = true;

  # 主题配置文件
  home.file.".config/theme/colors.sh".text = ''
    #!/bin/sh
    # Catppuccin Mocha 颜色变量

    # 主色调
    export BASE="#1e1e2e"
    export MANTEL="#181825"
    export CRUST="#11111b"
    export TEXT="#cdd6f4"
    export SUBTEXT1="#bac2de"
    export SUBTEXT0="#a6adc8"
    export OVERLAY2="#9399b2"
    export OVERLAY1="#7f849c"
    export OVERLAY0="#6c7086"
    export SURFACE2="#585b70"
    export SURFACE1="#45475a"
    export SURFACE0="#313244"

    # 调色板
    export ROSEWATER="#f5e0dc"
    export FLAMINGO="#f2cdcd"
    export PINK="#f5c2e7"
    export MAUVE="#cba6f7"
    export RED="#f38ba8"
    export MAROON="#eba0ac"
    export PEACH="#fab387"
    export YELLOW="#f9e2af"
    export GREEN="#a6e3a1"
    export TEAL="#94e2d5"
    export SKY="#89dceb"
    export SAPPHIRE="#74c7ec"
    export BLUE="#89b4fa"
    export LAVENDER="#b4befe"

    # 其他颜色
    export BLACK="$SURFACE1"
    export WHITE="$TEXT"
    export GRAY="$SUBTEXT0"
    export ORANGE="$PEACH"
    export CYAN="$SKY"
    export PURPLE="$MAUVE"
  '';

  home.file.".config/theme/colors.sh".executable = true;

  # 终端颜色方案
  programs.bash.initExtra = ''
    # 加载 Catppuccin 颜色
    if [ -f "$HOME/.config/theme/colors.sh" ]; then
      . "$HOME/.config/theme/colors.sh"
    fi

    # 终端颜色方案（256色）
    if [ "$TERM" = "xterm-256color" ] || [ "$TERM" = "tmux-256color" ]; then
      # Catppuccin Mocha 终端颜色
      export LS_COLORS="$LS_COLORS:di=1;38;5;147:ln=1;38;5;147:ex=1;38;5;147"
    fi
  '';

  programs.zsh.initExtra = ''
    # 加载 Catppuccin 颜色
    if [ -f "$HOME/.config/theme/colors.sh" ]; then
      . "$HOME/.config/theme/colors.sh"
    fi

    # Catppuccin ZSH 主题
    ZSH_THEME="catppuccin"
    if [ -f "$HOME/.config/zsh/catppuccin.zsh-theme" ]; then
      source "$HOME/.config/zsh/catppuccin.zsh-theme"
    fi
  '';
}
