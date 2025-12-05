{ config, pkgs, inputs, ... }:

let
  fusionJetBrainsMapleMono = pkgs.callPackage ../../packages/fonts/fusion-jetbrainsmaplemono.nix { };
in {
  # 启用Niri窗口管理器
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.niri;
  };

  # 确保桌面环境所需的包
  environment.systemPackages = with pkgs; [
    # Wayland相关
    wayland
    wayland-utils
    wayland-protocols
    xwayland

    # Niri相关工具
    niri
    niri-validation

    # Waybar状态栏
    (waybar.override {
      pulseSupport = true;
      traySupport = true;
    })

    # 应用启动器
    fuzzel

    # 通知管理器
    mako

    # 截图工具
    grim
    slurp
    swappy

    # 剪贴板管理
    wl-clipboard
    clipse

    # 背景管理
    swww

    # 输入法支持
    fcitx5
    fcitx5-gtk
    fcitx5-qt
    fcitx5-configtool

    # GTK主题支持
    glib
    gtk3
    gtk4
    gnome.gnome-themes-extra

    # 图标主题
    catppuccin-papirus-folders
    papirus-icon-theme

    # 光标主题
    catppuccin-cursors.mochaDark

    # 字体
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fusionJetBrainsMapleMono
    lxgw-wenkai
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji

    # 系统工具
    brightnessctl
    pavucontrol
    blueman
    networkmanagerapplet
  ];

  # 启用一些系统服务
  services = {
    # 蓝牙
    blueman.enable = true;

    # 电源管理
    power-profiles-daemon.enable = true;
    # tlp.enable = true; # 与 power-profiles-daemon 互斥

    # 自动挂载
    gvfs.enable = true;
    udisks2.enable = true;
  };

  # 硬件支持
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # 显卡驱动（根据实际硬件调整）
    # intel驱动
    # intel-gpu-tools.enable = true;

    # AMD驱动（如果使用AMD显卡）
    amdgpu.opencl.enable = true;

    # NVIDIA驱动（如果使用NVIDIA显卡）
    # nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # 触摸板配置 (已从 services.xserver.libinput 迁移)
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
    };
  };

  # 设置GTK主题（在home-manager中进一步配置）
  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
    ICON_THEME = "Papirus-Dark";
    CURSOR_THEME = "Catppuccin-Mocha-Dark";
  };
}
