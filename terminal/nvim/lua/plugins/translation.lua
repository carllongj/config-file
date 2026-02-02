-- 翻译插件配置

return {
  {
    -- 用以加载翻译插件
    "uga-rosa/translate.nvim",
    -- 表示懒加载
    lazy = true,
    -- 只有执行这些命令时才加载
    cmd = { "Translate", "TranslateW" },

    config = function ()
      -- 配置 translate 翻译插件,默认使用了 translate-shell
      -- 因此机器上必须要安装,安装命令如下.
      --[[
        ubuntu 安装
        sudo apt install translate-shell

        arch 安装
        sudo pacman -S translate-shell
      ]]
      require('translate').setup({
          default = {
          command = "translate_shell",
        },
        preset = {
          command = {
            translate_shell = {
              args = { "-e", "bing" }
            }
          }
        }
    })
    end
  },
}