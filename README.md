# dotfiles

My personal dotfile repo. Managed with [`nix`](https://nixos.org/manual/nix/stable/introduction.html) and [`home-manager`](https://nix-community.github.io/home-manager/index.html).

## Usage

Use the [Determinate Systems Nix Installer](https://zero-to-nix.com/concepts/nix-installer) to install nix, and `git clone` this repository.

Then to use this configuration, run

```shell
home-manager switch --flake .
```

## Resources

- [`nix` package search](https://search.nixos.org/packages)
- [`home-manager` options search](https://mipmip.github.io/home-manager-option-search/)

- [Fonts - NixOX wiki](https://nixos.wiki/wiki/Fonts)

- [Declarative management of dotfiles with Nix and Home Manager (2021)](https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager)
- [Zero to Nix](https://zero-to-nix.com/)
- [Dustin Lyons' Nix Config](https://github.com/dustinlyons/nixos-config)
