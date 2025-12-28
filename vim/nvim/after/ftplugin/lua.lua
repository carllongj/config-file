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

