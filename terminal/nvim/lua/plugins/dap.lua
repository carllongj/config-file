--[[
dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        -- 使用内建映射
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- 自定义布局
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 40, -- 左侧栏宽度
          position = "left",
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10, -- 底部栏高度
          position = "bottom",
        },
      },
    })
]]--
return {
  {
    "mfussenegger/nvim-dap", -- 用以支持调试
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dapui = require("dapui")
      dapui.setup({
        {
          icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              position = "left",
              size = 40,
            },
            {
              elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
              },
              position = "bottom",
              size = 10,
            },
          },
          floating = {
            max_height = nil,
            max_width = nil,
            border = "rounded", -- 使用圆角边框符合主题感
            mappings = {
              close = { "q", "<Esc>" },
            },
          },
        }
      })

      -- 核心：监听调试事件，自动开启/关闭 UI
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      --[[
        用以根据 nvim-dap 的事件来进行清理窗口,以下为调试结束就默认关闭窗口.
      ]]--
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close()
      -- end

      -- 定义高亮的颜色.
      local function set_dap_hl()
        local colors = {
          red    = "#db4b4b",
          yellow = "#e0af68",
          green  = "#9ece6a",
          cyan   = "#7dcfff",
          blue   = "#7aa2f7",
          gray   = "#3b4261",
        }

        -- 断点图标颜色
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = colors.red })
        vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = colors.yellow })
        vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = colors.cyan })
        -- 当前执行行：背景加深，文字变亮
        vim.api.nvim_set_hl(0, 'DapStopped', { fg = colors.green, bg = colors.gray, bold = true })
        vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = colors.red, italic = true })
      end
      set_dap_hl()

      -- 定义对应的风格图标.
      local dap_icons = {
        Stopped             = { "󰁕 ", "DapStopped", "DapStoppedLine" },
        Breakpoint          = { " ", "DapBreakpoint" },
        BreakpointCondition = { " ", "DapBreakpointCondition" },
        BreakpointRejected  = { " ", "DapBreakpointRejected" },
        -- 这里的文本不能超过 2 个字节
        LogPoint            = { "󰰚 ", "DapLogPoint" }, -- 推荐使用这个 Nerd Font 图标
      }

      for name, config in pairs(dap_icons) do
        vim.fn.sign_define("Dap" .. name, {
          text = config[1],
          texthl = config[2],
          linehl = config[3] or "",
          numhl = config[2],
        })
      end

      -- 配置变量半透明在行尾显示
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = true, -- 以注释风格显示，完美契合 Tokyo Night
        -- 只有在调试停止时才显示
        only_first_definition = true,
        all_references = false,
    })
    end
  },
  {
    -- python 专用的 dap 调试插件
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- 路径指向 Mason 安装的 debugpy,(需要安装该dap).
      local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end
  }
}
