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
        update = "sudo nix flake update --flake ~/nixos-config";

        edit = "code ~/nixos-config";

        src = "source ~/.zshrc";

        nv = "nvim";
        ff = "fastfetch";
        ls = "lsd -a";
      };

      initContent = with pkgs-unstable; ''
        export PRISMA_SCHEMA_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
        export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
        export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
        export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
        export PRISMA_FMT_BINARY="${prisma-engines}/bin/prisma-fmt"

        export EDITOR="nvim"

        export RCLONE_CONFIG="${config.sops.secrets."rclone_config".path}"
      '';
    };
    
  };
}
