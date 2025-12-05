{ config, pkgs, lib, ... }:

{
  # 系统基础包
  environment.systemPackages = with pkgs; [
    # 基础工具
    coreutils
    findutils
    gnutar
    gzip
    xz
    zip
    unzip
    p7zip

    # 系统信息
    neofetch
    fastfetch
    lsb-release

    # 文本编辑
    vim
    nano
    micro

    # 文件管理
    ranger
    lf
    btop
    htop
    iotop
    strace
    ltrace

    # 系统监控
    lm_sensors
    nvtop
    radeontop
    intel-gpu-tools

    # 网络工具
    nettools
    iproute2
    networkmanager
    wpa_supplicant

    # 音频工具
    # pulseaudio # 使用pipewire代替
    pavucontrol
    alsa-utils

    # 硬件工具
    usbutils
    pciutils
    lshw
    smartmontools
    hdparm
    sdparm

    # 系统维护
    nix-tree
    nix-index
    nixpkgs-review
    nixfmt

    # 开发工具
    git
    git-crypt
    gnumake
    cmake
    pkg-config
    gcc
    clang
    rustup

    # 容器和虚拟化
    docker
    docker-compose
    podman
    qemu
    libvirt
    virtualbox

    # 压缩工具
    unrar
    p7zip
    squashfsTools
    zstd

    # 加密工具
    gnupg
    cryptsetup
    veracrypt

    # 文档工具
    man-pages
    man-pages-posix

    # 其他实用工具
    tree
    ripgrep
    fd
    eza
    bat
    fzf
    jq
    yq
    tokei
    dust
    procs

    # 多媒体
    ffmpeg
    imagemagick
    gimp
    inkscape

    # 办公
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    hunspellDicts.zh_CN

    # 通信
    telegram-desktop
    discord
    element-desktop

    # 浏览器相关
    firefox
    # chromium

    # 开发环境
    vscode
    zed-editor
    ghostty
    # alacritty
  ];

  # 允许不自由软件
  nixpkgs.config.allowUnfree = true;

  # 启用一些程序
  programs = {
    # 防火墙工具
    firejail.enable = true;

    # Git配置
    # Git配置 (移至 home-manager)
    git = {
      enable = true;
      # config = {
      #   init.defaultBranch = "main";
      #   user.name = "Your Name";
      #   user.email = "your.email@example.com";
      # };
    };

    # Zsh
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh.enable = true;
      shellInit = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';
    };

    # Fish（可选）
    fish.enable = true;

    # Bash增强
    bash.enableCompletion = true;

    # Vim
    vim = {
      enable = true;
      defaultEditor = true;
    };

    # 其他工具
    dconf.enable = true;
    seahorse.enable = true;
  };

  # 系统服务
  services = {
    # 自动挂载
    # 自动挂载 (移至 modules/system/desktop.nix)
    # udisks2.enable = true;
    devmon.enable = true;
    # udisks2.mountOnMedia = true;

    # 电源管理已在 desktop.nix 中配置 power-profiles-daemon
    # auto-cpufreq.enable = true;

    # 打印机支持（如果需要）
    # printing.enable = true;
    # printing.drivers = [ pkgs.hplipWithPlugin ];

    # 扫描仪支持（如果需要）
    # saned.enable = true;

    # 蓝牙
    # 蓝牙 (移至 modules/system/desktop.nix)
    # bluetooth.enable = true;
    # blueman.enable = true;

    # 定位服务
    geoclue2.enable = true;

    # 包管理器更新
    flatpak.enable = true;
  };

  # 临时目录清理
  systemd.tmpfiles.rules = [
    "d /tmp 1777 root root 10d"
    "d /var/tmp 1777 root root 30d"
  ];
}
