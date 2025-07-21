{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./../../modules/home-manager/programs/zsh.nix
    ./../../modules/home-manager/programs/nixvim.nix
    ./../../modules/home-manager/programs/git.nix
    ./../../modules/home-manager/programs/alacritty.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  home.username = "vboxuser";
  home.homeDirectory = "/home/vboxuser";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  programs.home-manager.enable = true;

  programs = {  
    gpg.enable = true;
  };

  programs.zsh.shellAliases = {
      rebuild-etc = "sudo nixos-rebuild switch --flake /etc/nixos/#default";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-base-stable/#default";
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  fonts.fontconfig.enable = true;
}
