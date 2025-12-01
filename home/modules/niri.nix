{ config, pkgs, inputs, lib, ... }:

{
  # Niri窗口管理器配置
  home.file.".config/niri/config.kdl".text = ''
    include "outputs.kdl"

    // Catppuccin Mocha主题的Niri配置
    input {
        keyboard {
            repeat-delay 600
            repeat-rate 25
            track-layout "global"
        }

        touchpad {
            tap-button-map "left-right-middle"
            scroll-method "two-finger"
            natural-scrolling true
        }

        mouse {
            natural-scrolling false
        }

        workspace {
            // 工作区1-10绑定
            1 monitor "DP-1"
            2 monitor "DP-1"
            3 monitor "DP-1"
            4 monitor "DP-1"
            5 monitor "DP-1"
            6 monitor "DP-1"
            7 monitor "DP-1"
            8 monitor "DP-1"
            9 monitor "DP-1"
            10 monitor "DP-1"
        }

        preset-column-widths {
            proportion 0.33333333
            proportion 0.5
            proportion 0.66666667
        }

        // 窗口规则
        window-rule {
            match app-id="firefox"
            open-on-workspace "2"
        }

        window-rule {
            match app-id="telegramdesktop"
            open-on-workspace "3"
            floating true
        }

        window-rule {
            match title="*弹窗*"
            floating true
            width 640
            height 480
            center true
        }
    }

    layout {
        always-center-single-column true
        center-focused-column "never"
        focus-ring {
            off false
            active-color "#89b4fa" // Catppuccin Blue
            inactive-color "#585b70" // Catppuccin Surface0
            active-gradient {
                from "#89b4fa"
                to "#f38ba8"
            }
            inactive-gradient {
                from "#585b70"
                to "#45475a"
            }
            width 4
        }

        border {
            width 0
            active-color "#89b4fa"
            inactive-color "#45475a"
            active-gradient {
                from "#89b4fa"
                to "#f38ba8"
            }
            inactive-gradient {
                from "#45475a"
                to "#313244"
            }
        }

        // 间隙和边距
        default-column-width { proportion 0.5; }
        gaps 8
        struts 8

        // 边距
        padding-horizontal 8
        padding-vertical 8
    }

    // 窗口装饰
    decorations {
        // 窗口阴影
        drop-shadow {
            off false
            color "#00000044"
            blur-radius 12
            offset-x 2
            offset-y 2
        }

        // 窗口背景模糊
        blur {
            off false
            noise 0.02
            contrast 0.9
            brightness 1.0
            vibrancy 0.2
        }
    }

    // 动画
    animations {
        enable true
        workspace-switch {
            duration-ms 300
            curve "ease-out-cubic"
        }
        horizontal-view-movement {
            duration-ms 250
            curve "ease-out-cubic"
        }
        config-notification-open-close {
            duration-ms 200
            curve "ease-out-cubic"
        }
    }

    // 环境变量
    environment {
        // Wayland相关
        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_TYPE "wayland"
        QT_QPA_PLATFORM "wayland"
        GDK_BACKEND "wayland"
        SDL_VIDEODRIVER "wayland"
        CLUTTER_BACKEND "wayland"
        MOZ_ENABLE_WAYLAND "1"
        ELECTRON_OZONE_PLATFORM_HINT "wayland"

        // 输入法
        GTK_IM_MODULE "fcitx"
        QT_IM_MODULE "fcitx"
        XMODIFIERS "@im=fcitx"

        // 主题
        GTK_THEME "Catppuccin-Mocha-Standard-Blue-Dark"
        ICON_THEME "Papirus-Dark"
        CURSOR_THEME "Catppuccin-Mocha-Dark"

        // 字体
        QT_FONT_DPI "96"
        GDK_SCALE "1"

        // 其他
        NIXOS_OZONE_WL "1"
        _JAVA_AWT_WM_NONREPARENTING "1"
    }

    // 启动项
    spawn-at-startup [
        // 背景管理
        { command = "swww-daemon" }
        { command = "swww img /home/laevatein/Pictures/wallpapers/catppuccin-mocha-blue.png" }

        // 通知管理器
        { command = "mako" }

        // 状态栏
        { command = "waybar" }

        // 输入法
        { command = "fcitx5" }

        // 剪贴板管理
        { command = "wl-paste --type text --watch cliphist store" }
        { command = "wl-paste --type image --watch cliphist store" }

        // 系统托盘应用
        { command = "blueman-applet" }
        { command = "nm-applet" }
    ]

    // 键绑定
    keybind {
        // 基础键绑定
        Mod+Shift+Esc { spawn "niri" "msg" "quit"; }
        Mod+Shift+Return { spawn "ghostty"; }
        Mod+d { spawn "fuzzel"; }
        Mod+Shift+d { spawn "telegram-desktop"; }
        Mod+Shift+f { spawn "firefox"; }
        Mod+Shift+v { spawn "pavucontrol"; }

        // 窗口管理
        Mod+q { close-window; }
        Mod+Space { focus-column-left-or-right; }
        Mod+Shift+Space { focus-column-right-or-left; }
        Mod+Comma { focus-workspace-up; }
        Mod+Period { focus-workspace-down; }

        // 工作区切换
        Mod+1 { focus-workspace "1"; }
        Mod+2 { focus-workspace "2"; }
        Mod+3 { focus-workspace "3"; }
        Mod+4 { focus-workspace "4"; }
        Mod+5 { focus-workspace "5"; }
        Mod+6 { focus-workspace "6"; }
        Mod+7 { focus-workspace "7"; }
        Mod+8 { focus-workspace "8"; }
        Mod+9 { focus-workspace "9"; }
        Mod+0 { focus-workspace "10"; }

        Mod+Shift+1 { move-column-to-workspace "1"; }
        Mod+Shift+2 { move-column-to-workspace "2"; }
        Mod+Shift+3 { move-column-to-workspace "3"; }
        Mod+Shift+4 { move-column-to-workspace "4"; }
        Mod+Shift+5 { move-column-to-workspace "5"; }
        Mod+Shift+6 { move-column-to-workspace "6"; }
        Mod+Shift+7 { move-column-to-workspace "7"; }
        Mod+Shift+8 { move-column-to-workspace "8"; }
        Mod+Shift+9 { move-column-to-workspace "9"; }
        Mod+Shift+0 { move-column-to-workspace "10"; }

        // 窗口布局
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }

        // 窗口移动
        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down { focus-window-down; }
        Mod+Up { focus-window-up; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+Up { move-window-up; }

        // 窗口调整
        Mod+Control+Left { set-column-width "-10%"; }
        Mod+Control+Right { set-column-width "+10%"; }
        Mod+Control+Down { set-window-height "-10%"; }
        Mod+Control+Up { set-window-height "+10%"; }

        // 窗口分合
        Mod+Minus { consume-or-expel-window-left; }
        Mod+Equal { consume-or-expel-window-right; }

        // 窗口浮动
        Mod+Shift+F { toggle-window-floating; }

        // 截图
        Print { spawn "grim" "-g" "$(slurp)" "- |" "swappy" "-f" "-"; }
        Shift+Print { spawn "grim" "- |" "swappy" "-f" "-"; }

        // 音量控制
        XF86AudioRaiseVolume { spawn "pamixer" "-i" "5"; }
        XF86AudioLowerVolume { spawn "pamixer" "-d" "5"; }
        XF86AudioMute { spawn "pamixer" "-t"; }

        // 亮度控制
        XF86MonBrightnessUp { spawn "brightnessctl" "s" "+5%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "s" "5%-"; }

        // 媒体控制
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        XF86AudioStop { spawn "playerctl" "stop"; }
    }

    // 鼠标绑定
    bindmouse {
        Mod+Left { focus-column-left-or-right; }
        Mod+Right { focus-column-right-or-left; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Ctrl+Left { set-column-width "-5%"; }
        Mod+Ctrl+Right { set-column-width "+5%"; }
    }

    // 触摸板手势
    touchpad {
        tap-button-map "left-right-middle"
        scroll-method "two-finger"
        natural-scrolling true
        click-method "clickfinger"
        drag-lock false
        disable-while-typing true
        disable-on-external-mouse false
    }

    // 鼠标滚轮绑定
    bindscroll {
        Mod+WheelUpDown { spawn "pamixer" "-i" "2"; }
        Mod+Shift+WheelUp { spawn "pamixer" "-i" "5"; }
        Mod+WheelDown { spawn "pamixer" "-d" "2"; }
        Mod+Shift+WheelDown { spawn "pamixer" "-d" "5"; }
        Mod+Ctrl+WheelUp { spawn "brightnessctl" "s" "+1%"; }
        Mod+Ctrl+WheelDown { spawn "brightnessctl" "s" "1%-"; }
    }
  '';

  # 占位 outputs.kdl，首次启动前由生成脚本覆盖
  home.file.".config/niri/outputs.kdl".text = "// generated by generate-outputs.sh\n";

  # 动态输出配置生成脚本
  home.file.".config/niri/generate-outputs.sh".text = ''
    #!/usr/bin/env bash
    set -euo pipefail

    out_dir="$HOME/.config/niri"
    out_file="$out_dir/outputs.kdl"

    mkdir -p "$out_dir"

    if ! command -v wlr-randr >/dev/null 2>&1; then
      echo "wlr-randr not found; skipping output generation" >&2
      exit 0
    fi

    json=$(wlr-randr --json || true)
    if [ -z "$json" ]; then
      echo "wlr-randr returned no data; skipping output generation" >&2
      exit 0
    fi

    mapfile -t outputs < <(printf '%s\n' "$json" | jq -r '.[].name')

    x=0
    {
      for name in "${outputs[@]}"; do
        mode_line=$(printf '%s\n' "$json" | jq -r --arg name "$name" '
          (.[] | select(.name == $name)) as $o
          | (
              ($o.modes // []) | map(select(.current == true)) | first
            ) // (
              ($o.modes // []) | max_by(.width * .height * 1000 + .refresh)
            )
          | if . == null then empty else "\(.width) \(.height) \(.refresh)" end
        ')

        if [ -z "$mode_line" ]; then
          continue
        fi

        width=$(awk '{print $1}' <<<"$mode_line")
        height=$(awk '{print $2}' <<<"$mode_line")
        refresh=$(awk '{print $3}' <<<"$mode_line")

        phys_w_mm=$(printf '%s\n' "$json" | jq -r --arg name "$name" '
          (.[] | select(.name == $name) | (.phys_width // .physical_width // 0))
        ')
        phys_h_mm=$(printf '%s\n' "$json" | jq -r --arg name "$name" '
          (.[] | select(.name == $name) | (.phys_height // .physical_height // 0))
        ')

        scale=1.0
        if command -v python3 >/dev/null 2>&1 && [ "$phys_w_mm" != "0" ] && [ "$phys_h_mm" != "0" ]; then
          scale=$(WIDTH="$width" HEIGHT="$height" PHYS_W="$phys_w_mm" PHYS_H="$phys_h_mm" python3 - <<'PY'
import math, os
width = float(os.environ["WIDTH"])
height = float(os.environ["HEIGHT"])
pw = float(os.environ["PHYS_W"])
ph = float(os.environ["PHYS_H"])
scale = 1.0
if pw > 0 and ph > 0:
    diag_px = math.hypot(width, height)
    diag_in = math.hypot(pw, ph) / 25.4
    if diag_in > 0:
        dpi = diag_px / diag_in
        if dpi >= 190:
            scale = 1.5
        elif dpi >= 150:
            scale = 1.25
print(f"{scale:.2f}")
PY
)
        fi

        cat <<EOF
    output "$name" {
        enable true
        mode {
            width $width
            height $height
            refresh $refresh
        }
        position {
            x $x
            y 0
        }
        scale $scale
        transform "normal"
    }

EOF
        x=$((x + width))
      done
    } > "$out_file"
  '';

  home.file.".config/niri/generate-outputs.sh".executable = true;

  # 在会话前生成输出配置，确保 niri 启动前已生成 outputs.kdl
  systemd.user.services."niri-generate-outputs" = {
    Unit = {
      Description = "Generate Niri outputs.kdl from wlr-randr";
      Before = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.config/niri/generate-outputs.sh";
      path = with pkgs; [ wlr-randr jq coreutils bash python3 ];
    };
    Install = {
      WantedBy = [ "graphical-session-pre.target" ];
    };
  };

  # 安装相关工具
  home.packages = with pkgs; [
    niri-validation
    swww
    grim
    slurp
    swappy
    pamixer
    brightnessctl
    playerctl
  ];
}
