### 配置说明
* `config/variable.nix` 中定义了一些变量用以快速设置配置属性.
```
  {
    # 设置创建的用户名以及其组别名称.
    username = "<username>";

    # 全局的代理服务器设置,一些软件会根据是否配置了该变量
    # 来决定是否安装,例如 proxychains .
    proxy = "<proxy>"

    # 设置 git 相关的属性
    git = {
      # 设置 git 邮箱.
      email = "<email>";

      # 设置 github 域名对应的代理地址.若没有设置,则
      # 会使用全局代理指定的地址.
      # proxy = "<proxy>"
    };
  };
```

#### 运行构建
* 配置文件中使用了 `nix` 的一些新特性(`管道`),在加载目录时使用了该特性,因此在构建
  系统时需要使用以下命令.
  ```bash
    sudo nixos-rebuild switch --flake . --option \
      extra-experimental-features "pipe-operators"
  ```
  * 其中 [`nix-config`](./modules/nix-config.nix) 文件中将`实验性特性`会写入
    到`/etc/nix/nix.conf`配置文件中,后续的构建就不再需要该特性选项了.

#### 软链接
* 为了减少重复的配置文件,`NixOS`使用了软链接来链接到重复的配置项.`Windows`系统下
  需要配置`Git`正确的处理软链接.
  ```bash
    git config --global core.symlinks true
  ```
  * 该选项用以正确的在操作系统上处理软链接,避免将软链接当作普通文件.

