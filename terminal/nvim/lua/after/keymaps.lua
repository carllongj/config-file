-- 用以定义加载 lazy 插件之后加载的配置文件.以下为定义插件相关快捷键.
local keymap = vim.keymap
local utils = require('core.utils')
local make_opt = utils.make_opt

-- plugins start config
-- 设置普通模式下的 nvim-tree 的开关
keymap.set('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', make_opt('目录树切换'))

-- 使用 vim 默认的快捷键进行窗口切换,<c-w> + 上下左右/hjkl 进行切换.
-- 使用 ctrl+shift+H 切换到左窗口
-- keymap.set('n', '<S-H>', '<Cmd>BufferLineCyclePrev<CR>', make_opt('切换到左边的窗口'))
-- 使用 ctrl+shift+L 切换到右窗口
-- keymap.set('n', '<S-L>', '<Cmd>BufferLineCycleNext<CR>', make_opt('切换到右边的窗口'))


-- 文件检索功能,用以全局设置.
local builtin = require('telescope.builtin')
-- 检索文件名称包含的字符,类似于 find
keymap.set('n', '<leader>ff', builtin.find_files, make_opt('file name search'))
-- 检索文件内容包含的字符,类似于 grep
keymap.set('n', '<leader>fg', builtin.live_grep, make_opt('file content search'))
-- 检索打开的缓冲区,即编辑的页面窗口
keymap.set('n', '<leader>fb', builtin.buffers, make_opt('buffer search'))
-- 打开帮助文档.
keymap.set('n', '<leader>fh', builtin.help_tags, make_opt('document search'))

-- undo 变更历史库的快捷键
keymap.set('n', '<leader>ud', '<Cmd>UndotreeToggle<CR>', make_opt('打开undo历史展示树'))

-- 设置显示所有报错信息的窗口,以便快速跳转到报错的位置
keymap.set('n', '<leader>q', function ()
  -- 通过 vim 调用函数
  vim.diagnostic.setqflist()
end, make_opt('显示错误信息'))




-- LSP 快捷键全局设置,针对所有语言服务器生效.
-- 跳转到符号定义的位置.
keymap.set('n', 'gd', builtin.lsp_definitions, make_opt('Go to Definition'))
-- 打开引用窗口,检查所有被引用的位置.
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



--- dap 快捷键配置,以 Jetbrains 快捷键调试配置.
local dap = require('dap')
-- 设置继续运行直到下一个断点.在未启用调试时,它会准备拉起调试.
keymap.set('n', '<F9>', function() dap.continue() end)
-- 跳过当前执行.
keymap.set('n', '<F8>', function() dap.step_over() end)
-- 进入当前执行.
keymap.set('n', '<F7>', function() dap.step_into() end)
-- 跳出当前函数栈帧
keymap.set('n', '<S-F8>', function() dap.step_out() end)

-- 设置获取取消断点.
keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)

-- dapui 界面启用或者关闭
keymap.set('n', '<leader>du', function() require('dapui').toggle() end)

-- 悬停查看变量值(类似于 VS Code 鼠标悬停)
keymap.set('n', 'K', function()
  require("dapui").eval()
end, { buffer = true })

-- 实时监控表达式 (Watches)
keymap.set('n', '<leader>dw', function()
  local expr = vim.fn.input('Watch expression: ')
  require("dapui").elements.watches.add(expr)
end, { buffer = true })

-- 配置翻译快捷键,它用以翻译文本块的内容,因此它必须要确保内容已经被选中.
-- 在可视块模式下才生效的快捷键.
keymap.set('v', 'ts', ":'<,'>Translate zh<CR>",make_opt('translate selected text to chinese'))
-- 翻译单个单词的快捷键配置
keymap.set('n', 'ts', 'viw:Translate zh<CR>',make_opt('translate word to chinese'))
