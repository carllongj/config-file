# 该文件不需要被 import,它只是在主动调用 agenix 命令进行加密时才会使用.
# 在手动进行 agenix 时需要使用选项来选择一个公钥组合来进行加密.

# 实际上仍然可以通过 age 命令加密后将 .age 文件写入到该目录下,然后配置
# 解密的条目,NixOS 在构建时就会自动对其解密.

# NixOS 不负责对数据加密,需要用户自行加密,并且将其记录到解密的配置中,它
# 负责将数据解密写入到系统中使用.

let
  lib = (import <nixpkgs> {}).lib;

  # 裁剪密钥后的 comment 函数
  cleanPublicKey = path:
    let
      raw = builtins.readFile path;

      content = lib.trim raw;
      parts = lib.splitString " " content;
    in
    "${builtins.elemAt parts 0} ${builtins.elemAt parts 1}";

  # 定义加密使用的公钥文件.
  userPublicKey = cleanPublicKey ~/.ssh/id_ed25519.pub;

  # 加载 ssh 服务端公钥进行加密.
  serverPublicKey = cleanPublicKey /etc/ssh/ssh_host_ed25519_key.pub;
in
{
  # 配置公钥的加密组合,它是通过 agenix -e <type> 指定一个加密文件,这个加密文件
  # 使用指定的密钥来加密,并且这个文件输出只能是 <file> 的名称.
  "enc.age".publicKeys = [ userPublicKey serverPublicKey ];
}
