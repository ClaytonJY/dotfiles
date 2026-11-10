{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
  ];

  programs.ghostty = {
    enable = true;
    settings = {
      # Use the managed Fish regardless of the account's login shell.
      command = "${config.home.profileDirectory}/bin/fish --login";
      font-family = "FiraCode Nerd Font";
    };
  };
}
