{ pkgs, ... }:


{
  home.username = "jordan";
  home.homeDirectory = "/home/jordan";

  home.packages = [
    pkgs.git
    pkgs.neovim
  ];
  programs.git = {
    enable = true;
    userName = "Jordan Rash";
    userEmail = "15827604+jordan-rash@users.noreply.github.com";
    signing = {
      key = "CA5202A3359F64C1";
      signByDefault = true;
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
      tree = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store";
      github.user = "jordan-rash";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
