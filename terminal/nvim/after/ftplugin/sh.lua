
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


-- 配置 sh 脚本对应的 dap 配置.
local dap = require('dap')

-- 1. 定义适配器 (告诉 Neovim 如何启动调试器进程)
dap.adapters.sh = {
  type = 'executable',
  command = 'node',
  args = {
    -- 指向 Mason 安装的路径
    vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/out/bashDebug.js"
  }
}

-- 2. 定义配置 (告诉调试器如何运行你的脚本)
dap.configurations.sh = {
  {
    name = "Launch Bash Script",
    type = "sh",
    request = "launch",
    program = "${file}",
    cwd = "${workspaceFolder}",
    -- bash 可执行文件路径
    pathBash = "bash",
    -- 指定调试器传递命令
    pathMkfifo = "mkfifo",
    -- 指定杀死进程的命令
    pathPkill = "pkill",
    pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
    pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
    pathCat = "cat",
    env = {},
    -- 指定脚本使用的参数
    args = {},
  }
}