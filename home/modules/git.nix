{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    # userName/userEmail 由 home/default.nix 统一定义，避免冲突

    # 别名
    aliases = {
      # 基础别名
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      cp = "cherry-pick";
      df = "diff";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      lo = "log --oneline --decorate --graph";
      tree = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";

      # 便捷操作
      aa = "add --all";
      ap = "add --patch";
      undo = "reset --soft HEAD~1";
      amend = "commit --amend";
      wipe = "commit -am 'WIP' && git reset HEAD~1 --hard";
      credit = "!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f";
      word-diff = "diff --color-words";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      who = "!git log --pretty=format:'%an' | sort | uniq -c | sort -nr";

      # 分支操作
      nb = "!f() { git checkout -b \"$1\"; }; f";
      db = "!f() { git branch -d \"$1\"; }; f";
      dbf = "!f() { git branch -D \"$1\"; }; f";
      mkbranch = "!f() { git checkout -b \"$1\" origin/\"$1\"; }; f";
      rmbranch = "!f() { git branch -d \"$1\" && git push origin :\"$1\"; }; f";

      # 远程操作
      pullr = "pull --rebase";
      this = "!git init && git add . && git commit -m 'Initial commit'";
      po = "!git push origin \"$(git rev-parse --abbrev-ref HEAD)\"";

      # 搜索和查找
      find-text = "!f() { git log --all --grep=\"$1\"; }; f";
      find-file = "!f() { git log --all -- \"$1\"; }; f";
      find-commit = "!f() { git log --all --grep=\"$1\" --oneline; }; f";
      find-author = "!f() { git log --author=\"$1\" --oneline; }; f";

      # 清理
      clean-branches = "!git branch -r --merged | grep -v \"origin/HEAD\\|origin/master\\|origin/main\" | sed \"s/origin\\//\" | xargs -I {} git push origin --delete {}";
      clean-local = "!git branch --merged | grep -v \"\\*\" | grep -v \"master\\|main\\|develop\" | xargs git branch -d";

      # 撤销操作
      uncommit = "reset --soft HEAD~1";
      undo-merge = "reset --hard ORIG_HEAD";
      revert-file = "!f() { git checkout HEAD -- \"$1\"; }; f";

      # 统计
      stats = "!git log --shortstat --author \"$1\" | grep \"files changed\\|insertions\\|deletions\" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print \"files changed: \" files \"\\ninsertions: \" inserted \"\\ndeletions: \" deleted \"\\nnet+: \" (inserted-deleted)}'";
      contributions = "!git shortlog --no-merges --numbered --summary";

      # 查看大文件
      big-files = "!git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 | tail -10";

      # 查看历史文件
      show-file = "!f() { git show \"$1:$2\"; }; f";
    };

    # 颜色配置
    extraConfig = {
      # 分支颜色
      color.branch = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };

      # diff 颜色
      color.diff = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red";
        new = "green";
        whitespace = "red reverse";
      };

      # grep 颜色
      color.grep = {
        context = "normal";
        filename = "magenta";
        function = "blue";
        linenumber = "green";
        match = "yellow bold";
        selected = "cyan";
        separator = "blue";
      };

      # 状态颜色
      color.status = {
        added = "green";
        changed = "yellow";
        untracked = "cyan";
        header = "normal";
        branch = "magenta";
      };

      # UI 配置
      color.ui = "auto";

      # 分支显示
      branch = {
        autosetuprebase = "always";
        sort = "-committerdate";
      };

      # 提交信息
      commit = {
        template = "${config.home.homeDirectory}/.gitmessage";
        gpgsign = false;
      };

      # diff 配置
      diff = {
        tool = "vimdiff";
        algorithm = "histogram";
        renames = true;
        mnemonicPrefix = true;
        wsErrorHighlight = "all";
      };

      # difftool 配置
      difftool = {
        prompt = false;
        trustExitCode = true;
      };

      # merge 配置
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
        summary = true;
        ff = "only";
      };

      # mergetool 配置
      mergetool = {
        prompt = false;
        keepBackup = false;
        trustExitCode = true;
        vimdiff = {
          cmd = "vim -f";
        };
      };

      # pull 配置
      pull = {
        rebase = true;
        ff = "only";
      };

      # push 配置
      push = {
        default = "simple";
        autoSetupRemote = true;
      };

      # rebase 配置
      rebase = {
        autostash = true;
        autoSquash = true;
        stat = true;
      };

      # fetch 配置
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
        parallel = 0;
      };

      # 签名配置（可选）
      "gpg" = {
        format = "ssh";
        ssh = {
          program = "${pkgs._1password-gui}/bin/op-ssh-sign";
          allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
        };
      };

      # init 配置
      init = {
        defaultBranch = "main";
      };

      # log 配置
      log = {
        date = "relative";
        decorate = "short";
        showRoot = true;
      };

      # tag 配置
      tag = {
        gpgSign = false;
        sort = "-version:refname";
      };

      # core 配置
      core = {
        editor = "nvim";
        pager = "less -FRSX";
        autocrlf = "input";
        safecrlf = "true";
        quotePath = "false";
        precomposeunicode = "true";
        ignorecase = "false";
        filemode = "true";
        fsmonitor = true;
      };

      # sendemail 配置（可选）
      "sendemail" = {
        smtpServer = "smtp.gmail.com";
        smtpUser = "your.email@gmail.com";
        smtpEncryption = "tls";
        smtpServerPort = 587;
        annotate = true;
      };

      # status 配置
      status = {
        showUntrackedFiles = "normal";
        short = true;
        branch = true;
      };

      # 忽略文件
      "core.excludesfile" = "${config.home.homeDirectory}/.gitignore_global";

      # 仓库别名（快速切换）
      "url \"git@github.com:\"".insteadOf = "https://github.com/";
      "url \"git@gitlab.com:\"".insteadOf = "https://gitlab.com/";
    };

    # 忽略文件
    ignores = [
      # 编辑器
      ".vscode/"
      ".zed/"
      ".idea/"
      ".vscodium/"
      "*.swp"
      "*.swo"
      "*~"
      ".DS_Store"

      # 临时文件
      "*.tmp"
      "*.temp"
      "*."
      ".env"
      ".env.local"
      ".env.*.local"

      # 依赖目录
      "node_modules/"
      ".npm/"
      ".cache/"
      "dist/"
      "build/"
      "target/"
      ".pytest_cache/"
      ".mypy_cache/"
      "__pycache__/"
      "*.pyc"
      "*.pyo"
      "*.pyd"
      ".coverage"
      "*.log"

      # 系统文件
      "Thumbs.db"
      "*.sublime-*"
      ".project"
      ".settings"
      ".classpath"

      # 备份文件
      "*.bak"
      "*.backup"
      "*.old"

      # 密钥和证书
      "*.pem"
      "*.key"
      "*.crt"
      "*.p12"

      # 数据库
      "*.db"
      "*.sqlite"
      "*.sqlite3"

      # 操作系统生成的文件
      "Icon?"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"
      "Desktop.ini"

      # IDE 特定
      ".vscode/settings.json"
      ".vscode/launch.json"
      ".vscode/extensions.json"
      "*.code-workspace"

      # Docker
      ".dockerignore"
      ".docker"

      # Kubernetes
      "*.kubeconfig"
    ];
  };

  # 提交信息模板
  home.file.".gitmessage".text = ''
    # 提交消息模板

    # 标题: 简短描述 (50字符以内)
    #
    # 问题描述: 这个提交解决了什么问题？
    #
    # 实现方法: 如何实现的？做了哪些关键改变？
    #
    # 测试说明: 如何验证这个改动？测试了哪些方面？
    #
    # 相关问题: 关联的 Issue 编号
    #
    # 示例:
    #
    # feat: 添加用户认证功能
    #
    # 问题描述:
    # 系统需要实现用户登录和认证功能以确保安全性
    #
    # 实现方法:
    # - 添加用户模型和数据库表
    # - 实现JWT token认证
    # - 添加登录/注册API端点
    # - 更新前端表单
    #
    # 测试说明:
    # - 测试用户注册流程
    # - 验证登录认证
    # - 测试token验证
    #
    # 相关问题: #123
  '';

  # SSH 签名文件
  home.file.".config/git/allowed_signers".text = ''
    # Git SSH 签名者列表
    # 格式: <email> <ssh-key-type> <ssh-key>
  '';

  # Git 相关工具
  home.packages = with pkgs; [
    git
    git-crypt
    git-filter-repo
    lazygit
    delta
    hub
    gh
    bfg-repo-cleaner
    pre-commit
    gitui
    glab
    tig
  ];

  # lazygit 配置
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = ["#89b4fa" "bold"];
          inactiveBorderColor = ["#45475a"];
          selectedLineBgColor = ["#313244"];
          cherryPickedCommitBgColor = ["#f9e2af"];
          cherryPickedCommitFgColor = ["#1e1e2e"];
          unstagedChangesColor = ["#f38ba8"];
          defaultFgColor = ["#cdd6f4"];
          searchingActiveBorderColor = ["#f9e2af"];
        };
        authorColors = {
          "*" = "#cba6f7";
        };
        branchColors = {
          feature = "#89b4fa";
          bugfix = "#a6e3a1";
          hotfix = "#f38ba8";
          release = "#f9e2af";
        };
      };
    };
  };

  # Delta 配置
  home.file.".gitconfig-delta".text = ''
    [delta]
    features = decorations
    navigate = true
    light = false
    side-by-side = false
    line-numbers = true
    hyperlinks = true
    syntax-theme = "Dracula"
    file-style = "omit"
    file-decoration-style = "blue"
    hunk-header-decoration-style = "blue box"
    hunk-header-file-style = "blue"
    hunk-header-line-number-style = "blue"
    hunk-header-style = "file line-number syntax"
    plus-style = "syntax #a6e3a1"
    minus-style = "syntax #f38ba8"
    merge-conflict-begin-symbol = "⌘"
    merge-conflict-end-symbol = "⌘"
    merge-conflict-ours-diff-header-decoration-style = "red ul"
    merge-conflict-theirs-diff-header-decoration-style = "blue ul"
  '';

  # pre-commit 配置
  home.file.".pre-commit-config.yaml".text = ''
    # Pre-commit hooks configuration
    repos:
      - repo: https://github.com/pre-commit/pre-commit-hooks
        rev: v4.4.0
        hooks:
          - id: trailing-whitespace
          - id: end-of-file-fixer
          - id: check-yaml
          - id: check-added-large-files
          - id: check-merge-conflict
          - id: debug-statements
          - id: check-json
          - id: check-toml
          - id: check-xml
          - id: check-yaml
          - id: pretty-format-json
          - id: requirements-txt-fixer
          - id: fix-byte-order-marker

      - repo: https://github.com/doublify/pre-commit-rust
        rev: v1.0
        hooks:
          - id: fmt
          - id: clippy
          - id: cargo-check

      - repo: https://github.com/psf/black
        rev: 23.3.0
        hooks:
          - id: black
            language_version: python3

      - repo: https://github.com/pycqa/isort
        rev: 5.12.0
        hooks:
          - id: isort

      - repo: https://github.com/pycqa/flake8
        rev: 6.0.0
        hooks:
          - id: flake8

      - repo: https://github.com/pre-commit/mirrors-eslint
        rev: v8.39.0
        hooks:
          - id: eslint
            additional_dependencies:
              - eslint@8.39.0
              - "@typescript-eslint/eslint-plugin"
              - "@typescript-eslint/parser"
  '';
}
