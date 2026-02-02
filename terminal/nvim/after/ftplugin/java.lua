--  Mason 中 LSP 需要安装 jdtls.

-- jdtls 配置,它目前需要 jdk21 作为启动环境版本.
local jdtls = require("jdtls")

-- 备注: 针对 maven 项目未使用标准的项目结构时,可以通过
-- 命令 mvn eclipse:eclipse 生成 .classpath 文件用以允许 jdtls 支持项目.

-- 系统未配置jdtls,则不配置该服务.
if jdtls == nil then
    return
end

-- mason 安装 jdtls 的默认路径,路径在 $HOME/.local/share/nvim/mason
local mason_path = vim.fn.stdpath('data') .. '/mason'

-- jdtls 的安装路径在 $HOME/.local/share/nvim/mason/packages/jdtls 目录
local jdtls_path = mason_path .. '/packages/jdtls'

-- launcher jar 路径,用以启动的jar包.
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

-- platform config 路径(config_{SYSTEM}),Windows为`config_win`,Mac为`config_Mac`。
local config_path = jdtls_path .. '/config_linux'

-- 为每个项目创建唯一 workspace 目录,$HOME/.local/share/nvim/mason/jdtls-workspace目录下.
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- java debug 的包.
local debug_agent = mason_path .. '/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'

-- 项目根目录识别规则
-- jdtls 是可以根据 .classpath 文件来进行构建 lsp,因此可以根据对应的项目构建来生成 .classpath 文件.
-- maven 项目可以直接使用命令来进行生成 mvn eclipse:eclipse 生成.
-- gradle 项目则需要在插件列表中添加 eclipse 插件.然后调用 gradlew eclipse 生成.
local root_dir = require("jdtls.setup").find_root({
  '.git',
  'mvnw',
  'gradlew',
  'pom.xml',
  'build.gradle',
  '.classpath',
  '.project',
  'settings.gradle',
})

if root_dir == nil then
  return
end

-- local function get_bundles()
--   local bundles = {}
--   vim.list_extend(bundles, vim.split(vim.fn.glob(
--     mason_path .. 'share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar'
--   ), '\n'))

--   -- java-test
--   vim.list_extend(bundles, vim.split(vim.fn.glob(
--     mason_path .. 'share/java-test/*.jar'
--   ), '\n'))
--   return bundles
-- end

local on_attach_config = function(_,buf)
  -- 这个是连接成功后的回调函数,目前不需要做任何事.
  local make_opt = function (description)
    return { noremap = true, silent = true, buffer = buf,desc = description }
  end
  -- 优化导入包,移除没有使用的包,ctrl + alt + o 优化导入, java 特有的快捷键定义
  vim.keymap.set('n', '<C-A-o>', function()
    require('jdtls').organize_imports()
  end, make_opt('Optimize Import packages'))

  vim.keymap.set('n', '<leader>v', function ()
    require('jdtls').extract_variable()
  end,make_opt('extract variable'))
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- JDTLS 启动配置
local config = {
  cmd = {
    -- 用以配置java路径,它必须要在 PATH 中指定.
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    '-Dlog.protocol=true',
    "-Dlog.level=ALL",
    "-noverify",
    "-Xmx1G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", config_path,
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  on_attach = on_attach_config,
  capabilities = capabilities,
  -- init_options = {
  --   bundles = get_bundles(),
  -- }
}

-- 启动 JDTLS
jdtls.start_or_attach(config)
