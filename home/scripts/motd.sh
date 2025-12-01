#!/bin/bash

# MOTD (Message of the Day) - Catppuccin themed

# 加载颜色
if [ -f "$HOME/.config/theme/colors.sh" ]; then
    source "$HOME/.config/theme/colors.sh"
else
    # 默认颜色（如果主题文件不存在）
    BASE="#1e1e2e"
    TEXT="#cdd6f4"
    BLUE="#89b4fa"
    GREEN="#a6e3a1"
    YELLOW="#f9e2af"
    RED="#f38ba8"
    MAUVE="#cba6f7"
fi

# 颜色转义序列
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
ITALIC="\033[3m"

# 颜色函数
color() {
    local color_code="$1"
    echo -e "\033[38;2;$(echo "$color_code" | sed 's/#//; s/\(..\)\(..\)\(..\)/\1;\2;\3/')m"
}

# 系统信息
get_os_info() {
    echo "$(uname -s) $(uname -r)"
}

get_uptime() {
    if command -v uptime >/dev/null 2>&1; then
        uptime -p 2>/dev/null || uptime | awk '{print $3,$4}' | sed 's/,//'
    else
        echo "Unknown"
    fi
}

get_mem_usage() {
    if command -v free >/dev/null 2>&1; then
        free -h | awk 'NR==2{printf "%.1f/%.1fGB (%.0f%%)", $3,$2,$3*100/$2 }'
    else
        echo "Unknown"
    fi
}

get_disk_usage() {
    if command -v df >/dev/null 2>&1; then
        df -h / 2>/dev/null | awk 'NR==2{printf "%s/%s (%s)", $3,$2,$5}'
    else
        echo "Unknown"
    fi
}

get_ip_address() {
    if command -v ip >/dev/null 2>&1; then
        ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' | head -n 1
    elif command -v hostname >/dev/null 2>&1; then
        hostname -I 2>/dev/null | awk '{print $1}'
    else
        echo "Unknown"
    fi
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 主 MOTD 函数
main() {
    # Catppuccin ASCII Art (简化版)
    cat << "EOF"
$(color $BLUE)╭─────────────────────────────────────────────────────────────╮$(RESET)
│$(color $GREEN)    ╭───────────╮    ╭───────────╮    ╭───────────╮$(RESET)    │
│$(color $GREEN)   ╭─╯         ╰──╮ ╭─╯         ╰──╮ ╭─╯         ╰──╮$(RESET)   │
│$(color $GREEN)  ╭─┘  $(color $YELLOW)🐱$(RESET)$(color $GREEN)          ╰─┤╭─┘  $(color $YELLOW)🍨$(RESET)$(color $GREEN)          ╰─┤╭─┘  $(color $YELLOW)☕$(RESET)$(color $GREEN)          ╰─┤$(RESET)  │
│  │$(color $TEXT)   NixOS Configuration with Catppuccin Theme   │$(RESET)  │
│  ╰─────────────────────────────────────────────────────╯│
╰─────────────────────────────────────────────────────────────╯
EOF

    echo
    echo -e "$(color $MAUVE)╭─ System Information$(RESET) $(color $MAUVE)────────────────────────────────────────╮$(RESET)"
    echo -e "│  $(color $TEXT)🖥️  Host:$(RESET) $(color $YELLOW)$(hostname)$(RESET)                              │"
    echo -e "│  $(color $TEXT)💻  OS:$(RESET) $(color $GREEN)$(get_os_info)$(RESET)                              │"
    echo -e "│  $(color $TEXT)⏰  Uptime:$(RESET) $(color $YELLOW)$(get_uptime)$(RESET)                           │"
    echo -e "│  $(color $TEXT)🧠  Memory:$(RESET) $(color $GREEN)$(get_mem_usage)$(RESET)                        │"
    echo -e "│  $(color $TEXT)💾  Disk:$(RESET) $(color $GREEN)$(get_disk_usage)$(RESET)                           │"
    echo -e "│  $(color $TEXT)🌐  IP:$(RESET) $(color $BLUE)$(get_ip_address)$(RESET)                             │"
    echo -e "╰─────────────────────────────────────────────────────╯"
    echo

    # 快捷键提示
    echo -e "$(color $MAUVE)╭─ Quick Shortcuts$(RESET) $(color $MAUVE)─────────────────────────────────────────╮$(RESET)"
    echo -e "│  $(color $TEXT)🎮$(RESET) $(color $GREEN)Mod+Enter$(RESET)     - Launch Ghostty                    │"
    echo -e "│  $(color $TEXT)🚀$(RESET) $(color $GREEN)Mod+d$(RESET)           - Launch Fuzzel (App Launcher)     │"
    echo -e "│  $(color $TEXT)🔍$(RESET) $(color $GREEN)Mod+Shift+f$(RESET)     - Launch Firefox                    │"
    echo -e "│  $(color $TEXT)💻$(RESET) $(color $GREEN)Mod+1-9$(RESET)         - Switch Workspace                  │"
    echo -e "│  $(color $TEXT)🖱️$(RESET) $(color $GREEN)Ctrl+Alt+T$(RESET)      - Open Terminal                    │"
    echo -e "│  $(color $TEXT)🎨$(RESET) $(color $GREEN)wallpaper-cycle$(RESET) - Change Wallpaper                  │"
    echo -e "╰─────────────────────────────────────────────────────╯"
    echo

    # 开发环境提示
    if command_exists git && [ -d "$HOME/.git" ]; then
        local git_status=$(git status --porcelain 2>/dev/null | wc -l)
        if [ "$git_status" -gt 0 ]; then
            echo -e "$(color $MAUVE)╭─ Git Status$(RESET) $(color $MAUVE)─────────────────────────────────────────────╮$(RESET)"
            echo -e "│  $(color $YELLOW)⚠️  You have $(color $RED)$git_status$(RESET) $(color $TEXT)uncommitted changes$(RESET)          │"
            echo -e "╰─────────────────────────────────────────────────────╯"
            echo
        fi
    fi

    # 系统提醒
    echo -e "$(color $MAUVE)╭─ System Tips$(RESET) $(color $MAUVE)──────────────────────────────────────────────╮$(RESET)"
    echo -e "│  $(color $TEXT)📦$(RESET) $(color $GREEN)rebuild$(RESET)         - Rebuild NixOS configuration       │"
    echo -e "│  $(color $TEXT)🧹$(RESET) $(color $GREEN)cleanup$(RESET)          - Clean Nix store                    │"
    echo -e "│  $(color $TEXT)🔍$(RESET) $(color $GREEN)upgrade$(RESET)          - Upgrade NixOS packages             │"
    echo -e "│  $(color $TEXT)📚$(RESET) $(color $GREEN)man nixos-rebuild$(RESET) - NixOS manual                      │"
    echo -e "╰─────────────────────────────────────────────────────╯"
    echo

    # 引用
    local quotes=(
        "Keep calm and $(color $BLUE)catppuccin$(RESET) on ☕"
        "May your code compile without errors $(color $GREEN)✨$(RESET)"
        "Remember to commit your changes $(color $YELLOW)💾$(RESET)"
        "Stay hydrated and happy coding $(color $BLUE)💙$(RESET)"
        "Today is a good day to $(color $GREEN)build$(RESET) something amazing"
    )

    local random_quote="${quotes[$RANDOM % ${#quotes[@]}]}"
    echo -e "$(color $MAUVE)╭─ Quote of the Day$(RESET) $(color $MAUVE)──────────────────────────────────────────╮$(RESET)"
    echo -e "│  $random_quote$(RESET)                                          │"
    echo -e "╰─────────────────────────────────────────────────────╯"
    echo
}

# 检查是否是交互式会话
if [[ $- == *i* ]]; then
    main
fi