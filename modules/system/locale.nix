{ config, pkgs, lib, ... }:

{
  # 时区和本地化设置
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # 输入法配置
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-configtool
        fcitx5-gtk
        fcitx5-qt
      ];
      waylandFrontend = true;
    };
  };

  # 控制台字体
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  # 系统环境变量
  environment.variables = {
    # 中文输入法环境变量
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
    SDL_IM_MODULE = "fcitx";
  };

  # 安装中文字体
  fonts.packages = with pkgs; [
    # 中文显示字体
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    wqy_zenhei
    wqy_microhei

    # emoji字体
    noto-fonts-emoji

    # 英文字体
    noto-fonts
    liberation_ttf
    dejavu_fonts

    # 编程字体
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "SourceCodePro"
        "Hack"
        "Ubuntu"
      ];
    })
  ];

  # 字体配置
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Noto Sans CJK SC" "Noto Sans" ];
      serif = [ "Noto Serif CJK SC" "Noto Serif" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };

    # 亚像素渲染
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };

    hinting = {
      enable = true;
      autohint = false;
    };
  };
}