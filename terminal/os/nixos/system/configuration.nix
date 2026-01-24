{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 指定使用的内核版本
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPAER = "zh_CN.UTF-8";
    LC_CTYPE = "zh_CN.UTF-8";
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Sans" "Noto Sans CJK SC"];
        sansSerif = ["Noto Serif" "Noto Serif CJK SC"];
        monospace = ["JetBrainsMono Nerd Font"];
	emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # enable OpenSSH
  services.openssh.enable = true;
  # 是否允许密码登录
  services.openssh.settings.PasswordAuthentication = true;
  # 是否允许root登录,默认为no
  # services.openssh.settings.PermitRootLogin = "yes";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # 使用 plasma6 桌面环境
  # services.desktopManager.plasma6.enable = true;

  # Enable display manager
  programs.niri.enable = true;
  services = {
    xserver.enable = false;
    # greetd = {
    #   enable = true;
    #   settings.default_session = {
    #     command = "niri-session";
    #     user = "carl";
    #   };
    # };

    # 使用 gnome 桌面后端环境
    # desktopManager.gnome.enable = true;
    
    # 使用 plasma6 桌面后端环境.
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
      };
      # gdm = {
      #   enable = true;
      #   wayland = true;
      # };
    };
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carl = {
    isNormalUser = true;
    shell = pkgs.zsh;
    group = "carl";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/carl";
    packages = with pkgs; [
      tree
    ];
  };
  
  users.groups.carl = {};

  # wheel 进行sudo执行时是否需要密码
  security.sudo.wheelNeedsPassword = false;

  # programs.firefox.enable = true;
  # 给用户设置 zsh 时必须要先启用
  programs.zsh.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # 指定要安装的软件包到系统环境中可用.
  environment.systemPackages = with pkgs; [
    wget
    alacritty
    neovim
    git
    pciutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  #nix.settings.substituters = [
    #"https://mirror.sjtu.edu.cn/nix-channels/store"
    #"https://mirrors.cernet.edu.cn/nix-channels/store"
  #];
  nix.gc = {
    # 是否开启自动垃圾回收.
    automatic = lib.mkDefault true;

    dates = lib.mkDefault "weekly";
    # 可选保留最近7天的构建.
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

