{ pkgs, ... }:

{
  programs.ghostty = {
    # The native, signed macOS app; pkgs.ghostty is the Linux source build.
    package = pkgs.ghostty-bin;
    # Updates belong to flake.lock and Home Manager.
    settings.auto-update = "off";
  };
}
