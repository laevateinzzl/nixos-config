{ config, pkgs, lib, ... }:

{
  # Shell 配置

  # Bash 配置
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignorespace" "ignoredups" ];
    historyIgnore = [
      "ls"
      "exit"
      "cd"
      "cd .."
      "pwd"
      "clear"
      "history"
      "h"
    ];
    historySize = 10000;
    historyFileSize = 50000;

    # 别名
    shellAliases = {
      # 文件操作
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
      lsa = "ls -lah";
      lsh = "ls -lh";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      mkdir = "mkdir -p";
      rmdir = "rmdir -p";
      tree = "tree -a -I '.git'";
      duh = "du -h --max-depth=1";
      duha = "du -ah --max-depth=1";

      # 导航
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "..... = "cd ../../../..";
      cd = "z";

      # 编辑器
      vim = "nvim";
      vi = "nvim";
      nano = "nvim";
      edit = "nvim";

      # grep 替代
      grep = "rg";
      egrep = "rg";
      fgrep = "rg";
      find = "fd";
      cat = "bat";
      less = "bat";

      # 系统信息
      top = "btop";
      htop = "btop";
      ps = "procs";
      df = "df -h";
      du = "dust";
      free = "free -h";

      # 网络
      ping = "ping -c 4";
      ping6 = "ping6 -c 4";
      dig = "drill";
      nslookup = "host";

      # Git（与 git.nix 配合）
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      glog = "git log --oneline --graph";

      # 开发
      py = "python3";
      pip = "pip3";
      node = "node";
      npm = "npm";
      cargo = "cargo";
      make = "make";
      cmake = "cmake";

      # 快捷方式
      myip = "curl -s ipinfo.io/ip";
      myip6 = "curl -s icanhazip.com";
      weather = "curl wttr.in";
      speedtest = "speedtest-cli";
      ports = "netstat -tuln";

      # 安全
      ssh = "ssh -o ConnectTimeout=10";
      scp = "scp -o ConnectTimeout=10";

      # NixOS 相关
      nix-search = "nix search nixpkgs";
      nix-shell = "nix-shell --run";
      nix-flake = "nix flake";
      rebuild = "sudo nixos-rebuild switch";
      rebuild-test = "sudo nixos-rebuild test";
      rebuild-boot = "sudo nixos-rebuild boot";
      rebuild-dry = "sudo nixos-rebuild dry-build";
      upgrade = "sudo nixos-rebuild switch --upgrade";

      # 系统服务
      restart-x = "sudo systemctl restart display-manager";
      restart-network = "sudo systemctl restart NetworkManager";
      restart-sound = "systemctl --user restart pipewire pipewire-pulse";

      # 清理
      cleanup = "nix-collect-garbage -d && nix optimise-store";

      # 备份
      backup-home = "tar -czf ~/backup-$(date +%Y%m%d).tar.gz ~/";
      backup-config = "cp -r ~/.config ~/backup/config-$(date +%Y%m%d)";

      # 其他
      calc = "python3 -c 'print($@)'";
      extract = "extract";
      mkcd = "mkdir -p \"$1\" && cd \"$1\"";
      brightness-up = "brightnessctl set +10%";
      brightness-down = "brightnessctl set 10%-";
      volume-up = "pamixer -i 5";
      volume-down = "pamixer -d 5";
      volume-mute = "pamixer -t";
    };

    initExtra = ''
      # Bash 配置增强

      # 加载颜色
      if [ -f "$HOME/.config/theme/colors.sh" ]; then
        . "$HOME/.config/theme/colors.sh"
      fi

      # 设置提示符
      if command -v starship > /dev/null 2>&1; then
        eval "$(starship init bash)"
      else
        # 简单的提示符
        PS1='\[\033[1;34m\]\w\[\033[0m\] \$ '
      fi

      # 启用 zoxide
      if command -v zoxide > /dev/null 2>&1; then
        eval "$(zoxide init bash)"
      fi

      # 自动补全增强
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      fi

      # 文件提取函数
      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # mkcd 函数
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # 智能补全
      complete -F _command cd
      complete -F _command sudo

      # 错误时提醒
      error_notify() {
        local exit_code=$?
        if [ $exit_code -ne 0 ]; then
          echo "Command failed with exit code: $exit_code" >&2
        fi
      }

      trap error_notify ERR

      # 欢迎信息
      if [ -f "$HOME/.local/bin/motd" ]; then
        "$HOME/.local/bin/motd"
      fi
    '';
  };

  # Zsh 配置
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    history.save = 10000;
    history.ignoreAllDups = true;
    history.ignoreSpace = true;
    historySubstringSearch.enable = true;

    # Oh My Zsh
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "zsh-completions"
        "extract"
        "web-search"
        "copypath"
        "copyfile"
        "sudo"
        "docker"
        "npm"
        "node"
        "python"
        "rust"
        "golang"
        "tmux"
        "vi-mode"
      ];
    };

    # 别名（继承 bash 别名并添加 zsh 特有）
    shellAliases = {
      # 继承 bash 别名
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
      lsa = "ls -lah";
      lsh = "ls -lh";
      tree = "tree -a -I '.git'";
      duh = "du -h --max-depth=1";
      duha = "du -ah --max-depth=1";

      # Zsh 特有别名
      - = "cd -";
      ... = "cd ../..";
      .... = "cd ../../..";
      ..... = "cd ../../../..";

      # 更强大的搜索
      history = "history -E";
      grep = "rg";
      find = "fd";

      # 快速目录切换
      cd = "z";
      cdi = "z -I";
      cdl = "z -l";

      # 编辑器
      vim = "nvim";
      vi = "nvim";
      nano = "nvim";
      edit = "nvim";

      # 系统信息
      top = "btop";
      htop = "btop";
      ps = "procs";
      df = "df -h";
      du = "dust";

      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      glog = "git log --oneline --graph";

      # NixOS
      nix-search = "nix search nixpkgs";
      rebuild = "sudo nixos-rebuild switch";
      rebuild-test = "sudo nixos-rebuild test";
      rebuild-boot = "sudo nixos-rebuild boot";
      rebuild-dry = "sudo nixos-rebuild dry-build";
      upgrade = "sudo nixos-rebuild switch --upgrade";
    };

    # Zsh 配置
    initExtra = ''
      # Zsh 配置增强

      # 加载颜色
      if [ -f "$HOME/.config/theme/colors.sh" ]; then
        . "$HOME/.config/theme/colors.sh"
      fi

      # 启用 starship
      if command -v starship > /dev/null 2>&1; then
        eval "$(starship init zsh)"
      fi

      # 启用 zoxide
      if command -v zoxide > /dev/null 2>&1; then
        eval "$(zoxide init zsh)"
      fi

      # Vi 模式设置
      bindkey -v

      # Vi 模式指示器
      function zle-line-init zle-keymap-select {
        VIM_PROMPT="%{\e[1;32m%}[INSERT]%{\e[0m%}"
        RPS1="$VIM_PROMPT $EPS1"
        zle reset-prompt
      }
      zle -N zle-line-init
      zle -N zle-keymap-select

      # 更好的历史搜索
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
      bindkey '^U' backward-kill-line
      bindkey '^K' kill-line

      # 自动 cd
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT

      # 补全设置
      setopt AUTO_MENU
      setopt ALWAYS_TO_END
      setopt COMPLETE_IN_WORD
      setopt PATH_DIRS
      setopt CDABLE_VARS

      # 修正拼写
      setopt CORRECT
      setopt CORRECT_ALL

      # 作业控制
      setopt LONG_LIST_JOBS
      setopt AUTO_RESUME

      # 历史设置
      setopt HIST_VERIFY
      setopt HIST_REDUCE_BLANKS
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_EXPIRE_DUPS_FIRST

      # 目录设置
      setopt AUTO_NAME_DIRS

      # 扩展设置
      setopt GLOB_DOTS
      setopt EXTENDED_GLOB
      setopt NUMERIC_GLOB_SORT

      # 函数
      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # 快速编辑配置
      conf() {
        case "$1" in
          zsh) nvim ~/.zshrc ;;
          bash) nvim ~/.bashrc ;;
          nvim) nvim ~/.config/nvim/init.lua ;;
          git) nvim ~/.gitconfig ;;
          tmux) nvim ~/.tmux.conf ;;
          *) echo "Usage: conf {zsh|bash|nvim|git|tmux}" ;;
        esac
      }

      # 快速 cd 到项目
      pro() {
        local projects_dir="$HOME/projects"
        if [ -d "$projects_dir" ]; then
          cd "$projects_dir/$1"
        else
          echo "Projects directory not found: $projects_dir"
        fi
      }

      # 生成密码
      genpass() {
        if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
          echo "Usage: genpass [length] [type]"
          echo "Types: alnum, alpha, numeric, lower, upper, symbols"
          return
        fi

        local length="''${1:-16}"
        local type="''${2:-alnum}"

        case "$type" in
          alnum) LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c "$length" ;;
          alpha) LC_ALL=C tr -dc '[:alpha:]' < /dev/urandom | head -c "$length" ;;
          numeric) LC_ALL=C tr -dc '[:digit:]' < /dev/urandom | head -c "$length" ;;
          lower) LC_ALL=C tr -dc '[:lower:]' < /dev/urandom | head -c "$length" ;;
          upper) LC_ALL=C tr -dc '[:upper:]' < /dev/urandom | head -c "$length" ;;
          symbols) LC_ALL=C tr -dc '[:alnum:][:punct:]' < /dev/urandom | head -c "$length" ;;
          *) echo "Unknown type: $type" ;;
        esac
      }

      # 创建并进入临时目录
      tmp() {
        local tmp_dir=$(mktemp -d)
        cd "$tmp_dir"
        echo "Created temporary directory: $tmp_dir"
      }

      # 错误处理
      TRAPZERR() {
        echo "Command failed with exit code: $?"
      }

      # 欢迎信息
      if [ -f "$HOME/.local/bin/motd" ]; then
        "$HOME/.local/bin/motd"
      fi
    '';
  };

  # Fish Shell 配置（可选）
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
      vim = "nvim";
      vi = "nvim";
      nano = "nvim";
      top = "btop";
      htop = "btop";
      grep = "rg";
      find = "fd";
      cat = "bat";
    };

    shellInit = ''
      # Fish 配置
      if command -v starship > /dev/null 2>&1
          starship init fish | source
      end

      if command -v zoxide > /dev/null 2>&1
          zoxide init fish | source
      end

      # 设置环境变量
      set -gx EDITOR nvim
      set -gx BROWSER firefox
      set -gx TERMINAL ghostty

      # 加载颜色
      if test -f "$HOME/.config/theme/colors.sh"
          source "$HOME/.config/theme/colors.sh"
      end
    '';
  };

  # 安装相关包
  home.packages = with pkgs; [
    # Shell 工具
    starship
    zoxide
    exa
    bat
    fd
    ripgrep
    fzf
    tree
    btop
    procs
    dust
    tokei
    neofetch
    fastfetch

    # 实用工具
    thefuck
    tldr
    cheat
    tealdeer
    mc
    ranger
    lf

    # 系统监控
    htop
    iotop
    iftop
    nethogs
    speedtest-cli

    # 网络
    curl
    wget
    httpie
    nmap
    wireshark-cli
    mtr
    dnsutils
    iputils

    # 文件管理
    zip
    unzip
    p7zip
    rar
    unrar
    tar
    gzip
    xz
  ];
}