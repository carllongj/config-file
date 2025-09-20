
-- 用一设置 bash 脚本的 language server.
-- 它需要安装 node, 以及 shellcheck 命令.
--[[
    1. 安装 node ,通过 fnm 进行安装.
      curl -fsSL https://fnm.vercel.app/install | bash
    2. 通过 fnm 安装 nodejs
      fnm install v22.16.0
    3. 通过 Mason 进行安装 bash-languager-server 即可
]]

require('lspconfig').bashls.setup({
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh" },
  root_dir = require('lspconfig.util').find_git_ancestor,
  settings = {
    bashIde = {
      shellcheckPath = "shellcheck", -- 确保可执行
      enableSourceErrorDiagnostics = true
    }
  }
})

