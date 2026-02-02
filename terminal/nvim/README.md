### 网络导致插件无法安装
1. 解决 `lazy` 插件无法下载
  ```
    git config --global http.https://github.com/.proxy http://<ip>:<port>
  ```

2. 解决 `treesitter` 使用 `curl` 无法下载的问题,启动时设置环境变量,curl可以读取该变量
来自动的设置代理(常规情况下是`无效`的).
  ```
    http_proxy=http://<ip>:<port> nvim

    # nvim 尾行模式来安装markdown 的 treesitter
    TSInstall markdown
  ```
3. 健康检查的命令
  ```
    # 尾行模式下输入

    :checkhealth
  ```
4. `Mason` 无法下载 `Lsp`,修改代码强制使用代理.
  1. 定位到 `lazy` 插件包管理器,找到mason的目录.
  ```bash
     cd $HOME/.local/share/nvim/lazy/mason.nvim
  ```
  2. 编辑 `curl` 请求下载的代码,路径为 `lua/mason-core/fetch.lua`,找到
  `local function curl()`,修改其 `swapn.curl` 中的定义,增加一个代理参数.
  ```lua
        return spawn.curl {
            headers,
            "-fsSL",
            {
                "-X",
                opts.method,
            },
           -- 增加 curl 的代理配置 开始
            {
                "-x",
                "http://127.0.0.1:7890",
            },
           -- 增加 curl 的代理配置 结束
            opts.data and { "-d", "@-" } or vim.NIL,

  ```

### 部分更新命令
* 常规更新
  ```bash
    # 更新 Tree-Sitter
    :TSUpdate

    # 更新 Mason
    :MasonUpdate

    # 同步所有插件更新
    :Lazy Update
  ```
