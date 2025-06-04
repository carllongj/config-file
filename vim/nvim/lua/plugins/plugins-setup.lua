-- 在初始化时会加载 lazy 以管理所有的插件,因此需要保证该仓库可以正确的 clone 到本地,
-- 可以通过 git config --global http.https://github.com/.proxy http://<host>:<port>设置一个全局代理
-- 以保证可以正确的克隆
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


local plugins = {
  "folke/tokyonight.nvim", -- 主题
  "nvim-lualine/lualine.nvim",  -- 状态栏
  "nvim-tree/nvim-tree.lua",  -- 文档树
  "nvim-tree/nvim-web-devicons", -- 文档树图标

  "christoomey/vim-tmux-navigator", -- 用ctl-hjkl来定位窗口
  "nvim-treesitter/nvim-treesitter", -- 语法高亮
  -- 此插件已经不兼容 neovim 0.11版本了,在打开语法树高亮时会报错
  --"p00f/nvim-ts-rainbow", -- 配合treesitter，不同括号颜色区分
  -- 将使用如下配置来使用彩虹括号
    {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          lua = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        }
      }
    end
  },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim", -- 这个相当于mason.nvim和lspconfig的桥梁
    "neovim/nvim-lspconfig"
  },

      -- 自动补全
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip", -- snippets引擎，不装这个自动补全会出问题
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "hrsh7th/cmp-path", -- 文件路径

  "numToStr/Comment.nvim", -- gcc和gc注释
  "windwp/nvim-autopairs", -- 自动补全括号

  "akinsho/bufferline.nvim", -- buffer分割线
  "lewis6991/gitsigns.nvim", -- 左则git提示

  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8', -- 文件检索,使用新版官网的配置
    dependencies = {'nvim-lua/plenary.nvim'}
  },
  {
    'mbbill/undotree', -- 安装 undo 的图形树显示
  },
  {
    -- 用以加载 jdtls 的插件,它是客户端插件,需要 mason 来安装
    -- jdtls 的 lsp 服务端.
    'mfussenegger/nvim-jdtls',
    ft = "java", -- java 文件时才使用.
    dependencies = {
       'williamboman/mason.nvim', -- 依赖 mason
    }
  },
  "mfussenegger/nvim-dap" -- 用以支持调试
}
local opts = {} -- 注意要定义这个变量

require("lazy").setup(plugins, opts)
