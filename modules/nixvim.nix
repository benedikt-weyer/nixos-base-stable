{ config, pkgs, ... }:

{
  programs = {
    nixvim = {
      enable = true;

      colorschemes.gruvbox.enable = true;

      plugins = {
        lualine.enable = true;
        telescope.enable = true;
        oil.enable = true;
        treesitter.enable = true;
        luasnip.enable = true;
        web-devicons.enable = true;
      };
    };
    
  };
}