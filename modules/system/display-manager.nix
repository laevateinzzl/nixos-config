{ config, pkgs, lib, inputs, ... }:

{
  # 启用X11和Wayland
  services.xserver.enable = true;

  # 使用SDDM作为显示管理器
  services.displayManager = {
    sddm = {
      enable = true;
      enableHidpi = true;
      package = pkgs.kdePackages.sddm;
      settings = {
        General = {
          DisplayServer = "wayland";
          Numlock = "on";
        };
      };
    };

    # 自动登录配置（可选）
    autoLogin = {
      enable = false; # 设为true启用自动登录
      user = "laevatein";
    };
  };

  # 触摸板支持
  services.libinput.enable = true;

  # SDDM主题配置
  # 确保必要的包
  services.xserver = {
    # 键盘布局
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:swapescape";
    };

    # 显示管理器
    displayManager.sessionPackages = [
      # 可以在这里添加其他会话包
    ];
  };

  # Wayland支持
  programs.hyprland.enable = lib.mkForce false; # 确保不与niri冲突
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
  };
}
