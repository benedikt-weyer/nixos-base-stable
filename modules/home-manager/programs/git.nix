{ config, pkgs, ... }:

{
  programs = {
    git = {
      enable = true;

      extraConfig = {
        user.name = "Benedikt Weyer";
        user.email = "bw.development@pm.me";
        pull.rebase = false;
        core.autocrlf = "input";
        init.defaultBranch = "main";
        diff.tool = "vscode";
        difftool.vscode.cmd = "code --wait --diff $LOCAL $REMOTE";
        alias.co = "checkout";
        alias.br = "branch";
        alias.ci = "commit";
        alias.st = "status";
        alias.lg = "log --oneline --all --graph";

        core = {
          sshCommand = "ssh -i ~/.ssh/id_ed25519";
        };
      };
    };
    
  };
}