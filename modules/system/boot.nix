{ config, pkgs, inputs, ... }:

{
  # 使用 systemd-boot
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10; # 保留10个之前的配置
    };
    timeout = 5; # 启动超时时间（秒）
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # 内核配置
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 启动时加载的内核模块
  boot.kernelModules = [
    # VirtualBox 模块由 virtualisation.virtualbox.host 服务自动管理
  ];

  # VirtualBox 虚拟化支持
  virtualisation.virtualbox.host.enable = true;

  # 内核参数
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
  ];

  # initrd配置
  boot.initrd = {
    systemd.enable = true;
    verbose = false;
  };

  # Plymouth启动画面
  boot.plymouth.enable = true;

  # 确保相关的包被安装
  environment.systemPackages = with pkgs; [
    # systemd-boot 由 NixOS 自动管理
  ];
}