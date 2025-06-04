-- 设置前缀键为空格键
vim.g.mapleader = " "

-- 查看所有的配置的快捷键通过 :map 进行查看

local keymap = vim.keymap
-- noremap 用以禁止递归映射,silent 用以禁止映射执行时显示执行命令
local opt = {noremap = true,silent = true}

local make_opt = function(desc,noremap,silent)
  if noremap == nil then
    noremap = true
  end

  if silent == nil then
    silent = true
  end

  return {
    noremap = noremap,
    silent = silent,
    -- desc 用以在 map 命令查看快捷键时显示说明
    desc = desc,
  }
end

-- 通过 :h vim.keymap.set 查看帮助信息
-- -------------- 插入模式 --------- --
-- 在插入模式下,快速的敲击 jk 两个字符会被映射为 ESC 按键
-- keymap.set("i", "jk", "<ESC>")
-- keymap.set({'i','n'}, "jk", "<ESC>") # 多个模式的配置

-- -------------- 普通模式 --------- --
-- 设置垂直分屏显示
keymap.set("n", "<leader>sv", "<C-w>v", make_opt('设置垂直分屏显示'))
-- 设置水平分屏显示
keymap.set("n", "<leader>sh", "<C-w>s", make_opt('设置水平分屏显示'))

-- ---------普通模式下 取消高亮 --------- --
keymap.set("n", "<leader>nh", ":nohl<CR>", make_opt('取消高亮'))


-- plugins start config
-- 设置普通模式下的 nvim-tree 的开关
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", make_opt('目录树切换'))

-- 使用 ctrl+shift+H 切换到左窗口
keymap.set("n", "<S-H>", ":BufferLineCyclePrev<CR>", make_opt('切换到左边的窗口'))
-- 使用 ctrl+shift+L 切换到右窗口
keymap.set("n", "<S-L>", ":BufferLineCycleNext<CR>", make_opt('切换到右边的窗口'))


-- 文件检索功能,用以全局设置.
local builtin = require("telescope.builtin")
-- 检索文件名称包含的字符,类似于 find
keymap.set("n", "<leader>ff", builtin.find_files, make_opt("打开文件检索窗口"))
-- 检索文件内容包含的字符,类似于 grep
keymap.set("n", "<leader>fg", builtin.live_grep, {})
-- 检索打开的缓冲区,即编辑的页面窗口
keymap.set("n", "<leader>fb", builtin.buffers, {})
-- 打开帮助文档.
keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- undo 变更历史库的快捷键
keymap.set("n", "<leader>ud", ":UndotreeToggle<CR>", make_opt('打开undo历史展示树'))

-- 设置显示所有报错信息的窗口,以便快速跳转到报错的位置
keymap.set("n", "<leader>q", function ()
  -- 通过 vim 调用函数
  vim.diagnostic.setqflist()
end, make_opt('显示错误信息'))

-- LSP 快捷键全局设置
-- 跳转到定义的位置.
keymap.set('n', 'gd', builtin.lsp_definitions, make_opt('Go to Definition'))
-- 打开引用窗口
keymap.set('n', 'gr', builtin.lsp_references, make_opt('Find References'))
-- 查找所有的实现
keymap.set('n', 'gi', builtin.lsp_implementations, make_opt('Find Implementations'))
-- 跳转到类型定义,强类型语言则是直接跳转到对应的符号定义.
keymap.set('n', 'gy', builtin.lsp_type_definitions, make_opt('Go to Type Definition'))
-- 文档符号,用以列出当前文件的所有符号,类似于 structure
keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, make_opt('Document Symbols'))
-- 工作区符号,列出整个工作区的符号.
keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, make_opt('Workspace Symbols'))
-- 代码操作快捷键
keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, make_opt('Code Action'))
-- 格式化代码
keymap.set('n', '<C-A-l>', function() vim.lsp.buf.format { async = true} end, make_opt('Code Action'))
-- 查看对应符号的文档,默认已经是这个快捷键配置
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, make_opt('Document'))

-- 查看函数签名
keymap.set('n','<C-k>', vim.lsp.buf.signature_help, make_opt('function signature help'))

-- 诊断相关的快捷键,LSP检查的错误信息,弹出错误的信息
keymap.set('n', '<leader>df', vim.diagnostic.open_float, make_opt('current diagnostic'))
-- 上一个错误信息
keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, make_opt('previous diagnostic'))
-- 下一个错误信息
keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, make_opt('next diagnostic'))
-- 诊断列表
keymap.set('n', '<leader>da', vim.diagnostic.setloclist, make_opt('diagnostic list'))
