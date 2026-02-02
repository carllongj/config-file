-- 在初始化时会加载 lazy 以管理所有的插件,因此需要保证该仓库可以正确的 clone 到本地,
-- 可以通过 git config --global http.https://github.com/.proxy http://<host>:<port>设置一个全局代理
-- 以保证可以正确的克隆
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 通过模块来加载配置文件.
require("lazy").setup({
  spec = {
    {
      -- 导入 lua/plugins 目录下的所有 lua 模块.
      import = "plugins",
    },
  },
  -- 检测配置文件变化并且自动重载
  change_detection = { notify = false },
})
