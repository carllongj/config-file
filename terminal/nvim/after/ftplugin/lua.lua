local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- 修改为 neovim 新版本的lsp配置.
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        -- 用以解决 vim 全局变量警告
        globals = { 'vim' },
      },
    },
  },
})

-- lua_ls 没有定义制表符与空格的格式,因此不复用默认的.
local opt = vim.opt

-- 设置转换制表符为空白符.并且为2个空格长度.
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- lua dap 配置,需要安装 local-lua-debugger-vscode dap服务.
local dap = require('dap')

-- 获取 Mason 安装目录下的脚本路径
local debugger_dir = vim.fn.expand("$HOME") .. "/.local/share/nvim/mason/packages/local-lua-debugger-vscode/extension/debugger"

-- 1. 配置适配器
dap.adapters.lua = {
  type = 'executable',
  command = 'node', -- 这是一个 node 编写的适配器
  args = {
    vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/extension/extension/debugAdapter.js"
  },
}

-- 2. 配置详情
dap.configurations.lua = {
  {
    name = "Current File (local-lua-debugger)",
    type = "lua",
    request = "launch",
    cwd = "${workspaceFolder}",
    program = {
      lua = "lua", -- 或者你想用的 lua 版本
      file = "${file}",
    },
    env = function()
      -- 构造 LUA_PATH，确保包含 debugger 文件夹
      local debugger_path = debugger_dir .. "/?.lua"
      local current_path = vim.env.LUA_PATH or ""

      return {
        -- 执行命令时倒入 lldebuger 的lua配置文件.
        LUA_PATH = debugger_path .. ";" .. current_path .. ";./?.lua"
      }
    end,
  },
}