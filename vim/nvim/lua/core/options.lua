local opt = vim.opt

-- 行号设置
opt.relativenumber = true
opt.number = true

-- 设置 tab 在编辑器显示的宽度.
opt.tabstop = 4
-- 设置使用控制自动缩进或者命令缩进时(>>/<<)的移动宽度
opt.shiftwidth = 4

-- 插入 tab 时,是否以空格替换.
opt.expandtab = false
-- 是否继承上一行的缩进,即遇到层级变化时会自动缩进
-- 没有层级变化时保持一致.
opt.autoindent = true

-- 不可见字符显示设置.
opt.list = true

-- 设置显示隐藏字符对应的文本
opt.listchars = {
    tab = "»·",     -- Tab 显示成 » 加点（点的数量由 tabstop 决定）
    space = "·",    -- 空格显示为 ·
    trail = "·",    -- 行尾多余空格显示为 ·
    eol = "↴"       -- 行尾显示换行符
}

-- opt.wrap = true

-- 光标设置,开启光标索引行下划线
-- opt.cursorline = false

-- 启用系统剪贴版,neovim 的默认行为是通过命令
-- 复制如(dd)时是按照默认的行为来写入寄存器,以下
-- 命令则是用以在默认的行为添加一个 unnamedplus,即复制
-- 粘贴时,同时操作系统剪切板,这段代码会使得每一次的复制
-- 都会去操作系统剪切板,会在剪切板上生成许多无用的内容,
-- 因此可以不必使用该项,只要系统中存在可用的 provider,neovim
-- 就可以通过 + 寄存器获取到系统剪切板的内容,也可以手动通过
-- + 寄存器来复制内容到系统剪切板,增加此配置项只是可以省略掉
-- 手动指定+寄存器而已.
--
-- unnamedplus 在 Linux 下对应
-- 的是 + 寄存器,是系统的剪切板,可以通过
-- ctrl+c以及ctrl+v进行复制粘贴.
--opt.clipboard:append("unnamedplus")

-- 自定义粘贴函数,避免去调用 osc52 读取本地剪切板
-- 若是在终端使用nvim,并且版本高于0.10,启用osc远程拷贝.
if os.getenv('SSH_TTY')
then
  local function Custom_paste(reg)
    return function(line)
      local content = vim.fn.getreg('"')
      return vim.split(content, '\n')
    end
  end

  -- 设置剪切板的逻辑调用
  vim.g.clipboard = {
    name = "OSC-52",
    copy = {
      -- 设置 剪切板寄存器的复制逻辑,通过 osc52 复制内容
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      -- 设置 剪切板寄存器的粘贴逻辑,大部分终端因为安全原因
      -- 禁止读取终端所在操作系统的剪切板,因此通过osc52读取
      -- 剪切板会失败,因此通过自定义的方式获取默认寄存器内容
      ['+'] = Custom_paste('+'),
      ['*'] = Custom_paste('*'),
    }
  }
end

-- 默认新窗口在右侧和下方
opt.splitright = true
opt.splitbelow = true

-- 搜索忽略大小写
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"

