{ pkgs, inputs, ... } :

{
  imports = [ inputs.walker.homeManagerModules.default ];
  programs.walker.enable = true;

  xdg.configFile."walker".source = ./walker-config;
}
