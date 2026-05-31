{ config, pkgs, ... }:

{

  # Set to the Home Manager release whose stateful defaults this config follows.
  # Do not bump casually; it gates file locations, formats, and other migrations.
  home.stateVersion = "26.05";
  # This config intentionally tracks nixpkgs-unstable, so Home Manager's
  # release branch check is noisy rather than useful here.
  home.enableNixpkgsReleaseCheck = false;
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [

    git-absorb
    nano

    gh

    # modern shell tools
    ripgrep  # grep
    fd       # find
    bat      # cat
    sd       # sed
    eza      # ls/exa
    zellij   # tmux

    fzf
    jq

    ffmpeg

    kubernetes-helm
    dive

    uv

    nil
  ];

  programs.git = {
    enable = true;

    lfs.enable = true;

    settings = {
      user = {
        useConfigOnly = true;
      };
      init.defaultBranch = "main";

      core = {
        editor = "nano";
      };

      push.autoSetupRemote = true;

      rebase.updateRefs = true;

      rerere.enabled = true;
    };

    includes = [
      {
        path = "~/.config/git/local.gitconfig";
      }
    ];

    ignores = [
      ".python-version"
      ".vscode"
      ".venv"
    ];

  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellAliases = {
      ls = "eza";
      ll = "eza -al --icons";
    };
  };

  programs.zoxide.enable = true;

  programs.mise.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.man.generateCaches = pkgs.stdenv.hostPlatform.isLinux;

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
