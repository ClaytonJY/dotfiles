{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    # The native, signed macOS app; pkgs.ghostty is the Linux source build.
    package = pkgs.ghostty-bin;
    settings = {
      # Start Fish even while the account's login shell is still /bin/zsh.
      command = "${config.home.profileDirectory}/bin/fish --login";
      font-family = "FiraCode Nerd Font";
      # Updates belong to flake.lock and Home Manager.
      auto-update = "off";
    };
  };
}
