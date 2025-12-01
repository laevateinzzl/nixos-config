{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      width = "auto";

      modules-left = [
        "niri/workspaces"
        "niri/window"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "network"
        "pulseaudio"
        "backlight"
        "battery"
        "tray"
        "idle_inhibitor"
        "custom/notification"
      ];

      "niri/workspaces" = {
        format = "{name}";
        format-icons = {
          active = "●";
          default = "○";
          urgent = "●";
        };
      };

      "niri/window" = {
        max-length = 50;
        format = "{}";
      };

      "clock" = {
        format = " {:%H:%M}";
        format-alt = " {:%Y-%m-%d}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };

      "network" = {
        format-wifi = " {signalStrength}%";
        format-ethernet = " 100% ";
        format-disconnected = "⚠  Disconnected";
        tooltip-format-wifi = " {essid} ({signalStrength}%)";
        tooltip-format-ethernet = " {ifname} ({ipaddr}/{cidr})";
        tooltip-format-disconnected = "Disconnected";
        interval = 5;
      };

      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-muted = " Muted {format_source}";
        format-source = "";
        format-source-muted = "";
        format-icons = {
          headphones = "";
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
        scroll-step = 5;
      };

      "backlight" = {
        format = "{icon} {percent}%";
        format-icons = ["" ""];
        on-scroll-up = "brightnessctl set +1%";
        on-scroll-down = "brightnessctl set 1%-";
      };

      "battery" = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = ["" "" "" "" ""];
      };

      "tray" = {
        icon-size = 21;
        spacing = 10;
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        escape = true;
      };
    }];

    style = ''
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color crust #11111b;

      @define-color text #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue #89b4fa;
      @define-color lavender #b4befe;
      @define-color sapphire #74c7ec;
      @define-color sky #89dceb;
      @define-color teal #94e2d5;
      @define-color green #a6e3a1;
      @define-color yellow #f9e2af;
      @define-color peach #fab387;
      @define-color maroon #eba0ac;
      @define-color red #f38ba8;
      @define-color mauve #cba6f7;
      @define-color pink #f5c2e7;
      @define-color flamingo #f2cdcd;
      @define-color rosewater #f5e0dc;

      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", sans-serif;
          font-size: 12px;
          min-height: 0;
      }

      window#waybar {
          background: @surface0;
          color: @text;
          border-bottom: 2px solid @lavender;
      }

      #workspaces button {
          background: @surface1;
          color: @subtext1;
          padding: 5px 10px;
          margin: 0 5px;
          border-radius: 8px;
          transition: all 0.3s ease;
      }

      #workspaces button:hover {
          background: @surface2;
          color: @text;
      }

      #workspaces button.active {
          background: @blue;
          color: @crust;
          border-radius: 8px;
      }

      #workspaces button.urgent {
          background: @red;
          color: @crust;
      }

      #niri-window {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 10px;
          font-weight: bold;
      }

      #clock {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 5px;
          font-weight: bold;
      }

      #network {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 5px;
      }

      #network.disconnected {
          background: @red;
          color: @crust;
      }

      #pulseaudio {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 5px;
      }

      #pulseaudio.muted {
          background: @surface2;
          color: @subtext0;
      }

      #backlight {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 5px;
      }

      #battery {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 5px;
      }

      #battery.warning {
          background: @yellow;
          color: @base;
      }

      #battery.critical {
          background: @red;
          color: @crust;
      }

      #battery.charging {
          background: @green;
          color: @base;
      }

      #tray {
          background: @surface1;
          padding: 0 10px;
          border-radius: 8px;
          margin: 0 5px;
      }

      #tray menu {
          background: @surface0;
          border: 1px solid @surface2;
          border-radius: 8px;
          padding: 5px;
      }

      #tray menuitem {
          background: @surface1;
          color: @text;
          border-radius: 4px;
          padding: 5px 10px;
          margin: 2px;
      }

      #tray menuitem:hover {
          background: @surface2;
      }

      #idle_inhibitor {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 5px;
      }

      #idle_inhibitor.activated {
          background: @green;
          color: @base;
      }

      #custom-notification {
          background: @surface1;
          padding: 0 15px;
          border-radius: 8px;
          margin: 0 5px;
      }

      #custom-notification.notification {
          background: @blue;
          color: @crust;
      }

      #custom-notification.dnd-notification {
          background: @red;
          color: @crust;
      }

      tooltip {
          background: @surface0;
          border: 1px solid @surface2;
          border-radius: 8px;
          padding: 8px;
      }

      tooltip label {
          color: @text;
      }
    '';
  };

  # 安装相关依赖
  home.packages = with pkgs; [
    swaync
    libnotify
  ];
}