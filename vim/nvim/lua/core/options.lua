local opt = vim.opt

-- 行号设置
opt.relativenumber = true
opt.number = true

-- 缩进设置
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- opt.wrap = true

-- 光标设置,开启光标所以行下划线
-- opt.cursorline = false

-- 开启系统剪贴版
opt.clipboard:append("unnamedplus")

-- 默认新窗口右边和下边
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"

