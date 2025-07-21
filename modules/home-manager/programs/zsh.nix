{ 
  config, 
  pkgs,
  pkgs-custom,
  pkgs-unstable,
  ... 
}:

{
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          #"fzf-tab"
          #"fzf"
          #"zsh-autosuggestions"
          "sudo"
          "web-search"
          #"zsh-syntax-highlighting"
          #"fast-syntax-highlighting"
          "copypath"
          "copyfile"
          "copybuffer"
          "dirhistory"
          "jsontools"
        ];
      };

      shellAliases = {
        ll = "ls -l";
        
        update-etc = "sudo nix flake update --flake /etc/nixos/";
        update = "sudo nix flake update --flake ~/nixos-base-stable/";

        edit = "nvim ~/nixos-base-stable/";

        src = "source ~/.zshrc";

        nv = "nvim";
        ff = "fastfetch";
        ls = "lsd -a";
      };

      initContent = ''
        export EDITOR="nvim"
      '';
    };
    
  };
}
