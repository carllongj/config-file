{pkgs, ...}:

{
  imports = [
    ./shell
    ./programs
  ];

  home.stateVersion = "25.11";
  # 禁用版本匹配检查
  home.enableNixpkgsReleaseCheck = false;
}
