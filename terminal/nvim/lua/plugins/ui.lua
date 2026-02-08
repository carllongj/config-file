-- neovim 整个 UI 界面的配置,包含
--[[
  配色方案
  icon 图标配置,它通常作为被依赖项目.
  lualine 状态配置.
  bufferline 缓冲区标签页.
  nvim-tree 文件树.
]]--
return {
  {
    "folke/tokyonight.nvim",
    -- 配置方案禁用延迟加载,启动时就必须要加载.
    lazy = false,
    -- 设置高优先级.
    priority = 1000,
    config = function ()
      -- 配置主题颜色
      vim.cmd([[colorscheme tokyonight-moon]])

      -- 可以通过配色方案继续额外配置.
      -- require('tokyonight').setup({})
    end,
  },
  {
    -- icons 图标的插件.
    "nvim-tree/nvim-web-devicons",
    lazy = true, -- 它通常被其他插件调用，所以设置为延迟加载
    opts = {
      -- 可以自定义某个后缀的图标
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        }
      },
      -- 是否使用默认颜色
      default = true,
    }
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
      -- 启用底部状态栏信息
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
        },
        --[[
            sections 用以配置 statuslines 的组件,支持6个显示
            左侧三个组件: lualine_a,lualine_b,lualine_c
            右侧三个组件: lualine_x,lualine_y,lualine_z
            每一个组件都可以显示多个.
          ]]--
        sections = {
          -- lualine_c 用双层表是因为需要对组件进行个性化配置时,就
          -- 必须要使用双层表.
          lualine_c = {
            {
              'filename', -- 第三个组件显示为文件名称
              path = 1 , -- 配置显示方式,0: 仅文件名 1: 打开工作路径的相对路径 2: 绝对路径.
            }
          },
        },
      })
    end,
  },
  {
    -- bufferline 配置项,使得顶部缓冲区类似于现代编辑器的tab标签页.
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    -- 延迟加载,提升启动速度.
    event = "VeryLazy",
    --[[
      opts 与 config 的区别是,适用于大多数标准插件.它等价于
      config = function(_,opts)
        require("bufferline").setup(opts)
      end
      可以简化配置,但是若要在 setup 之前执行一些逻辑
      则只能使用 config 来定义函数,并且手动调用 setup.
    ]]--
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "nvim-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
  {
    -- nvim-tree 的目录的左侧目录树结构,方便对整体目录结构进行查看,当
    -- 光标移动到左侧的目录树时(同时将进入命令模式),还具有以下的能力.
    --[[
      常用以下交互命令

      键入 a -> 在光标位置(所在目录下)创建一个文件或者目录(目录必须要以/结尾).
      键入 r -> 重命名光标位置的文件或者目录.
      键入 d -> 删除光标位置的文件或者目录.
      键入 x -> 剪切光标位置的文件或者目录,它与nvim中的复制不同.
      键入 c -> 复制光标位置的文件或者目录,它与nvim中的复制不同.
      键入 p -> 粘贴通过 x 或者 c 复制的文件或者目录.
    ]]--
    "nvim-tree/nvim-tree.lua",
    -- 图标依赖配置信息.
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- 设置文档树的快捷键,该快捷键已经在 keymaps 中设置,此处不定义.
    -- keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", } },
    config = function ()
      require('nvim-tree').setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true, -- 合并空文件夹
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false, -- 是否隐藏dotfile文件或者目录.
          custom = {
            "^\\.git$", -- 隐藏目录树下的.git目录.
          },
        },
        update_focused_file = {
          enable = true,     -- 自动更新 tree 中高亮的文件
          update_root = false, -- 是否改变 root，可按需改成 true
        },
      })
    end,
  },
}
