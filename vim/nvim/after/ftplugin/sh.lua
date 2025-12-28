
-- 用一设置 bash 脚本的 language server.
-- 它需要安装 node, 以及 shellcheck 命令.
--[[
    1. 安装 node ,通过 fnm 进行安装.
      curl -fsSL https://fnm.vercel.app/install | bash
    2. 通过 fnm 安装 nodejs
      fnm install v22.16.0
    3. 通过 Mason 进行安装 bash-languager-server 即可
]]

local util = require("lspconfig.util")
-- 使用新版 API 配置
vim.lsp.start({
  name = "bashls",
  cmd = { "bash-language-server", "start" },
  root_dir = util.find_git_ancestor(vim.api.nvim_buf_get_name(0)),
  settings = {
    bashIde = {
      shellcheckPath = "shellcheck",
      enableSourceErrorDiagnostics = true,
    },
  },
})

