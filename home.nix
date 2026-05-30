{ config, pkgs, ... }:

{

  home.username = "claytonjy";
  home.homeDirectory = "/home/claytonjy";

  home.stateVersion = "22.11";
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
        name = "Clayton Yochum";
        email = "claytonjy@gmail.com";
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
        condition = "hasconfig:remote.*.url:git@bitbucket.org:abridge-ai/**";
        contents = {
          user = {
            email = "clayton@abridge.com";
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:git@github.com:abridgeai/**";
        contents = {
          user = {
            email = "clayton@abridge.com";
          };
        };
      }
    ];

    ignores = [
      ".python-version"
      ".vscode"
      ".venv"
      ".vagrant"
    ];

  };

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
