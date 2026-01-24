{
  programs.git = {
    enable = true;

    # 允许手动配置的信息.
    includes = [
      {
        path = "~/.config/nixos-manual/.gitconfig";
      }
    ];
    settings = {
      user = {
        name = "carllongj";
	email = "carllongj@gmail.com";
      };

      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}
