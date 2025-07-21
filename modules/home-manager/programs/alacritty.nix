{ config, pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        general.import = [ ".nix-profile/catppuccin_macchiato.toml" ];
        terminal.shell = {
          program = "${pkgs.zsh}/bin/zsh";
        };
        window = {
          opacity = 0.7;
        };
        font = {
          normal = {
            family = "GeistMono NFM";
            style = "Regular";
          };
          bold = {
            family = "GeistMono NFM";
            style = "Bold";
          };
          italic = {
            family = "GeistMono NFM";
            style = "Italic";
          };
          size = 12;
        };
        keyboard.bindings = [
          {
            key = "V";
            mods = "Control";
            action = "Paste";
          }
        ];
        mouse.hide_when_typing = false;
      };
    };
    
  };
}