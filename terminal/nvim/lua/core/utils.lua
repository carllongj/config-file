-- 定义全局工具函数对象,以便于其它模块引用
local M = {}

-- 该函数用以简化创建 opt 的设置.
M.make_opt = function(desc,noremap,silent)
  -- noremap 用以禁止递归映射,silent 用以禁止映射执行时显示执行命令
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

return M;
