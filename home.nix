{ config, pkgs, ... }:

{

  home.username = "claytonjy";
  home.homeDirectory = "/home/claytonjy";

  home.stateVersion = "22.11";

  home.packages = [

    pkgs.git
    pkgs.nano

    pkgs.ripgrep
    pkgs.jq
    pkgs.fd
    pkgs.bat
    pkgs.fzf
    pkgs.sd
    pkgs.exa

    pkgs.ffmpeg

    pkgs.kubernetes-helm

    pkgs.pipx
    pkgs.pyenv

    # TODO: get kitty working in home bar
    # pkgs.kitty

    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })

    pkgs.rnix-lsp
    pkgs.nixpkgs-fmt
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
      ls = "exa";
      ll = "exa -al --icons";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore".source = ./git/.gitignore;

    ".abridge.gitconfig".source = ./git/.abridge.gitconfig;

    ".config/pypoetry/config.toml".source = ./poetry/config.toml;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/claytonjy/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
