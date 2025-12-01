{ config, pkgs, lib, ... }:

{
  # 网络配置
  networking = {
    # 主机名
    hostName = "nixos";

    # 网络管理器
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
        scanRandMacAddress = true;
      };
    };

    # 代理设置（根据需要配置）
    # proxy.default = "http://127.0.0.1:8080/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # DNS配置
    # nameservers = [
    #   "1.1.1.1"  # Cloudflare
    #   "8.8.8.8"  # Google
    #   "223.5.5.5" # 阿里
    # ];

    # IPv6支持
    # enableIPv6 = true;
  };

  # 网络工具包
  environment.systemPackages = with pkgs; [
    # 基础网络工具
    wget
    curl
    git
    rsync

    # 网络诊断
    iputils
    traceroute
    mtr
    nmap
    wireshark-cli
    tcpdump

    # DNS工具
    dig
    drill
    ldns

    # 网络监控
    bmon
    nload
    iftop
    vnstat

    # 文件传输
    filezilla
    rclone

    # 远程访问
    openssh
    tigervnc

    # VPN支持
    openvpn
    wireguard-tools

    # 蓝牙工具
    bluez
    bluez-tools
  ];

  # Zeroconf (mDNS) 支持
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # USB热点支持
  services.usbguard = {
    enable = true;
    ruleFiles = [
      "/etc/usbguard/rules.conf"
    ];
  };

  # 网络时间同步
  services.timesyncd.enable = true;

  # 可选：Tailscale VPN
  # services.tailscale.enable = true;

  # 可选：Yggdrasil网络
  # services.yggdrasil = {
  #   enable = true;
  #   config = {
  #     IfName = "ygg0";
  #     Peers = [
  #       "tcp://[your-peer]:port"
  #     ];
  #   };
  # };

  # 可选：Coredns
  # services.coredns = {
  #   enable = true;
  #   config = ''
  #     . {
  #       forward . 1.1.1.1 8.8.8.8
  #       log
  #     }
  #   '';
  # };
}
