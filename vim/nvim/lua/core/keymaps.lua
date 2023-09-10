-- 设置主键
vim.g.mapleader = " "

local keymap = vim.keymap

-- -------------- 插入模式 --------- --
-- keymap.set("i", "jk", "<ESC>")

-- -------------- 普通模式 --------- --
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")

-- -------------- 取消高亮 --------- --
keymap.set("n", "<leader>nh", ":nohl<CR>")


-- plugins start config 
-- 设置普通模式下的 nvim-tree 的开关
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- 使用 ctrl+shift+H 切换到左窗口
keymap.set("n", "<S-H>", ":BufferLineCyclePrev<CR>")
-- 使用 ctrl+shift+L 切换到右窗口
keymap.set("n", "<S-L>", ":BufferLineCycleNext<CR>")


-- 文件检索功能
local builtin = require("telescope.builtin")
-- 检索文件名称包含的字符
keymap.set("n", "<leader>ff", builtin.find_files, {})
-- 检索文件内容包含的字符
keymap.set("n", "<leader>fg", builtin.live_grep, {})
keymap.set("n", "<leader>fb", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})

