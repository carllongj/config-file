-- 获取缓冲区级别的配置项
-- 它与 opt 的区别是只影响打开的缓冲区,而不会影响全局缓冲区.
-- 可以保证其它语言使用全局的 opt 不受到影响.
local opt = vim.opt_local

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

