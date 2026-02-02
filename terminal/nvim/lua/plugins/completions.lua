-- 补全插件配置.

return {
  {
    -- 自动补全插件配置.
    "hrsh7th/nvim-cmp",
    -- 插入事件是才触发补全配置.
    event = "InsertEnter",
    dependencies = {
      -- 来自 lsp 的补全信息
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      -- 文件路径补全.
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function ()

      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end

      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then
        return
      end

      require("luasnip.loaders.from_vscode").lazy_load()

      local check_backspace = function()
        local col = vim.fn.col "." - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),  -- 取消补全，esc也可以退出
          ['<CR>'] = cmp.mapping.confirm({ select = true }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        }),

        -- 定义补全内容的优先级顺序
        sources = cmp.config.sources({
          -- 使用 lsp 服务的代码补全
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          -- 文件路径补全
          { name = 'path' },
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
  {
    -- 自动补全括号.
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      -- 检查插件是否安装了,若安装才进行配置.
      local npairs_ok, npairs = pcall(require, "nvim-autopairs")
      if not npairs_ok then
        return
      end

      npairs.setup({
        -- 配置 treesitter,在编写注释时会根据情况补充括号.
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
        },
        --[[
          进阶的自动补全括号配置.例如 python 中
          print "autopairs" 没有括号,则通过快捷键 alt-e
          它会弹出提示是否将后面的内容包裹到括号内.
        ]]--
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey='Comment'
        },
      })

      -- 检查是否安装了cmp,然后自动补全lsp中的函数括号.
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end
  }
}