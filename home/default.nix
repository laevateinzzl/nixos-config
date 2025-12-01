{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./modules/shell.nix
    ./modules/niri.nix
    ./modules/waybar.nix
    ./modules/fuzzel.nix
    ./modules/mako.nix
    ./modules/firefox.nix
    ./modules/ghostty.nix
    ./modules/tmux.nix
    ./modules/lazyvim.nix
    ./modules/zed.nix
    ./modules/input-method.nix
    ./modules/git.nix
    ./modules/development.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
    cursors.enable = true;
    gtk.enable = true;
    waybar.enable = true;
    fuzzel.enable = true;
    mako.enable = true;
    ghostty.enable = true;
    starship.enable = true;
  };

  # 用户基本信息
  home.username = "laevatein";
  home.homeDirectory = "/home/laevatein";
  home.stateVersion = "25.11";

  # 启用home-manager功能
  programs.home-manager.enable = true;

  # 用户包
  home.packages = with pkgs; [
    # 命令行工具
    eza
    bat
    fd
    ripgrep
    fzf
    zoxide
    starship
    tree
    btop

    # 文件管理
    ranger
    lf

    # 压缩工具
    unzip
    zip
    p7zip
    unrar

    # 网络工具
    curl
    wget
    httpie

    # 多媒体
    ffmpeg
    imagemagick
    gimp
    vlc

    # 办公
    libreoffice
    onlyoffice-bin

    # 通信
    discord
    telegram-desktop
    element-desktop

    # 开发工具
    git
    github-cli
    lazygit

    # 密码管理
    keepassxc
    bitwarden

    # 截图工具
    grim
    slurp
    swappy

    # 剪贴板
    wl-clipboard
    cliphist

    # 背景管理
    swww

    # 其他
    neofetch
    fastfetch
    jq
    yq
    wlr-randr
  ];

  # 会话变量
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "ghostty";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # 环境变量
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
  ];

  # 点文件管理
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      desktop = "$HOME/Desktop";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
    };

    # 桌面条目
    desktopEntries = {
      firefox = {
        name = "Firefox";
        genericName = "Web Browser";
        exec = "firefox %U";
        icon = "firefox";
        categories = [ "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
      };

      niri = {
        name = "Niri";
        genericName = "Wayland Compositor";
        exec = "niri";
        icon = "niri";
        categories = [ "System" ];
      };
    };
  };

  # GTK主题配置
  gtk = {
    enable = true;
    font = {
      name = "Noto Sans CJK SC";
      size = 11;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };
  };

  # Qt主题配置
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # 音量控制
  programs.pavucontrol.enable = true;

  # 文件关联
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "text/plain" = "nvim.desktop";
      "image/jpeg" = "gimp.desktop";
      "image/png" = "gimp.desktop";
      "video/mp4" = "vlc.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
    };
  };

  # 启动脚本
  home.file.".config/autostart-scripts".source = ./scripts;

  # Git配置
  programs.git = {
    enable = true;
    userName = "laevateinzzl";
    userEmail = "zhaoaa966@163.com";
    signing = {
      key = null; # 设置你的GPG密钥ID
      signByDefault = true;
    };
  };

  # Zsh配置
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      save = 10000;
      size = 10000;
      ignoreSpace = true;
    };

    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
      ];
    };

    shellAliases = {
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      cd = "z";
      vim = "nvim";
      cat = "bat";
    };

    initExtra = ''
      # 自动cd到目录
      setopt AUTO_CD

      # 补全不区分大小写
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      # 启用starship
      eval "$(starship init zsh)"

      # 启用zoxide
      eval "$(zoxide init zsh)"
    '';
  };

  # Starship提示符
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
      };
    };
  };

  # FZF配置
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
  };

  # Bat配置
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "numbers,changes,header";
    };
  };
}
