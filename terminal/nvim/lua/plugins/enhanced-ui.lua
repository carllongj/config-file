--[[
  ui 增加配置,包含以下插件.
    Git 侧边栏状态配置.
]]--

return {
  {
    -- 左侧git提示
    "lewis6991/gitsigns.nvim",

    -- 在文件打开时才进行加载.
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },

    -- 模块化快捷键配置：在插件内部定义快捷键
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- 导航：跳转到下一个/上一个修改点
      map("n", "]h", function()
        if vim.wo.diff then return "]h" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Next Git hunk" })

      map("n", "[h", function()
        if vim.wo.diff then return "[h" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Prev Git hunk" })

      -- 操作：预览修改内容
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Git hunk" })
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Git blame line" })
    end,
    }
  }
}
