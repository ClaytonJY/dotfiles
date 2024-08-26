{ config, pkgs, ... }:

{

  home.username = "claytonjy";
  home.homeDirectory = "/home/claytonjy";

  home.stateVersion = "22.11";

  home.packages = with pkgs; [

    git-absorb
    nano

    # modern shell tools
    ripgrep  # grep
    fd       # find
    bat      # cat
    sd       # sed
    eza      # ls/exa
    zoxide   # cd
    mise     # asdf/direnv/pyenv

    fzf
    jq

    ffmpeg

    kubernetes-helm
    dive

    pipx
    pyenv
    uv

    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })

    nil
  ];

  programs.git = {
    enable = true;

    userName = "Clayton Yochum";
    userEmail = "claytonjy@gmail.com";

    lfs.enable = true;

    extraConfig = {

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
        starship init fish | source
        pyenv init - | source
        zoxide init fish | source
        mise activate fish | source
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

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  fonts.fontconfig.enable = true;


  home.file = {
    ".config/pypoetry/config.toml".source = ./poetry/config.toml;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
