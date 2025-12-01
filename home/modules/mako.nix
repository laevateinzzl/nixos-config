{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;

    # Catppuccin Mocha主题配色
    backgroundColor = "#1e1e2ecc";
    textColor = "#cdd6f4ff";
    borderColor = "#89b4faff";
    progressColor = "#89b4faff";

    # 边框和阴影
    borderSize = 2;
    borderRadius = 8;
    padding = "10,15";
    margin = "10,10";

    # 超时设置
    defaultTimeout = 5000; # 5秒
    ignoreTimeout = false;

    # 布局和位置
    anchor = "top-right";
    layer = "overlay";
    maxVisible = 5;

    # 格式
    format = "<b>%s</b>\\n%b";

    # 图标设置
    icons = true;
    maxIconSize = 64;
    iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";

    # 按钮和操作
    buttonBindings = {
      "1" = "dismiss";
      "2" = "dismiss-all";
      "3" = "invoke-default-action";
    };

    # 快捷键绑定
    bindGlobal = {
      "Ctrl+Space" = "dismiss";
      "Ctrl+Shift+Space" = "dismiss-all";
      "Ctrl+grave" = "dismiss-group";
      "Ctrl+Shift+grave" = "dismiss-all-groups";
    };

    # 分组
    groupBy = "app-name,summary";
    markup = true;
    actions = true;

    # 鼠标设置
    hideOnClick = true;
    mouseMiddleClick = "dismiss-all";

    # 输出设置
    output = "";
    sort = "+time";

    # 默认规则
    defaultRules = [
      # 通用通知
      {
        summary = "*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#cdd6f4ff";
        borderColor = "#45475aff";
        timeout = 5000;
      }

      # 系统通知
      {
        summary = "system*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f38ba8ff";
        borderColor = "#f38ba8ff";
        urgency = "critical";
        timeout = 10000;
      }

      # 错误通知
      {
        summary = "*error*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f38ba8ff";
        borderColor = "#f38ba8ff";
        urgency = "critical";
        timeout = 8000;
      }

      # 警告通知
      {
        summary = "*warning*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#fab387ff";
        borderColor = "#fab387ff";
        urgency = "normal";
        timeout = 7000;
      }

      # 成功通知
      {
        summary = "*success*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#a6e3a1ff";
        borderColor = "#a6e3a1ff";
        urgency = "normal";
        timeout = 3000;
      }

      # 信息通知
      {
        summary = "*info*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#89b4faff";
        borderColor = "#89b4faff";
        urgency = "normal";
        timeout = 5000;
      }

      # 音乐通知
      {
        app-name = "mpd*";
        summary = "♪ *";
        backgroundColor = "#1e1e2ecc";
        textColor = "#cba6f7ff";
        borderColor = "#cba6f7ff";
        timeout = 0; # 不自动消失
        format = "<b>♪ %s</b>\\n%b";
      }

      # Spotify通知
      {
        app-name = "spotify*";
        summary = "*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#cba6f7ff";
        borderColor = "#cba6f7ff";
        timeout = 0;
        format = "<b>🎵 %s</b>\\n%b";
      }

      # Telegram通知
      {
        app-name = "TelegramDesktop";
        backgroundColor = "#1e1e2ecc";
        textColor = "#89dcebff";
        borderColor = "#89dcebff";
        timeout = 0;
        format = "<b>💬 %s</b>\\n%b";
      }

      # Discord通知
      {
        app-name = "discord*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#a6e3a1ff";
        borderColor = "#a6e3a1ff";
        timeout = 0;
        format = "<b>🎮 %s</b>\\n%b";
      }

      # 电池低电量通知
      {
        summary = "*Battery*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f38ba8ff";
        borderColor = "#f38ba8ff";
        urgency = "critical";
        timeout = 10000;
      }

      # 下载完成通知
      {
        summary = "*Download*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#a6e3a1ff";
        borderColor = "#a6e3a1ff";
        timeout = 3000;
      }

      # 安装完成通知
      {
        summary = "*Install*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#89dcebff";
        borderColor = "#89dcebff";
        timeout = 3000;
      }

      # 更新可用通知
      {
        summary = "*Update*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#fab387ff";
        borderColor = "#fab387ff";
        timeout = 5000;
      }

      # 文件传输通知
      {
        summary = "*File*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f5c2e7ff";
        borderColor = "#f5c2e7ff";
        timeout = 4000;
      }

      # 邮件通知
      {
        app-name = "*mail*";
        summary = "*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f9e2afff";
        borderColor = "#f9e2afff";
        timeout = 0;
        format = "<b>📧 %s</b>\\n%b";
      }

      # 日历提醒通知
      {
        app-name = "*calendar*";
        summary = "*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f9e2afff";
        borderColor = "#f9e2afff";
        urgency = "critical";
        timeout = 10000;
        format = "<b>📅 %s</b>\\n%b";
      }

      # 网络连接状态
      {
        summary = "*Network*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#74c7ecff";
        borderColor = "#74c7ecff";
        timeout = 3000;
      }

      # 音量变化通知
      {
        summary = "*Volume*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f2cdcdff";
        borderColor = "#f2cdcdff";
        timeout = 2000;
      }

      # 截图通知
      {
        summary = "*Screenshot*";
        backgroundColor = "#1e1e2ecc";
        textColor = "#f38ba8ff";
        borderColor = "#f38ba8ff";
        timeout = 3000;
        format = "<b>📸 %s</b>\\n%b";
      }
    ];

    # 高级设置
    extraConfig = ''
      # 颜色别名（Catppuccin Mocha）
      [colors]
      # 背景色
      bg = "#1e1e2e"
      bg-light = "#313244"
      bg-dark = "#181825"

      # 前景色
      fg = "#cdd6f4"
      fg-light = "#bac2de"
      fg-dark = "#a6adc8"

      # 主题色
      red = "#f38ba8"
      peach = "#fab387"
      yellow = "#f9e2af"
      green = "#a6e3a1"
      teal = "#94e2d5"
      sky = "#89dceb"
      sapphire = "#74c7ec"
      blue = "#89b4fa"
      lavender = "#b4befe"
      mauve = "#cba6f7"
      pink = "#f5c2e7"
      flamingo = "#f2cdcd"
      rosewater = "#f5e0dc"

      # 中性色
      surface0 = "#313244"
      surface1 = "#45475a"
      surface2 = "#585b70"
      overlay0 = "#6c7086"
      overlay1 = "#7f849c"
      overlay2 = "#9399b2"
      mantle = "#181825"
      crust = "#11111b"

      # 特殊通知规则
      [urgency=low]
      background-color=@bg
      text-color=@overlay1
      border-color=@surface1
      timeout=3000

      [urgency=normal]
      background-color=@bg
      text-color=@fg
      border-color=@blue
      timeout=5000

      [urgency=high]
      background-color=@bg
      text-color=@red
      border-color=@red
      timeout=10000

      [urgency=critical]
      background-color=@bg
      text-color=@red
      border-color=@red
      timeout=0

      # 自定义通知规则示例
      [app-name="mpd"]
      background-color=@bg
      text-color=@mauve
      border-color=@mauve
      timeout=0

      [app-name="telegram-desktop"]
      background-color=@bg
      text-color=@blue
      border-color=@blue
      timeout=0

      [app-name="discord"]
      background-color=@bg
      text-color=@green
      border-color=@green
      timeout=0

      [app-name="firefox"]
      background-color=@bg
      text-color=@orange
      border-color=@orange
      timeout=5000

      [app-name="steam"]
      background-color=@bg
      text-color=@blue
      border-color=@blue
      timeout=0
    '';
  };

  # 通知控制脚本
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "notify-toggle" ''
      #!/bin/sh
      # 切换mako的显示/隐藏状态
      if pgrep -x "mako" > /dev/null; then
        makoctl mode -t "do-not-disturb"
        if makoctl mode | grep -q "do-not-disturb"; then
          notify-send "Mako" "Do Not Disturb enabled" -u normal
        else
          notify-send "Mako" "Do Not Disturb disabled" -u normal
        fi
      else
        mako &
        notify-send "Mako" "Notification daemon started" -u normal
      fi
    '')

    (pkgs.writeShellScriptBin "notify-history" ''
      #!/bin/sh
      # 显示通知历史
      makoctl list
    '')

    (pkgs.writeShellScriptBin "notify-clear" ''
      #!/bin/sh
      # 清除所有通知
      makoctl dismiss --all
    '')
  ];
}