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


-- 文件检索功能
local builtin = require("telescope.builtin")
-- 检索文件名称包含的字符
keymap.set("n", "<leader>ff", builtin.find_files, make_opt("打开文件检索窗口"))
-- 检索文件内容包含的字符
keymap.set("n", "<leader>fg", builtin.live_grep, {})
keymap.set("n", "<leader>fb", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})

