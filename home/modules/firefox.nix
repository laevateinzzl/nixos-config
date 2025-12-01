{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    # 用户配置
    profiles.default = {
      id = 0;
      name = "Default";

      # 搜索引擎
      search = {
        force = true;
        default = "DuckDuckGo";
        engines = {
          "DuckDuckGo" = {
            urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
            iconUpdateURL = "https://duckduckgo.com/favicon.ico";
            definedAliases = ["!d"];
          };

          "Google" = {
            urls = [{ template = "https://www.google.com/search?q={searchTerms}"; }];
            iconUpdateURL = "https://www.google.com/favicon.ico";
            definedAliases = ["!g"];
          };

          "Bing" = {
            urls = [{ template = "https://www.bing.com/search?q={searchTerms}"; }];
            iconUpdateURL = "https://www.bing.com/favicon.ico";
            definedAliases = ["!b"];
          };

          "GitHub" = {
            urls = [{ template = "https://github.com/search?q={searchTerms}"; }];
            iconUpdateURL = "https://github.com/favicon.ico";
            definedAliases = ["!gh"];
          };

          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?query={searchTerms}"; }];
            iconUpdateURL = "https://search.nixos.org/favicon.ico";
            definedAliases = ["!nix"];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            definedAliases = ["!nixw"];
          };
        };
      };

      # 扩展
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # 安全和隐私
        ublock-origin
        https-everywhere
        decentraleyes
        privacy-badger
        canvasblocker

        # 界面增强
        darkreader
        stylus
        userchrome-toggle

        # 开发工具
        web-developer
        react-devtools
        vue-js-devtools
        firefox-color

        # 实用工具
        bitwarden
        keepassxc-browser
        togoogletranslate
        disable-javascript

        # 下载管理
        downthemall

        # 标签管理
        tree-style-tab
        simple-tab-groups
        tab-session-manager

        # 广告拦截增强
        sponsorblock
        enhancer-for-youtube

        # PDF工具
        zotero-connector

        # 翻译
        togoogletranslate
        zhconverter

        # 开源软件替代
        libredirect
        privacy-redirect

        # 其他
        tampermonkey
        violentmonkey
        grease-monkey
      ];

      # 书签
      bookmarks = [
        {
          name = "NixOS";
          tags = ["nix" "linux"];
          keyword = "nix";
          url = "https://nixos.org/";
        }
        {
          name = "Nix Packages";
          tags = ["nix" "packages"];
          keyword = "np";
          url = "https://search.nixos.org/packages";
        }
        {
          name = "NixOS Wiki";
          tags = ["nix" "wiki"];
          keyword = "nw";
          url = "https://nixos.wiki/";
        }
        {
          name = "GitHub";
          tags = ["git" "code"];
          keyword = "gh";
          url = "https://github.com/";
        }
        {
          name = "Catppuccin";
          tags = ["theme"];
          keyword = "cat";
          url = "https://github.com/catppuccin";
        }
        {
          name = "Home Manager";
          tags = ["nix" "home-manager"];
          keyword = "hm";
          url = "https://nix-community.github.io/home-manager/";
        }
      ];

      # 设置
      settings = {
        # 基础设置
        "browser.startup.homepage" = "https://start.duckduckgo.com/";
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # 隐私和安全
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.query_stripping" = true;
        "privacy.firstparty.isolate" = true;

        # 禁用遥测
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "experiments.enabled" = false;
        "experiments.supported" = false;
        "browser.ping-centre.telemetry" = false;
        "beacon.enabled" = false;

        # 禁用Pocket
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.system.topstories" = false;

        # 性能设置
        "layers.acceleration.enabled" = true;
        "gfx.offscreen-aztex.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;

        # 界面设置
        "browser.compactmode.show" = true;
        "browser.uidensity" = 0;
        "browser.menu.showViewImageInfo" = true;

        # 下载设置
        "browser.download.useDownloadDir" = true;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";

        # 容器标签
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        # 密码管理（如果使用Bitwarden）
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.schemeUpgrades" = false;

        # 缓存设置
        "browser.cache.disk.capacity" = 256000;
        "browser.cache.disk.smart_size.enabled" = true;

        # 网络设置
        "network.http.speculative-parallel-connections" = 6;
        "network.http.max-persistent-connections-per-server" = 6;

        # 主题设置（Catppuccin）
        "extensions.activeThemeID" = "catppuccin-mocha-blue@catppuccin.com";
        "browser.display.background_color" = "#1e1e2e";
        "browser.display.foreground_color" = "#cdd6f4";

        # 字体设置
        "font.name.serif.zh-CN" = "Noto Serif CJK SC";
        "font.name.sans-serif.zh-CN" = "Noto Sans CJK SC";
        "font.name.monospace.zh-CN" = "JetBrainsMono Nerd Font";
        "font.name.serif.x-western" = "Noto Serif";
        "font.name.sans-serif.x-western" = "Noto Sans";
        "font.name.monospace.x-western" = "JetBrainsMono Nerd Font";

        # 启用用户Chrome样式
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };

      # 用户Chrome样式（Catppuccin主题）
      userChrome = ''
        /* Catppuccin Mocha Firefox Theme */
        :root {
          --base: #1e1e2e;
          --mantle: #181825;
          --crust: #11111b;
          --text: #cdd6f4;
          --subtext1: #bac2de;
          --subtext0: #a6adc8;
          --overlay2: #9399b2;
          --overlay1: #7f849c;
          --overlay0: #6c7086;
          --surface2: #585b70;
          --surface1: #45475a;
          --surface0: #313244;
          --blue: #89b4fa;
          --lavender: #b4befe;
          --sapphire: #74c7ec;
          --sky: #89dceb;
          --teal: #94e2d5;
          --green: #a6e3a1;
          --yellow: #f9e2af;
          --peach: #fab387;
          --maroon: #eba0ac;
          --red: #f38ba8;
          --mauve: #cba6f7;
          --pink: #f5c2e7;
          --flamingo: #f2cdcd;
          --rosewater: #f5e0dc;
        }

        /* 去除标题栏和边框 */
        #titlebar {
          display: none !important;
        }

        /* 自定义标签页 */
        tabbrowser tab {
          background-color: var(--surface0) !important;
          color: var(--text) !important;
          border: none !important;
          border-radius: 8px 8px 0 0 !important;
          margin-right: 2px !important;
          padding: 2px 8px !important;
        }

        tabbrowser tab[selected="true"] {
          background-color: var(--blue) !important;
          color: var(--crust) !important;
        }

        tabbrowser tab:hover {
          background-color: var(--surface1) !important;
        }

        /* 自定义工具栏 */
        #nav-bar {
          background-color: var(--base) !important;
          border-bottom: 1px solid var(--surface0) !important;
        }

        /* 自定义网址栏 */
        #urlbar {
          background-color: var(--surface0) !important;
          color: var(--text) !important;
          border: 1px solid var(--surface1) !important;
          border-radius: 8px !important;
          padding: 4px 8px !important;
        }

        #urlbar:hover {
          border-color: var(--surface2) !important;
        }

        #urlbar[focused="true"] {
          border-color: var(--blue) !important;
          box-shadow: 0 0 0 1px var(--blue) !important;
        }

        /* 自定义书签栏 */
        #PersonalToolbar {
          background-color: var(--mantle) !important;
          border-top: 1px solid var(--surface0) !important;
        }

        /* 自定义菜单 */
        #appMenu-popup {
          background-color: var(--surface0) !important;
          border: 1px solid var(--surface2) !important;
          border-radius: 8px !important;
        }

        /* 自定义侧边栏 */
        #sidebar-box {
          background-color: var(--mantle) !important;
          border-right: 1px solid var(--surface0) !important;
        }

        /* 自定义上下文菜单 */
        #contentAreaContextMenu {
          background-color: var(--surface0) !important;
          border: 1px solid var(--surface2) !important;
          border-radius: 8px !important;
        }

        /* 自定义滚动条 */
        scrollbar {
          width: 12px !important;
        }

        scrollbar thumb {
          background-color: var(--surface1) !important;
          border-radius: 6px !important;
        }

        scrollbar thumb:hover {
          background-color: var(--surface2) !important;
        }

        /* 自定义下载按钮 */
        #downloads-button {
          fill: var(--text) !important;
        }

        /* 自定义历史按钮 */
        #history-button {
          fill: var(--text) !important;
        }

        /* 自定义书签按钮 */
        #bookmarks-menu-button {
          fill: var(--text) !important;
        }

        /* 自定义设置按钮 */
        #PanelUI-menu-button {
          fill: var(--text) !important;
        }

        /* 紧凑模式增强 */
        #TabsToolbar {
          --toolbarbutton-inner-padding: 6px !important;
        }

        /* 自定义标签页多行显示 */
        #tabbrowser-tabs {
          --tab-min-height: 32px !important;
        }

        #tabbrowser-arrowscrollbox {
          overflow: visible !important;
        }

        #tabbrowser-tabs:not([overflow="true"]) {
          --tab-max-width: 150px !important;
        }
      '';

      # 用户Content样式
      userContent = ''
        /* 网页内容样式调整 */
        :root {
          scrollbar-color: var(--surface1) var(--mantle);
          scrollbar-width: thin;
        }

        /* 自定义新标签页 */
        @-moz-document url("about:newtab") {
          body {
            background-color: var(--base) !important;
            color: var(--text) !important;
          }
        }

        /* 自定义主页 */
        @-moz-document url("about:home") {
          body {
            background-color: var(--base) !important;
            color: var(--text) !important;
          }
        }
      '';
    };
  };
}