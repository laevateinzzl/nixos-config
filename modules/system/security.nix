{ config, pkgs, lib, ... }:

{
  # 系统安全配置

  # 防火墙（统一在此定义基础策略，其它模块按需追加端口）
  networking.firewall = {
    enable = true;
    allowPing = false;
    logRefusedPackets = true;
    trustedInterfaces = [ "lo" ];
    # 只开放必要端口
    allowedTCPPorts = [ 22 ]; # SSH
    # allowedUDPPorts = [ ]; # 无UDP端口
    extraPackages = [ pkgs.ipset ];
    extraStopCommands = ''
      # 禁用ping
      echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
      # 防止SYN攻击
      echo 1 > /proc/sys/net/ipv4/tcp_syncookies
      # 禁用IP源路由
      echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
      # 禁用IP重定向
      echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
    '';
  };

  # 用户和组权限
  users.groups = {
    audio.members = [ "laevatein" ];
    video.members = [ "laevatein" ];
    input.members = [ "laevatein" ];
    wheel.members = [ "laevatein" ];
    networkmanager.members = [ "laevatein" ];
    docker.members = [ "laevatein" ];
  };

  # sudo配置
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      # 超时时间
      Defaults timestamp_timeout=30
      # 安全路径
      Defaults secure_path="/run/current-system/sw/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      # 要求tty
      Defaults requiretty
    '';
  };

  # SSH安全
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # 推荐使用密钥认证
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      X11Forwarding = false;
      GatewayPorts = "no";
      PermitEmptyPasswords = false;
      ChallengeResponseAuthentication = false;
      UsePAM = true;
      KexAlgorithms = "curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256";
      Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
      MACs = "hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha2-256,hmac-sha2-512";
      Protocol = 2;
    };

    # 端口配置
    ports = [ 22 ];

    # 主机密钥
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # 其它安全相关内核、服务配置见下

  # 安全内核参数
  boot.kernel.sysctl = {
    # 网络安全
    "net.ipv4.ip_forward" = 0;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.tcp_syncookies" = 1;

    # 二进制安全
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 2;

    # 文件系统安全
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.suid_dumpable" = 0;
  };

  # 文件权限
  systemd.tmpfiles.rules = [
    "d /var/log 0755 root root -"
    "d /var/tmp 1777 root root 7d"
    "d /tmp 1777 root root 10d"
  ];

  # 限制用户登录
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nproc";
      value = "65535";
    }
    {
      domain = "*";
      type = "hard";
      item = "nproc";
      value = "65535";
    }
  ];

  # 用户安全配置
  users.users.laevatein = {
    # 使用密码哈希而不是明文密码
    hashedPasswordFile = "/etc/nixos/user-passwords/laevatein";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "docker" ];
    createHome = true;
    home = "/home/laevatein";
  };

  # 系统自动锁定
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  # 定时清理日志
  services.journald.extraConfig = ''
    Storage=persistent
    Compress=yes
    SystemMaxUse=1G
    RuntimeMaxUse=100M
  '';
}
