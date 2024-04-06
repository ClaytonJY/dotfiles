{ config, pkgs, ... }:

{

  home.username = "claytonjy";
  home.homeDirectory = "/home/claytonjy";

  home.stateVersion = "22.11";

  home.packages = with pkgs; [

    git
    nano

    ripgrep
    jq
    fd
    bat
    fzf
    sd
    eza

    ffmpeg

    kubernetes-helm

    pipx
    pyenv

    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })

    nil
  ];

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "master";
          sha256 = "RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    interactiveShellInit =
      ''
        starship init fish | source
        pyenv init - | source
      '';
    loginShellInit =
      ''
        pyenv init --path | source
      '';
    shellInit =
      ''
        # pipx install dir
        fish_add_path -g ~/.local/bin
      '';
    shellAliases = {
      ls = "eza";
      ll = "eza -al --icons";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  fonts.fontconfig.enable = true;


  home.file = {

    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore".source = ./git/.gitignore;

    ".abridge.gitconfig".source = ./git/.abridge.gitconfig;

    ".config/pypoetry/config.toml".source = ./poetry/config.toml;

  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
