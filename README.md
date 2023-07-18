# dotfiles

My personal dotfile repo. Managed with [`nix`](https://nixos.org/manual/nix/stable/introduction.html) and [`home-manager`](https://nix-community.github.io/home-manager/index.html).

## Usage

Use the [Determinate Systems Nix Installer](https://zero-to-nix.com/concepts/nix-installer) to install nix, and `git clone` this repository.

To start using this configuration, first bootstrap `home-manager`

```shell
nix run home-manager/master -- switch --flake .
```

then change default shell to `fish`

```shell
# add fish to list of shells
echo $(which fish) | sudo tee -a /etc/shells

# change login shell to fish
chsh -s $(which fish)
# or on some systems (e.g. GCP VMs)
sudo chsh -s $(which fish) "$USER"
```

When making changes to the configuration here, apply with

```shell
home-manager switch --flake .
```

**N.B.**: sometimes we need to update our lockfile

```shell
nix flake update
```

## Resources

- [`nix` package search](https://search.nixos.org/packages)
- [`home-manager` options search](https://mipmip.github.io/home-manager-option-search/)

- [Fonts - NixOX wiki](https://nixos.wiki/wiki/Fonts)

- [Declarative management of dotfiles with Nix and Home Manager (2021)](https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager)
- [Managing dotfiles with Nix (2021)](https://alexpearce.me/2021/07/managing-dotfiles-with-nix/)
- [Zero to Nix](https://zero-to-nix.com/)
- [Dustin Lyons' Nix Config](https://github.com/dustinlyons/nixos-config)
