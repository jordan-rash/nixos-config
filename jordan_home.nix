{ pkgs, ... }:


{
  home.username = "jordan";
  home.homeDirectory = "/home/jordan";

  home.packages = [
    pkgs.git
    pkgs.neovim
  ];


  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
