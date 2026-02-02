-- 设置前缀键为空格键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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