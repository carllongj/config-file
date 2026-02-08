### 配置说明
* `flake.nix` 中定义了一些变量用以快速设置配置属性.
```
  var = {
    # 设置创建的用户名以及其组别名称.
    username = "<username>";

    # 设置 git 相关的属性
    git = {
      # 设置 git 邮箱.
      email = "<email>";

      # 设置 github 域名对应的代理地址.
      proxy = "<proxy>"
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