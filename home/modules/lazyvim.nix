{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    # 包
    extraPackages = with pkgs; [
      # LSP服务器
      lua-language-server
      pyright
      rust-analyzer
      clangd
      gopls
      tsserver
      bash-language-server
      marksman
      nil
      terraform-ls
      yaml-language-server
      dockerfile-language-server
      jsonls
      html-lsp
      css-lsp
      tailwindcss-language-server

      # 格式化工具
      nixfmt
      stylua
      black
      isort
      rustfmt
      clang-format
      gofumpt
      prettier
      shfmt
      terraform
     alejandra

      # 调试工具
      delve
      lldb

      # 其他工具
      fzf
      ripgrep
      fd
      tree-sitter
      git
      xclip
      wl-clipboard
    ];

    # LazyVim配置
    extraConfig = ''
      " LazyVim配置文件
      lua << EOF
      -- Lazy.nvim配置
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

      -- Catppuccin主题设置
      vim.g.catppuccin_flavour = "mocha"

      -- LazyVim设置
      require("lazy").setup({
        -- LazyVim核心
        "LazyVim/LazyVim",

        -- 颜色主题
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

        -- UI增强
        { "nvim-lualine/lualine.nvim" },
        { "nvim-tree/nvim-tree.lua" },
        { "akinsho/bufferline.nvim" },
        { "kyazdani42/nvim-web-devicons" },

        -- 编辑器增强
        { "tpope/vim-sleuth" },
        { "tpope/vim-surround" },
        { "numToStr/Comment.nvim" },
        { "windwp/nvim-autopairs" },
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "L3MON4D3/LuaSnip" },
        { "saadparwaiz1/cmp_luasnip" },

        -- LSP配置
        {
          "neovim/nvim-lspconfig",
          dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
          },
        },

        -- 文件浏览器
        {
          "nvim-telescope/telescope.nvim",
          dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
          },
        },

        -- Git集成
        { "lewis6991/gitsigns.nvim" },
        { "tpope/vim-fugitive" },
        { "tpope/vim-rhubarb" },

        -- 终端
        { "akinsho/toggleterm.nvim" },

        -- 语法高亮
        { "nvim-treesitter/nvim-treesitter" },

        -- 启动屏幕
        { "goolord/alpha-nvim" },

        -- 自动会话管理
        { "rmagatti/auto-session" },

        -- 缩进指示
        { "lukas-reineke/indent-blankline.nvim" },

        -- 滚动条
        { "petertriho/nvim-scrollbar" },

        -- 光标高亮
        { "RRethy/vim-illuminate" },

        -- 自动保存
        { "pocco81/auto-save.nvim" },

        -- 错误列表
        { "folke/trouble.nvim" },

        -- 无模式编辑
        { "ggandor/leap.nvim" },

        -- 快捷键提示
        { "folke/which-key.nvim" },
      }, {
        defaults = {
          -- LazyVim默认设置
          lazy = true,
          version = nil,
        },
        install = {
          colorscheme = { "catppuccin", "habamax" },
        },
        checker = {
          enabled = true,
          notify = false,
        },
        change_detection = {
          notify = true,
        },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip",
              "matchit",
              "matchparen",
              "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })

      -- Catppuccin主题配置
      require("catppuccin").setup({
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        highlight_overrides = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = false,
          telescope = true,
          which_key = true,
        },
      })

      -- 设置颜色主题
      vim.cmd.colorscheme("catppuccin")

      -- 基础设置
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.wrap = false
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.smartindent = true
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
      vim.opt.undofile = true
      vim.opt.hlsearch = false
      vim.opt.incsearch = true
      vim.opt.termguicolors = true
      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.isfname:append("@-@")
      vim.opt.updatetime = 50
      vim.opt.colorcolumn = "80"

      -- 快捷键设置
      vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
      vim.g.mapleader = " "

      -- 窗口导航
      vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

      -- 调整窗口大小
      vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { silent = true })
      vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { silent = true })
      vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
      vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

      -- 导航
      vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { silent = true })
      vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { silent = true })

      -- 自动保存设置
      vim.g.auto_save = 1

      -- 诊断设置
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP快捷键
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
      })
      EOF
    '';
  };

  # LazyVim配置文件目录
  home.file.".config/nvim/lua/config" = {
    source = ./lazyvim;
    recursive = true;
  };
}