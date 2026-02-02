function on_attach(client, bufnr)
   local map_key = function(mode, lhs, rhs)
     vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
   end

   -- 格式化快捷键
   map_key("n", "<C-A>l", function()
     vim.lsp.buf.format({ async = true })
   end)
end

-- rust 的 lsp 配置
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

-- rust 的 dap 配置.
local dap = require('dap')

-- 1. 配置适配器 (Adapter)
local mason_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = mason_path,
    args = { "--port", "${port}" },
  },
}

-- 2. 配置调试详情 (Configurations)
dap.configurations.rust = {
  {
    name = "Rust Debug: Launch",
    type = "codelldb",
    request = "launch",
    -- 智能查找二进制文件
    program = function()
      local metadata = vim.fn.system("cargo metadata --format-version 1")
      if vim.v.shell_error ~= 0 then
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
      end

      -- 尝试从 cargo metadata 自动获取包名
      local decoded = vim.fn.json_decode(metadata)
      if decoded and decoded.target_directory then
        local target_dir = decoded.target_directory .. '/debug/'
        local package_name = decoded.packages[1].name
        -- 优先猜测这个路径
        local guess = target_dir .. package_name
        if vim.fn.executable(guess) == 1 then
          return guess
        end
      end
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    -- 配合 Tokyo Night 的控制台
    initCommands = function()
      return { "settings set target.disable-aslr false" }
    end,
  },
}
