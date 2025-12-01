{ config, pkgs, inputs, ... }:

{
  imports = [
    # 硬件配置 - 运行 nixos-generate-config 生成后替换
    ./hardware-configuration.nix
  ];

  # 基础系统配置
  system.stateVersion = "24.11"; # 根据安装时的版本调整

  # 用户配置 - 请修改为实际用户名
  users.users.laevatein = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "dialout" ];
    shell = pkgs.zsh;
  };

  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # 启用 flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 启用自动垃圾回收
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # 启用压缩
  nix.settings.auto-optimise-store = true;

  # 系统包
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
    btop
  ];

  # 启用zsh
  programs.zsh.enable = true;

  # catppuccin主题
  catppuccin = {
    enable = true;
    flavor = "mocha"; # 可选: latte, frappe, macchiato, mocha
    accent = "blue";
    sddm.enable = true;
    plymouth.enable = true;
    limine.enable = true;
    tty.enable = true;
    fcitx5.enable = true;
  };

  # 启用niri窗口管理器
  programs.niri.enable = true;

  # 启用Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # 启用输入法
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };

  # 启用声音
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
