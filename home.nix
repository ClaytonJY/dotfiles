{ config, pkgs, ... }:

{

  home.username = "claytonjy";
  home.homeDirectory = "/home/claytonjy";

  # Set to the Home Manager release whose stateful defaults this config follows.
  # Do not bump casually; it gates file locations, formats, and other migrations.
  home.stateVersion = "26.05";
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
    zoxide   # cd
    mise     # tool versions
    zellij   # tmux

    fzf
    jq

    ffmpeg

    kubernetes-helm
    dive

    uv

    nerd-fonts.fira-code
    nerd-fonts.fira-mono

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
    interactiveShellInit =
      ''
        zoxide init fish | source
        mise activate fish | source
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

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
