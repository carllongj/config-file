-- Mason 中需要安装 clangd

--[[
  要 clangd 能正常使用的话,就需要在项目的根目录下存在以下文件.
  1. compile_flags.txt,它用以存储当前的编译选项,这样它才能识别,一般用于小的项目,
     不需要使用 Makefile 或者 CMake项目,以下是一个简单的文件.
     ```txt
     -I ./
     -I ./include
     -std=c11
     -Wall
     ```
  2. compile_commands.json,存储当前项目的编译配置,一般由 cmake 或者 其它生成
    1. cmake 使用 cmake -DCAMKE_EXPORT_COMPILE_COMMANDS=ON 生成.
    2. make 项目使用 bear 命令来生成.
]]--

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    -- 判断是否已经安装了 clangd
    if vim.fn.executable('clangd') == 0 then
      return
    end

    local lspconfig = require("lspconfig")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()


    if not lspconfig.util.get_active_client_by_name(0, "clangd") then
      lspconfig.clangd.setup({
        -- 你可以在这里自定义 clangd 启动参数
        cmd = { "clangd" },
        capabilities = capabilities,
      })

      vim.defer_fn(function()
        vim.cmd("LspStart clangd")
      end, 100)
    end
  end
})
