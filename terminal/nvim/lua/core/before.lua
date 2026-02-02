

local before = vim.fn.stdpath("config") .. "/lua/before"
local files = vim.fn.globpath(before, "*.lua" , false, true)

for _,file in ipairs(files) do
    -- 获取文件名并转换为 require 格式
    local module_name = file:match("([^/]+)%.lua$")
    require("before." .. module_name)
end