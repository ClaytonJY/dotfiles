{ lib, pkgs, ... }:

{

  # Set to the Home Manager release whose stateful defaults this config follows.
  # Do not bump casually; it gates file locations, formats, and other migrations.
  # See README.md before changing this for an existing machine.
  home.stateVersion = "26.05";
  # This config intentionally tracks nixpkgs-unstable, so Home Manager's
  # release branch check is noisy rather than useful here.
  home.enableNixpkgsReleaseCheck = false;
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";

  home.packages = with pkgs; [

    git-absorb
    nano
    htop

    gh

    codex
    claude-code

    # modern shell tools
    ripgrep # grep
    fd # find
    bat # cat
    sd # sed
    eza # ls/exa
    zellij # tmux

    jq

    ffmpeg

    docker
    kind
    kubectl
    k9s
    kubernetes-helm
    dive

    uv

    rustup

    nixd # Editor language server; separate from the determinate-nixd daemon.
    nixfmt
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
      ".vscode"
      ".venv"
    ];

  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.fish = {
    enable = true;
    # Fish may be installed after Determinate's installer has configured shells.
    # Also initialize Nix when launched directly by a GUI terminal.
    shellInit = lib.mkBefore ''
      if test -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      # Fish discovers these before shellInit when NIX_PROFILES is inherited.
      # A direct GUI launch may only have initialized Nix just above.
      for profile in (string split ' ' "$NIX_PROFILES")
        set -l completions "$profile/share/fish/vendor_completions.d"
        if test -d "$completions"; and not contains -- "$completions" $fish_complete_path
          set -p fish_complete_path "$completions"
        end
      end
    '';
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
    settings = {
      kubernetes.disabled = false;
      mise.disabled = false;
    };
  };

  programs.man.generateCaches = pkgs.stdenv.hostPlatform.isLinux;

  programs.home-manager.enable = true;
}
