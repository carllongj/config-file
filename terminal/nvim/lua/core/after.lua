local after = vim.fn.stdpath("config") .. "/lua/after"
local files = vim.fn.globpath(after, "*.lua" , false, true)

for _,file in ipairs(files) do
  -- 获取文件名并转换为 require 格式
    local module_name = file:match("([^/]+)%.lua$")
    require("after." .. module_name)
end