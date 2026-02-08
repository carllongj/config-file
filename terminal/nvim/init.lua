-- lua 会自动将 . 拆分为目录结构进行加载

-- 优先加载工具库,该工具库封装一些通用工具.
-- Lua 在加载后模块后将其保存到加载列表中以便于后续模块使用.
require("core.utils")

require("core.before")
require("core.lazy")
require("core.after")
