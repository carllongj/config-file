-- 启用指定的主题
vim.cmd[[colorscheme tokyonight-moon]]

-- 启用底部状态栏信息
require('lualine').setup({
  options = {
    theme = 'tokyonight',
  },
  --[[
      sections 用以配置 statuslines 的组件,支持6个显示
      左侧三个组件: lualine_a,lualine_b,lualine_c
      右侧三个组件: lualine_x,lualine_y,lualine_z
      每一个组件都可以显示多个.
    ]]--
  sections = {
    -- lualine_c 用双层表是因为需要对组件进行个性化配置时,就
    -- 必须要使用双层表.
    lualine_c = {
      {
        'filename', -- 第三个组件显示为文件名称
        path = 1 , -- 配置显示方式,0: 仅文件名 1: 打开工作路径的相对路径 2: 绝对路径.
      }
    },
  },
})

-- nvim-tree 插件配置
-- 默认不开启 nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  update_focused_file = {
    enable = true,     -- 自动更新 tree 中高亮的文件
    update_root = false, -- 是否改变 root，可按需改成 true
  },
})


-- 语法高亮设置 treesitter 配置,此部分的配置的内容也是会从github上下
-- 载,因此可能出现下载失败的文件,可以使用设置环境变量来启动 nvim
--
-- http_proxy=http://<ip>:<port> nvim
require('nvim-treesitter.configs').setup({
  -- 部分下不下来可以使用 :TSInstall <language> 来下载
  ensure_installed = {
    'vim',
    'java',
    'c',
    'python',
    'cpp',
    'json',
    'lua',
  },

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
  }
})

-- LSP 插件配置
require('mason').setup({
  ui = {
    icons = {
      -- 设置 mason 管理的符号显示
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗'
    }
  }
})

--[[
  mason-lspconfig 会自动的初始化已安装的全部 LSP.
]]
require('mason-lspconfig').setup({
  -- 不能下载的使用 :MasonInstall <package> 来下载
  -- 每一个服务都需要在下面配置启动
  ensure_installed = {
    'lua_ls',
    -- e.g ,java language server
    -- 若不需要 jdtls,注释掉即可.
    -- 'jdtls',
    -- 适配 jdtls 的调试器与单元测试器,若不使用 jdtls,以下两个可以一并注释掉.
    -- 'java-test',
    -- 'java-debug-adapter',
    -- 用以支持python,它使用 node 实现.
    -- 'pyright',
    -- "clangd",
    -- "kotlin-language-server",
    -- nginx 语法 lsp.
    -- 'nginx-language-server',
  }
})

-- add lsp startup here,e.g
-- lspconfig["jdtls"].setup({})
-- 该名称并不一定是插件的名称,看 :Mason 命令提示的名称
-- kotlin-languager-server 它的 lsp 名称是 kotlin_language_server

--  cmp 配置信息
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip.loaders.from_vscode").lazy_load()

-- 下面会用到这个函数
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end


cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),  -- 取消补全，esc也可以退出
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  }),

  sources = cmp.config.sources({
    -- 使用 lsp 服务的代码补全
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    -- 文件路径补全
    { name = 'path' },
  }, {
    { name = 'buffer' },
  })
})

-- 注释配置
require("Comment").setup()
local npairs_ok, npairs = pcall(require, "nvim-autopairs")
if not npairs_ok then
  return
end

npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
  },
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey='Comment'
  },
}

-- 配置这个使得自动补全会把括号带上

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

-- 缓冲区配置
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    offsets = {{
      filetype = "NvimTree",
      text = "File Explorer",
      highlight = "Directory",
      text_align = "left"
    }}
  }
})

-- git文件改动提示
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  }
})


-- 配置 telescope 的显示模式
require('telescope').setup({
  defaults = {
    -- 设置目录显示为智能模式
    path_display = { 'smart' },
    -- 设置忽略的目录,即不对这些目录做文件检索
    file_ignore_patterns = {
      'target/', -- 忽略 maven 项目使用的 target 目录
      '%.git/', -- 忽略 .git/ 目录
      'build/', -- 忽略 cmake 使用的构建目录.
      'venv/', -- 忽略 python 的虚拟环境目录
    }
  }
})

-- 配置 translate 翻译插件,默认使用了 translate-shell
-- 因此机器上必须要安装,安装命令如下.
--[[
   ubuntu 安装
   sudo apt install translate-shell

   arch 安装
   sudo pacman -S translate-shell
]]
require('translate').setup({
    default = {
		command = "translate_shell",
	},
	preset = {
		command = {
			translate_shell = {
				args = { "-e", "bing" }
			}
		}
	}
})
