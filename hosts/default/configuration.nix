{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-custom,
  pkgs-24-11,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-stable-testing";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; # Disable root login
      PasswordAuthentication = false; # Disable password authentication
      AllowUsers = null; # Allow all users by default
      UseDns = true; # Enable DNS lookups for hostnames
      X11Forwarding = false;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
      vpl-gpu-rt # Video Processing Library for Intel GPUs
    ];
  };

  users.users.vboxuser = {
    isNormalUser = true;
    description = "vboxuser";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "scanner" 
      "lp" 
      "audio"
    ];
  };

  home-manager = {
    extraSpecialArgs = { 
      inherit inputs; 
      inherit pkgs-unstable;
      inherit pkgs-24-11;
      pkgs-custom = pkgs-custom pkgs;
    };
    users = {
      "vboxuser" = import ./home.nix;
    };
  };

  environment.systemPackages = with pkgs; [

  ];

  system.stateVersion = "25.05";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
