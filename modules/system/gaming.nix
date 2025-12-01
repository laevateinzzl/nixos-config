{ config, pkgs, lib, inputs, ... }:

{
  # Steam游戏平台
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # 开放防火墙用于远程畅玩
    dedicatedServer.openFirewall = true; # 开放防火墙用于专用服务器

    # 游戏兼容层
    gamescopeSession.enable = true;

    # Proton支持
    protontricks.enable = true;
  };

  # 游戏性能优化
  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    general = {
      renice = 10;
      inhibit_screensaver = 1;
    };
    gpu = {
      apply_gpu_optimisations = "accept-responsibility";
      gpu_device = 0;
      nvidia_core_clock_mhz_offset = 0;
      nvidia_mem_clock_mhz_offset = 0;
      amd_performance_level = "high";
    };
    custom = {
      start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
      end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
    };
  };

  # 开放必要的防火墙端口
  networking.firewall = {
    allowedTCPPorts = [ 27036 27037 ];
    allowedUDPPorts = [ 27031 27036 27037 ];
  };

  # 添加游戏相关包
  environment.systemPackages = with pkgs; [
    # Steam相关
    steam
    steamcmd
    steam-runtime

    # 游戏工具
    gamescope
    mangohud
    goverlay
    gamemode
    protontricks
    protonup-qt

    # 模拟器
    retroarch
    dolphin-emu
    pcsx2

    # 游戏录制和串流
    obs-studio
    sunshine

    # 游戏控制器支持
    xboxdrv

    # Wine支持（非Steam游戏）
    wine
    winetricks
    bottles

    # 性能监控
    nvtop
    radeontop
  ];

  # 内核模块（一些游戏需要）
  boot.kernelModules = [
    "uinput" # 用于控制器输入
    "joydev" # 游戏手柄支持
  ];

  # 系统服务
  services = {
    # uinput用于虚拟控制器
    udev.packages = [ pkgs.xboxdrv ];
  };

  # 用户组（允许访问游戏设备）
  users.groups = {
    input.members = [ "laevatein" ];
    gamemode.members = [ "laevatein" ];
  };

  # 可选：Lutris（非Steam游戏管理器）
  environment.systemPackages = with pkgs; [
    lutris
  ];

  # Wayland游戏支持
  environment.sessionVariables = {
    STEAM_RUNTIME = "1";
    DXVK_HUD = "0";
    MANGOHUD = "0";
  };
}
