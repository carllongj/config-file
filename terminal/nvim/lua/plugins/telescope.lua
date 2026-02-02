-- 模糊查找的配置项.

return {
  "nvim-telescope/telescope.nvim",
  -- 文件检索,使用新版官网的配置
  version = "*",

  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- 性能增强插件,加速查找.
      "nvim-telescope/telescope-fzf-native.nvim", build = "make"
    },
    "nvim-tree/nvim-web-devicons",
  },
  --[[
    在 keys 字段中定义快捷键,统一放在了 lua/config/after.lua 配置中.
  ]]--
  -- keys = {}
  config = function ()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        path_display = "smart",
        mappings = {
          i = {
            -- 在 telescope 界面下插入模式的快捷键.
            -- 使用快捷键移动到前一个条目,而不需要使用↑键
            ["<C-j>"] = require("telescope.actions").move_selection_previous,
            -- 使用快捷键移动到下一个条目,而不需要使用↓键
            ["<C-k>"] = require("telescope.actions").move_selection_next,
            -- 将选中的变量一并添加到 quickfix 列表窗口并且打开该窗口.
            ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
          }
        },
        -- 设置忽略的目录,即不对这些目录做文件检索
        file_ignore_patterns = {
          "target/", -- 忽略 maven 项目使用的 target 目录
          "%.git/", -- 忽略 .git/ 目录
          "build/", -- 忽略 cmake 使用的构建目录.
          "venv/", -- 忽略 python 的虚拟环境目录
        },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
        },
      }
    })

    -- 加载 fzf 扩展
    telescope.load_extension("fzf")
  end
}
