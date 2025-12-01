{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    # 包
    extraPackages = with pkgs; [
      fzf
      ripgrep
      fd
      tree-sitter
      git
      wl-clipboard
    ];

    # LazyVim 默认启动配置，后续自定义可直接编辑 ~/.config/nvim/lua/plugins/
    extraLuaConfig = ''
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- 之后可在 ~/.config/nvim/lua/plugins/*.lua 添加自定义插件
        },
        defaults = {
          lazy = false,
          version = false,
        },
        install = { colorscheme = { "habamax" } },
        checker = { enabled = false },
      })
    '';
  };
}
