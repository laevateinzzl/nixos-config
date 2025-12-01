{ config, pkgs, lib, ... }:

{
  # Fcitx5 Rime 输入法配置
  home.packages = with pkgs; [
    fcitx5
    fcitx5-rime
    fcitx5-configtool
    fcitx5-gtk
    fcitx5-qt
    fcitx5-chinese-addons
  ];

  # Fcitx5 环境变量
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
  };

  # Fcitx5 配置目录
  home.file.".config/fcitx5".source = ./fcitx5;

  # Rime 配置
  home.file.".local/share/fcitx5/rime".source = ./rime;

  # 启动脚本
  home.file.".config/autostart-scripts/fcitx5.sh".text = ''
    #!/bin/sh
    # Fcitx5 启动脚本

    # 确保fcitx5进程运行
    if ! pgrep -x "fcitx5" > /dev/null; then
        fcitx5 -d
        sleep 1
    fi

    # 设置环境变量
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    export SDL_IM_MODULE=fcitx
    export INPUT_METHOD=fcitx

    # 壁纸切换快捷键
    if [ -x "$(command -v swww)" ]; then
        # 设置随机壁纸
        WALLPAPER_DIR="$HOME/Pictures/wallpapers"
        if [ -d "$WALLPAPER_DIR" ]; then
            RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -name "*.jpg" -o -name "*.png" -o -name "*.webp" | shuf -n 1)
            if [ -f "$RANDOM_WALLPAPER" ]; then
                swww img "$RANDOM_WALLPAPER" --transition-type random
            fi
        fi
    fi
  '';

  # 使启动脚本可执行
  home.file.".config/autostart-scripts/fcitx5.sh".executable = true;

  # 桌面条目
  home.file.".local/share/applications/fcitx5-configtool.desktop".text = ''
    [Desktop Entry]
    Name=Fcitx5 Configuration
    Name[zh_CN]=Fcitx5 配置
    GenericName=Input Method Configuration
    GenericName[zh_CN]=输入法配置
    Comment=Configure Fcitx5
    Comment[zh_CN]=配置 Fcitx5
    Exec=fcitx5-configtool
    Icon=fcitx
    Terminal=false
    Type=Application
    Categories=Settings;System;
    Keywords=input;method;ime;fcitx;configure;settings;
    Keywords[zh_CN]=输入;输入法;ime;fcitx;配置;设置;
  '';

  # 雾凇拼音Rime配置文件
  home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
    # Rime 默认配置
    __patch:
      schema_list:
        - schema: rime_ice          # 雾凇拼音
        - schema: terra_pinyin      # 地球拼音
        - schema: luna_pinyin       # 朙月拼音
      "menu/page_size": 9
      "switcher/caption": 「方案選單」
      "switcher/hotkeys":
        - F4
        - Control+grave
  '';

  home.file.".local/share/fcitx5/rime/rime_ice.custom.yaml".text = ''
    # 雾凇拼音自定义配置
    patch:
      translator/spelling_hints: 7
      engine/translators:
        - punct_translator
        - reverse_lookup_translator
        - script_translator
      schema:
        dependencies:
          - stroke
          - luna_pinyin
      engine:
        processors:
          - ascii_composer
          - recognizer
          - key_binder
          - speller
          - punctuator
          - selector
          - navigator
          - express_editor
        segmentors:
          - ascii_segmentor
          - matcher
          - affix_segmentor@abc
          - abc_segmentor
          - punct_segmentor
          - fallback_segmentor
        translators:
          - punct_translator
          - reverse_lookup_translator
          - script_translator
      "speller/alphabet": zyxwvutsrqponmlkjihgfedcba
      "speller/algebra/abbrev": "^([a-z]).+$4"
      "speller/algebra/erase/^([z])$//"
      "speller/algebra/erase/^([aoe].*)$//"
      "speller/algebra/erase/^([ae])(.*)$/$1$2/"
      "speller/algebra/erase/^([i])(n|ng|u|ong)$/$1$2/"
      "speller/algebra/erase/^([iu])([aoe])/$2$1/"
      "speller/algebra/erase/^([i][ou]?)$/$1/"
      "speller/algebra/erase/^([u])([aeiou])/$2$1/"
      "speller/algebra/erase/^([v])$//"
      "speller/algebra/erase/^([jqxy])$//"
      "speller/algebra/erase/^([i]a)$/$1/"
      "speller/algebra/erase/^([i]o)$/$1/"
      "speller/algebra/erase/^([u]a)$/$1/"
      "speller/algebra/erase/^([u]o)$/$1/"
      "speller/algebra/erase/^([i]ao)$/$1/"
      "speller/algebra/erase/^([i]an)$/$1/"
      "speller/algebra/erase/^([i]ang)$/$1/"
      "speller/algebra/erase/^([i]ong)$/$1/"
      "speller/algebra/erase/^([u]ai)$/$1/"
      "speller/algebra/erase/^([u]an)$/$1/"
      "speller/algebra/erase/^([u]ang)$/$1/"
      "speller/algebra/erase/^([u]ei)$/$1/"
      "speller/algebra/erase/^([u]en)$/$1/"
      "speller/algebra/erase/^([u]eng)$/$1/"
      "speller/algebra/erase/^([u]an)$/$1/"
      "speller/algebra/erase/^([u]ang)$/$1/"
      "speller/algebra/erase/^([i]an)$/$1/"
      "speller/algebra/erase/^([i]ang)$/$1/"
      "speller/algebra/erase/^([i]ong)$/$1/"
      "speller/algebra/erase/^([i]ai)$/$1/"
      "speller/algebra/erase/^([i]ei)$/$1/"
      "speller/algebra/erase/^([i]en)$/$1/"
      "speller/algebra/erase/^([i]eng)$/$1/"
      "speller/algebra/erase/^([i]ou)$/$1/"
      "speller/algebra/erase/^([u]ai)$/$1/"
      "speller/algebra/erase/^([u]ei)$/$1/"
      "speller/algebra/erase/^([u]ou)$/$1/"
      "speller/algebra/erase/^([u]an)$/$1/"
      "speller/algebra/erase/^([u]ang)$/$1/"
      "speller/algebra/erase/^([u]en)$/$1/"
      "speller/algebra/erase/^([u]eng)$/$1/"
      "speller/algebra/erase/^([u]ong)$/$1/"
      "speller/algebra/erase/^([i]a)$/$1/"
      "speller/algebra/erase/^([i]e)$/$1/"
      "speller/algebra/erase/^([i]o)$/$1/"
      "speller/algebra/erase/^([u]a)$/$1/"
      "speller/algebra/erase/^([u]e)$/$1/"
      "speller/algebra/erase/^([u]o)$/$1/"
      "speller/algebra/erase/^([v]e)$/$1/"
      "speller/algebra/erase/^([v]an)$/$1/"
      "speller/algebra/erase/^([v]e)$/$1/"
      "speller/algebra/erase/^([v]an)$/$1/"
      "speller/algebra/erase/^([v]e)$/$1/"
      "speller/algebra/erase/^([v]an)$/$1/"
      "speller/algebra/erase/^([v]e)$/$1/"
      "speller/algebra/erase/^([v]an)$/$1/"
  '';

  # Fcitx5 主题配置（Catppuccin）
  home.file.".local/share/fcitx5/theme/catppuccin-mocha" = {
    source = ./fcitx5-theme;
    recursive = true;
  };

  home.file.".config/fcitx5/conf/classicui.conf".text = ''
    # Fcitx5 经典界面配置
    # 主题
    Theme=catppuccin-mocha
    # 垂直候选列表
    Vertical Candidate List=True
    # 按屏幕 DPI 缩放
    PerScreenDPI=True
    # 字体
    Font="JetBrainsMono Nerd Font 12"
    # 菜单字体
    MenuFont="JetBrainsMono Nerd Font 12"
    # 输入法字体
    InputMethodFont="JetBrainsMono Nerd Font 12"
    # 显示候选词数量
    MaxHeight=200
    # 候选词数量
    Margin=0
    # 前景颜色
    Foreground=#cdd6f4
    # 背景颜色
    Background=#1e1e2e
    # 选中前景颜色
    HighlightForeground=#1e1e2e
    # 选中背景颜色
    HighlightBackground=#89b4fa
    # 边框颜色
    BorderColor=#585b70
    # 输入框背景颜色
    InputBackground=#313244
    # 输入框前景颜色
    InputForeground=#cdd6f4
    # 索引颜色
    IndexColor=#a6e3a1
    # 其他文本颜色
    OtherColor=#6c7086
    # 高亮文本颜色
    HighlightOtherColor=#cdd6f4
    # 高亮索引颜色
    HighlightIndexColor=#a6e3a1
    # 活动颜色
    ActiveColor=#89b4fa
    # 活动背景颜色
    ActiveBackgroundColor=#45475a
    # 文本字体
    TextFont="JetBrainsMono Nerd Font 12"
    # 文本颜色
    TextColor=#cdd6f4
    # 提示字体
    UseInputMethodLangToDisplayText=True
    # 提示文本颜色
    TextHintColor=#6c7086
    # 中英文切换键
    SwitchKey=Control+space
    # 中英文切换模式
    ShowFirst=Input
    # 显示输入法名称
    ShowInputMethodHint=True
    # 显示切换提示
    ShowInputMethodInformation=True
    # 输入法信息时间
    ShowInputMethodInformationWhenOnly=True
    # 输入法提示时间
    InputMethodInformationTimeout=3000
    # 全角/半角切换键
    FullWidthPuncKey=Control+period
    # 全角/半角切换模式
    FullWidthPuncFollow=TRUE
    # 页面大小
    PageSize=9
    # 皮肤高度
    SkinType=Default
    # 输入条高度
    InputHeight=32
    # 候选词高度
    CandidateHeight=32
    # 文字边距
    TextMargin=8
    # 候选词边距
    CandidatePadding=6
    # 圆角半径
    CornerRadius=8
    # 边框宽度
    BorderWidth=1
    # 输入框边距
    InputMargin=8
    # 候选词间隔
    CandidateSpacing=4
    # 垂直间距
    VerticalSpacing=2
    # 水平间距
    HorizontalSpacing=8
    # 显示皮肤名称
    ShowSkinName=True
    # 显示输入法版本
    ShowVersion=True
    # 显示主题信息
    ShowTheme=True
  '';
}