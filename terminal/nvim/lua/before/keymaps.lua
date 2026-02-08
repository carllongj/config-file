-- 设置前缀键为空格键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local utils = require('core.utils')
local make_opt = utils.make_opt

-- 查看所有的配置的快捷键通过 :map 进行查看

local keymap = vim.keymap

-- 通过 :h vim.keymap.set 查看帮助信息
-- 在插入模式下,快速的敲击 jk 两个字符会被映射为 ESC 按键
-- keymap.set('i', 'jk', '<ESC>')
-- keymap.set({'i','n'}, 'jk', '<ESC>') # 多个模式的配置
-- -------------- 插入模式快捷键的匹配 --------- --
-- keymap.set({'i','n'}, 'jk', '<ESC>') # 多个模式的配置
keymap.set('i', 'sss', '<Cmd>w<CR>', make_opt('write to disk'))

-- <Cmd> 等价于切换到尾行模式,因此会执行对应的命令,它是neovim的
-- 特性.若是 vim 则使用冒号的方式来定义,它性能更好,语法更加安全.
-- 例如
-- keymap.set('n', '<leader>nh', ':nohl<CR>')
-- keymap.set('n', '<leader>nh', '<cmd>nohl<CR>')

-- -------------- 普通模式 --------- --
-- 设置垂直分屏显示
keymap.set('n', '<leader>sv', '<C-w>v', make_opt('设置垂直分屏显示'))
-- 设置水平分屏显示
keymap.set('n', '<leader>sh', '<C-w>s', make_opt('设置水平分屏显示'))

-- ---------普通模式下 取消高亮 --------- --
keymap.set('n', '<leader>nh', '<Cmd>nohl<CR>', make_opt('取消高亮'))

----------- buffer 相关的快捷键 ----------------
-- Alt+h, Alt+l 设置为前后 buffer 的快速切换.
keymap.set('n', '<A-h>', '<Cmd>bp<CR>', make_opt('切换到上一个buffer'))
keymap.set('n', '<A-l>', '<Cmd>bn<CR>', make_opt('切换到下一个buffer'))

-- 设置alt+数字跳转到指定的 buffer 窗口,buffer 窗口打开时可能不按照
-- 顺序,因此以下的快捷键可能会无效.
--[[ for i = 1,9 do
--   keymap.set('n', ('<A-%s>'):format(i),
--     ('<Cmd>b %s<CR>'):format(i), make_opt('跳转到指定的buffer窗口'))
-- end
]]--

-- 设置 alt+w 关闭当前的buffer窗口.
keymap.set('n','<A-w>', '<Cmd>bd<CR>', make_opt('关闭当前的buffer窗口'))
