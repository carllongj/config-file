-- 此部分用以定义语法高亮以及彩虹括号等.

return {
  {
    "nvim-treesitter/nvim-treesitter", -- 语法高亮
    build = ":TSUpdate", -- 每次插件时自动更新所有的语法解析器.
    config = function()
      -- 语法高亮设置 treesitter 配置,此部分的配置的内容也是会从github上下
      -- 载,因此可能出现下载失败的文件,可以使用设置环境变量来启动 nvim
      -- http_proxy=http://<ip>:<port> nvim

      local ts = require('nvim-treesitter.configs')
      ts.setup({
        -- 设置默认下载的解析器,部分下不下来可以
        -- 使用 :TSInstall <language> 来下载
        ensure_installed = {
          'vim',
          'java',
          'c',
          'python',
          'cpp',
          'json',
          'lua',
        },
        auto_install = true,

        -- 启用语法高亮显示
        highlight = { enable = true },
        -- 启用自动缩进
        indent = { enable = true },
        -- 启用折叠
        fold = { enable = true },

        -- 不同括号颜色区分
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil
        },

        -- 增量选择(用以进行代码片段的选择)
        --[[
          它用于根据代码结构进行范围自动扩展选择,而不需要
          手动来进行选择.
        ]]--
        incremental_selection = {
          enable = true,
          keymaps = {
            -- 首次进行选择时,指定为回车键
            init_selection = "<CR>",
            -- 节点扩大时使用回车选
            node_incremental = "<CR>",
            -- 范围扩大时使用tab扩大
            scope_incremental = "<TAB>",
            -- 缩小范围选择
            node_decremental = "<BS>",
          }
        },
      })
    end,
  },

  {
    -- 彩虹括号插件配置项.
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
}