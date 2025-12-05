{ config, pkgs, lib, ... }:

{
  # 开发环境配置

  # 所有开发相关包在此统一声明，避免多次覆盖 home.packages
  home.packages =
    let
      baseDev = with pkgs; [
        # 版本控制
        git
        git-crypt
        lazygit
        gh
        glab
        tig
        delta

        # 构建工具
        cmake
        meson
        ninja
        gnumake
        bear

        # 编译器
        gcc
        clang
        rustc
        cargo
        go
        nodejs
        python3
        ruby
        php

        # 包管理器
        npm
        yarn
        pnpm
        pipx
        poetry
        pipenv
        rbenv
        nvm

        # 调试工具
        gdb
        lldb
        valgrind
        strace
        ltrace
        perf

        # 代码分析
        cloc
        tokei
        cppcheck
        shellcheck
        flake8
        pylint
        mypy
        eslint
        prettier
        black
        rust-analyzer
        clippy
        rustfmt

        # 容器化
        docker
        docker-compose
        podman
        buildah
        skopeo

        # 虚拟化
        qemu
        virt-manager
        virtualbox

        # CI/CD
        jenkins
        gitlab-runner
        github-cli

        # API 测试
        postman
        insomnia
        httpie
        curlie

        # 数据库工具
        mysql-client
        postgresql
        sqlite
        redis
        dbeaver

        # 文档
        mkdocs
        sphinx
        pandoc
        doxygen

        # 其他工具
        jq
        yq
        toml-cli
        cheat
        tealdeer
        thefuck
        shfmt
      ];

      pythonDev = with pkgs; [
        python3
        python3Packages.pip
        python3Packages.virtualenv
        python3Packages.pipenv
        python3Packages.poetry
        python3Packages.black
        python3Packages.isort
        python3Packages.flake8
        python3Packages.mypy
        python3Packages.pytest
        python3Packages.setuptools
        python3Packages.wheel
      ];

      # Node 生态在 baseDev 里已经包含 nodejs/npm/yarn/pnpm，这里暂不额外引入

      rustDev = with pkgs; [
        rustc
        cargo
        rust-analyzer
        clippy
        rustfmt
        cargo-watch
        cargo-edit
        cargo-audit
        cargo-outdated
      ];

      goDev = with pkgs; [
        go
        gopls
        delve
        golint
        go-tools
      ];

      cppDev = with pkgs; [
        gcc
        clang
        clang-tools
        gdb
        lldb
        cmake
        make
        ninja
        pkg-config
        valgrind
      ];

      javaDev = with pkgs; [
        jdk17
        maven
        gradle
      ];

      tools = with pkgs; [
        (writeShellScriptBin "create-project" ''
          #!/bin/sh
          # 创建项目模板

          if [ $# -eq 0 ]; then
            echo "Usage: create-project <project-name> [type]"
            echo "Types: python, node, rust, go, cpp, docker"
            exit 1
          fi

          PROJECT_NAME="$1"
          PROJECT_TYPE="''${2:-python}"
          PROJECT_DIR="$HOME/projects/$PROJECT_NAME"

          if [ -d "$PROJECT_DIR" ]; then
            echo "Project already exists: $PROJECT_DIR"
            exit 1
          fi

          mkdir -p "$PROJECT_DIR"
          cd "$PROJECT_DIR"

          case "$PROJECT_TYPE" in
            python)
              python3 -m venv venv
              echo "venv/" > .gitignore
              echo "__pycache__/" >> .gitignore
              echo "*.pyc" >> .gitignore
              echo "# $PROJECT_NAME" > README.md
              echo "" >> README.md
              echo "## Description" >> README.md
              echo "" >> README.md
              echo "## Installation" >> README.md
              echo "" >> README.md
              echo "## Usage" >> README.md
              echo "print(\"Hello, World!\")" > main.py
              git init
              git add .
              git commit -m "Initial commit"
              ;;

            node)
              npm init -y
              echo "node_modules/" > .gitignore
              echo ".env" >> .gitignore
              echo "# $PROJECT_NAME" > README.md
              npm install --save-dev typescript @types/node eslint prettier
              echo "console.log('Hello, World!');" > index.js
              git init
              git add .
              git commit -m "Initial commit"
              ;;

            rust)
              cargo init
              echo "# $PROJECT_NAME" > README.md
              git init
              git add .
              git commit -m "Initial commit"
              ;;

            go)
              go mod init "$PROJECT_NAME"
              mkdir -p cmd pkg
              cat > cmd/main.go << EOF
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
EOF
              echo "# $PROJECT_NAME" > README.md
              git init
              git add .
              git commit -m "Initial commit"
              ;;

            cpp)
              cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.10)
project($PROJECT_NAME)

add_executable($PROJECT_NAME main.cpp)
EOF
              cat > main.cpp << EOF
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF
              mkdir -p build
              echo "build/" > .gitignore
              echo "CMakeCache.txt" >> .gitignore
              echo "CMakeFiles/" >> .gitignore
              echo "cmake_install.cmake" >> .gitignore
              echo "# $PROJECT_NAME" > README.md
              git init
              git add .
              git commit -m "Initial commit"
              ;;

            docker)
              cat > Dockerfile << EOF
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF
              echo "node_modules/" > .gitignore
              echo ".env" >> .gitignore
              npm init -y
              echo "# $PROJECT_NAME" > README.md
              git init
              git add .
              git commit -m "Initial commit"
              ;;

            *)
              echo "Unknown project type: $PROJECT_TYPE"
              echo "Available types: python, node, rust, go, cpp, docker"
              exit 1
              ;;
          esac

          echo "Created $PROJECT_TYPE project: $PROJECT_DIR"
          echo "To start developing:"
          echo "  cd $PROJECT_DIR"
          case "$PROJECT_TYPE" in
            python) echo "  source venv/bin/activate" ;;
            node) echo "  npm install" ;;
            rust) echo "  cargo build" ;;
            go) echo "  go run ./cmd/main.go" ;;
            cpp) echo "  cd build && cmake .. && make" ;;
            docker) echo "  docker build -t $PROJECT_NAME ." ;;
          esac
        '')
      ];
    in
      baseDev
      ++ pythonDev
      ++ rustDev
      ++ goDev
      ++ cppDev
      ++ javaDev
      ++ tools;

  # 语言特定配置
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # 主题
      catppuccin.catppuccin-vsc

      # 基础工具
      ms-vscode.cpptools
      rust-lang.rust-analyzer
      golang.go
      ms-python.python
      bradlc.vscode-tailwindcss
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint

      # Git
      eamodio.gitlens
      donjayamanne.githistory
      mhutchie.git-graph

      # Docker
      ms-azuretools.vscode-docker

      # Nix
      bbenoist.nix
      jnoortheen.nix-ide

      # 远程开发
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers

      # 其他实用工具
      ms-vscode.hexeditor
      ms-vscode.live-server
      redhat.vscode-yaml
      ms-vscode.vscode-json
    ];

    userSettings = {
      # 基础设置
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.fontFamily" = "JetBrains Maple Mono";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.4;
      "editor.fontLigatures" = true;

      # 编辑器设置
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = false;
      "editor.trimAutoWhitespace" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = true;
      };

      # 终端设置
      "terminal.integrated.fontFamily" = "JetBrains Maple Mono";
      "terminal.integrated.fontSize" = 14;
      "terminal.integrated.shell.linux" = "/run/current-system/sw/bin/zsh";

      # Git 设置
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableCommitSigning" = true;

      # 文件设置
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      # 搜索设置
      "search.exclude" = {
        "**/node_modules" = true;
        "**/target" = true;
        "**/dist" = true;
        "**/.git" = true;
      };

      # 扩展设置
      "extensions.autoUpdate" = true;
      "extensions.autoCheckUpdates" = true;
      "extensions.ignoreRecommendations" = false;

      # 其他设置
      "workbench.startupEditor" = "welcomePageInEmptyWorkbench";
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;
      "update.enableWindowsBackgroundUpdates" = false;
    };
  };

  # Docker 配置
  programs.docker.enable = true;

  # 开发配置文件
  home.file.".devrc".text = ''
    # 开发环境配置

    # 导出路径
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="$HOME/go/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export PATH="$HOME/.npm-global/bin:$PATH"

    # Go 配置
    export GOPATH="$HOME/go"
    export GOROOT="/run/current-system/sw/share/go"

    # Rust 配置
    export CARGO_HOME="$HOME/.cargo"
    export RUSTUP_HOME="$HOME/.rustup"

    # Node.js 配置
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export NODE_REPL_HISTORY="$HOME/.node_repl_history"

    # Python 配置
    export PYTHONPATH="$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH"
    export PIPENV_VENV_IN_PROJECT=1

    # Java 配置
    export JAVA_HOME="${pkgs.jdk17}"

    # Docker 配置
    export DOCKER_BUILDKIT=1
    export COMPOSE_DOCKER_CLI_BUILD=1

    # 开发环境变量
    export EDITOR="nvim"
    export VISUAL="nvim"
    export BROWSER="firefox"
    export TERMINAL="ghostty"
  '';

  # 开发快捷键
  programs.bash.shellAliases = {
    # 开发目录
    pro = "cd ~/projects";
    wor = "cd ~/work";
    dot = "cd ~/.config";

    # 快速启动
    nvim-dev = "nvim ~/projects";
    code-pro = "code ~/projects";

    # 开发工具
    serve = "python3 -m http.server";
    serve-php = "php -S localhost:8000";
    serve-ruby = "ruby -run -e httpd . -p 8000";

    # 测试命令
    test-py = "python3 -m pytest";
    test-go = "go test ./...";
    test-node = "npm test";
    test-rust = "cargo test";
  };
}
