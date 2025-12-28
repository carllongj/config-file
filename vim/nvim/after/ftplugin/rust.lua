function on_attach(client, bufnr) 
   local map_key = function(mode, lhs, rhs)
     vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
   end

   -- 格式化快捷键
   map_key("n", "<C-A>l", function()
     vim.lsp.buf.format({ async = true })
   end)
end

vim.lsp.start({
  name = "rust-analyzer",
  cmd = { "rust-analyzer" },
  root_dir = vim.fs.root(0, { "Cargo.toml" }),
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      check = { command = 'clippy' },
      cargo = { allFeatures = true },
      procMacro = { enable = true },
    },
  },
})

