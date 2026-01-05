# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=DP-1:1920x1080" "HDMI-A-1:1920x1080"  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
   modesetting.enable = true;
   open = false;
   nvidiaSettings = true;
   package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  networking.hostName = "ws"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
	command = "${pkgs.bash}/bin/bash -c 'WLR_DRM_DEVICES=/dev/dri/card0 ${pkgs.tuigreet}/bin/tuigreet --time --asterisks --greeting \"Access is restricted to authorized personnel only.\" --cmd Hyprland'";
	user = "greeter";
      };
    };
  };  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    isNormalUser = true;
    description = "David Eriksson";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # System essentials
  glib
  gsettings-desktop-schemas
  adwaita-icon-theme
  apple-cursor

  # System tools
  blueman
  nautilus
  syncthing
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;
  programs.waybar.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.dconf.enable = true;
  programs.yazi.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.blueman.enable = true;
  services.udisks2.enable = true;
  services.syncthing = {
    enable = true;
    user = "david";
    dataDir = "/home/david/Documents/sync";
    configDir = "/home/david/.config/syncthing";
    
    # Open firewall ports automatically
    openDefaultPorts = true;
    
    # Override settings
    overrideDevices = true;
    overrideFolders = true;
    
    settings = {
      gui = {
        user = "david";
        password = "";
      };
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # Home Manager
  home-manager.users.david = { pkgs, ... }: {
    home.stateVersion = "25.11";
    
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      # Development tools
      neovim
      pyright
      rust-analyzer
      gopls
      clang-tools
      lua-language-server
      gcc
      cargo
      git
      python3
      godot

      # Terminal tools
      killall
      wget
      btop
      fastfetch

      # Applications
      keepassxc
      obsidian
      mpv
      claude-code
      kitty

      # Wayland/Hyprland utilities
      wofi
      hyprpaper
      bluetuith
      mako
      libnotify
      nwg-bar
      nwg-drawer
      hyprlock
      udiskie
    ];

    # Dotfiles
    home.file = {
      ".config/hypr".source = ./dots/hypr;
      ".config/kitty".source = ./dots/kitty;
      ".config/nvim".source = ./dots/nvim;
      ".config/nwg-bar".source = ./dots/nwg-bar;
      ".config/nwg-drawer".source = ./dots/nwg-drawer;
      ".config/waybar".source = ./dots/waybar;
      ".config/wofi".source = ./dots/wofi;
    };

    # Services
    services.udiskie = {
      enable = true;
      automount = true;
      tray = "auto";
      settings = {
        program_options = {
          file_manager = "${pkgs.nautilus}/bin/nautilus";
        };
      };
    };
    
    # Program specific configurations
    programs.git = {
      enable = true;
      settings.user.name = "David Eriksson";
      settings.user.email = "david.eriksson@lundkroken.se";
      settings = {
	init.defaultBranch = "main";
      };
    };

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "cypher";
        plugins = [
          "git"
        ];
      };
        
      shellAliases = {
        vim = "nvim";
      };
        
      initContent = ''
        export PATH="$HOME/.local/bin:$PATH"
        [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
      '';
    };
    
    programs.home-manager.enable = true;
  };
}
