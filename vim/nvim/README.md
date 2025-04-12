### 网络导致插件无法安装
1. 解决 `lazy` 插件无法下载
  ```
    git config --global http.https://github.com/.proxy http://<ip>:<port>
  ```

2. 解决 `treesitter` 使用 `curl` 无法下载的问题,启动时设置环境变量,curl可以读取该变量
来自动的设置代理.
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
