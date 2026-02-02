-- python 的 lsp 与 dap 配置.

--[[
  Mason 中需要安装 basedpyright 以及 ruff de LSP 服务
]]--

-- 获取当前 buffer 的根目录（寻找项目标志文件）
local root_files = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }
local root_dir = vim.fs.root(0, root_files)

-- 启动 Basedpyright
vim.lsp.start({
  name = 'basedpyright',
  cmd = { 'basedpyright-langserver', '--stdio' },
  root_dir = root_dir,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
})

-- 启动 Ruff (由于 Neovim 支持同时运行多个 LSP，直接再调一次 start)
vim.lsp.start({
  name = 'ruff',
  cmd = { 'ruff', 'server' },
  root_dir = root_dir,
})

-- python dap 通过插件配置
