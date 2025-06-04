local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        -- 用以解决 vim 全局变量警告
        globals = { 'vim' },
      }
    }
  }
})