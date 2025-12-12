# NixOS 配置安装指南

这是一个完整的 NixOS 配置，集成了 Flake 和 Home Manager，采用了模块化设计，支持 Catppuccin 主题配色。

## 系统要求

- NixOS 支持的硬件
- UEFI 支持
- 至少 8GB RAM（推荐 16GB）
- 20GB 可用磁盘空间

## 快速开始

### 1. 准备安装

#### 下载 NixOS
```bash
# 从官方镜像站下载 NixOS minimal ISO (推荐使用 unstable)
# minimal ISO 可能没有 wget，可用 curl
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso \
  || curl -L -o nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
# 或从清华镜像
# wget https://mirrors.tuna.tsinghua.edu.cn/nixos-images/latest-nixos-minimal-x86_64-linux.iso
```

#### 创建启动 U 盘
```bash
# Linux/macOS
sudo dd if=nixos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
sync

# Windows (使用 Rufus 或 balenaEtcher)
```

### 2. 安装过程

#### 启动并配置网络
```bash
# 安装环境默认已是 root；若不是可用 sudo -i
sudo -i

# 配置网络（如果需要）
nmtui
# 或者手动配置
ip link set dev wlan0 up
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
dhclient wlan0
```

#### 分区磁盘（GPT + UEFI）
```bash
# 使用 fdisk 或 parted 分区
fdisk /dev/sda

# 推荐分区方案 (systemd-boot)：
# /dev/sda1  512M  EFI 系统分区 (ESP)
# /dev/sda2  剩余  根分区

# 格式化分区
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
```

#### 挂载文件系统
```bash
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

> 提示：minimal ISO 的根目录是内存盘（空间较小）。后续下载/克隆请放在 `/mnt`，或先建临时目录：  
> `mkdir -p /mnt/tmp && export TMPDIR=/mnt/tmp`

### 3. 配置系统

#### 生成初始配置
```bash
nixos-generate-config --root /mnt
```

#### 克隆配置文件
```bash
# 先备份生成的 hardware-configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix

# 克隆配置仓库
git clone https://github.com/laevateinzzl/nixos-config.git /mnt/etc/nixos

# 将硬件配置复制到正确位置
cp /tmp/hardware-configuration.nix /mnt/etc/nixos/hosts/nixos/hardware-configuration.nix
```

#### 修改配置
编辑以下文件：

1. `/mnt/etc/nixos/hosts/nixos/hardware-configuration.nix`
   - 更新磁盘 UUID
   - 确认硬件配置正确
   - 若未创建 swap 分区，请删除/注释 `swapDevices` 项

2. `/mnt/etc/nixos/flake.nix`
   - 修改用户名（laevatein）
   - 确认输入源版本

3. `/mnt/etc/nixos/hosts/nixos/configuration.nix`
   - 修改用户名
   - 设置主机名
   - 配置用户组

### 4. 安装系统

```bash
# 进入配置目录
cd /mnt/etc/nixos

# 创建用户密码哈希文件目录（注意：配置里读取的是 /etc/nixos/user-passwords/laevatein）
mkdir -p /mnt/etc/nixos/user-passwords

# 生成并保存密码哈希 (会提示输入密码)
nix-shell -p mkpasswd --run 'mkpasswd -m sha-512' > /mnt/etc/nixos/user-passwords/laevatein

# 由于安装阶段评估发生在 live 系统里，需同时放一份到 live 的 /etc/nixos
mkdir -p /etc/nixos/user-passwords
cp /mnt/etc/nixos/user-passwords/laevatein /etc/nixos/user-passwords/laevatein

# 安装系统
nixos-install --flake .#nixos --no-root-passwd

# 安装完成后会提示设置 root 密码
```

### 5. 完成安装

```bash
# 卸载文件系统
umount -R /mnt

# 重启系统
reboot
```

## 安装后配置

### 1. 首次登录

```bash
# 登录后进入用户 shell
su - laevatein

# 验证配置
nix-shell -p nix-info --run "nix-info -m"
```

### 2. 配置用户

```bash
# 更新 home-manager 配置
home-manager switch --flake .#laevatein

# 配置 Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. 配置 Fcitx5

```bash
# 安装 Rime 配置
mkdir -p ~/.local/share/fcitx5/rime
# 下载雾凇拼音配置
git clone https://github.com/iDvel/rime-ice.git ~/.local/share/fcitx5/rime/rime-ice

# 重新部署 fcitx5
fcitx5 -r
```

### 4. 测试应用

```bash
# 测试终端模拟器
ghostty

# 测试编辑器
nvim
zed

# 测试浏览器
firefox

# 测试状态栏
waybar

# 测试通知
notify-send "Test" "NixOS 配置成功！" -u normal
```

## 模块说明

### 系统模块 (`modules/system/`)

- `boot.nix` - systemd-boot 引导加载器配置
- `display-manager.nix` - SDDM 显示管理器
- `desktop.nix` - Niri 桌面环境和 Wayland 工具
- `gaming.nix` - Steam 游戏环境
- `locale.nix` - 本地化和输入法
- `networking.nix` - 网络配置
- `packages.nix` - 系统软件包
- `security.nix` - 安全配置

### Home Manager 模块 (`home/modules/`)

- `niri.nix` - Niri 窗口管理器配置
- `waybar.nix` - Waybar 状态栏配置
- `fuzzel.nix` - Fuzzel 应用启动器配置
- `mako.nix` - Mako 通知管理器配置
- `firefox.nix` - Firefox 浏览器配置
- `ghostty.nix` - Ghostty 终端模拟器配置
- `tmux.nix` - Tmux 终端复用器配置
- `lazyvim.nix` - LazyVim 配置
- `zed.nix` - Zed 编辑器配置
- `input-method.nix` - Fcitx5 输入法配置
- `catppuccin.nix` - Catppuccin 主题配置
- `git.nix` - Git 版本控制配置
- `shell.nix` - Shell 环境配置
- `development.nix` - 开发环境配置

## 常用命令

### 系统管理
```bash
# 重建系统
sudo nixos-rebuild switch

# 测试配置
sudo nixos-rebuild test

# 升级系统
sudo nixos-rebuild switch --upgrade

# 查看配置差异
sudo nixos-rebuild dry-build

# 滚动更新
sudo nix-channel --update nixos
sudo nixos-rebuild switch

# 清理旧配置
sudo nix-collect-garbage -d
sudo nix optimise-store
```

### Home Manager
```bash
# 应用 Home Manager 配置
home-manager switch --flake .

# 重新加载配置
home-manager reload --flake .

# 生成 Home Manager 配置
home-manager build --flake .

# 清理 Home Manager
home-manager expire-generations "7d ago"
```

### 包管理
```bash
# 查找包
nix search nixpkgs package-name

# 临时安装包
nix-shell -p package-name

# 查看包信息
nix info nixpkgs#package-name

# 进入开发环境
nix develop
```

## 故障排除

### 常见问题

1. **启动失败**
   - 检查 `/etc/nixos/configuration.nix` 语法
   - 验证 `hardware-configuration.nix` 磁盘 UUID
   - 检查 bootloader 配置

2. **显卡问题**
   - 根据显卡类型安装相应驱动
   - 在 `desktop.nix` 中启用正确的显卡配置

3. **网络问题**
   - 检查 `networking.nix` 配置
   - 验证防火墙设置
   - 检查 NetworkManager 状态

4. **输入法问题**
   - 重新安装 fcitx5 配置
   - 检查环境变量设置
   - 重启 fcitx5 服务

### 日志查看
```bash
# 查看系统日志
journalctl -b

# 查看特定服务日志
journalctl -u NetworkManager
journalctl -u fcitx5
journalctl -u sddm

# 实时查看日志
journalctl -f
```

## 自定义配置

### 添加新模块

1. 在 `modules/system/` 或 `home/modules/` 创建新模块文件
2. 在 `flake.nix` 中导入新模块
3. 在配置文件中启用模块

### 修改主题

1. 编辑 `home/modules/catppuccin.nix`
2. 更新各个应用的配色方案
3. 重新应用配置

### 添加新用户

1. 在 `hosts/nixos/configuration.nix` 中添加用户配置
2. 在 `flake.nix` 中添加用户的 Home Manager 配置
3. 创建用户的 home-manager 配置文件

## 更新和维护

### 定期维护
```bash
# 更新 channel
sudo nix-channel --update

# 升级系统
sudo nixos-rebuild switch --upgrade

# 清理垃圾
sudo nix-collect-garbage -d
nix-collect-garbage -d --delete-older-than 30d

# 优化存储
sudo nix optimise-store
```

### 备份配置
```bash
# 备份 /etc/nixos
sudo cp -r /etc/nixos /backup/nixos-$(date +%Y%m%d)

# 备份 home 配置
cp -r ~/.config ~/.config-backup-$(date +%Y%m%d)
```

## 资源链接

- [NixOS 官方文档](https://nixos.org/manual/)
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Niri 窗口管理器](https://github.com/YaLTeR/niri)
- [Catppuccin 主题](https://github.com/catppuccin)
- [Fcitx5](https://fcitx-im.org/)
- [Flakes](https://nixos.wiki/wiki/Flakes)

## 许可证

本配置文件基于 MIT 许可证。您可以自由使用、修改和分发。

---

🎉 祝您使用愉快！如有问题，请查看 Wiki 或提交 Issue。
