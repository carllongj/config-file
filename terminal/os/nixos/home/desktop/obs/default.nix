{ pkgs, ... }:

{
  # 启用 obs 应用
  programs.obs-studio = {
    enable = true;
    package = (pkgs.obs-studio.override {
      # 强制 OBS 链接到 ffmpeg_7-full,以便于连接到 nvidia 的驱动
      ffmpeg = pkgs.ffmpeg_7-full;
    }).overrideAttrs (oldAttrs: {
    # 包装启动脚本，加入驱动库路径
    postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obs \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
      '';
    });
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-gstreamer
    ];
  };
}
