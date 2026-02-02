-- 用以配置 lsp 插件,包含
--[[
  LSP 服务管理插件
  neovim 与服务关联插件
]]--

return {
  {
    -- 配置 lsp 语言的下载管理插件.
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          -- 设置 mason 管理的符号显示
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
          },
          border = "rounded" },
      })
    end,
  },

  {
    -- 将 mason 下载服务与 nvim-lspconfig 关联
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function ()
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
        },
        --[[
          该名称并不一定是插件的名称,看 :Mason 命令提示的名称
          kotlin-languager-server 它的 lsp 名称是 kotlin_language_server

          lsp 针对语言的配置放在了 after/<filetype>的目录下以便于模块化配置.
        ]]--
        -- handlers = {}
      })
    end
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
}