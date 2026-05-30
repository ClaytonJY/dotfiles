# dotfiles

My personal dotfile repo. Managed with [`nix`](https://nixos.org/manual/nix/stable/introduction.html) and [`home-manager`](https://nix-community.github.io/home-manager/index.html).

## Bootstrapping a new environment

Use the [Determinate Systems Nix Installer](https://docs.determinate.systems/) to install Determinate Nix and `determinate-nixd`, then `git clone` this repository.

```shell
# requires curl & git, e.g.
sudo apt update && sudo apt install -y curl git

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

If this machine already has an older upstream Nix install from the Determinate installer, follow the [Determinate migration guide](https://docs.determinate.systems/guides/migrating-from-upstream-nix/) first:

```shell
ts=$(date +%Y%m%d-%H%M%S)
sudo cp -a /etc/nix/nix.conf "/etc/nix/nix.conf.pre-determinate-${ts}"
sudo mv /nix/receipt.json "/nix/receipt-upstream-${ts}.json"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

To start using this configuration, first bootstrap `home-manager`

```shell
mkdir -p ~/.local/state/nix/profiles
nix run home-manager/master -- switch --flake .
```

then change default shell to `fish`

```shell
# add fish to list of shells
echo $(which fish) | sudo tee -a /etc/shells

# change login shell to fish
chsh -s $(which fish)
# or on some systems (e.g. most VMs)
sudo chsh -s $(which fish) "$USER"
```

## Development

When making changes to the configuration here, apply with

```shell
home-manager switch --flake .
```

**N.B.**: sometimes we need to update our lockfile

```shell
nix flake update
```

To update Determinate Nix itself:

```shell
determinate-nixd version
sudo determinate-nixd upgrade
```

## Resources

- [`nix` package search](https://search.nixos.org/packages)
- [Determinate Nix docs](https://docs.determinate.systems/determinate-nix/)
- [Determinate Nix upgrade docs](https://manual.determinate.systems/installation/upgrading.html)
- [Determinate upstream Nix migration guide](https://docs.determinate.systems/guides/migrating-from-upstream-nix/)
- [Home Manager manual](https://home-manager.dev/manual/)
- [`home-manager` options search](https://home-manager-options.extranix.com/)

- [Fonts - NixOX wiki](https://nixos.wiki/wiki/Fonts)

- [Declarative management of dotfiles with Nix and Home Manager (2021)](https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager)
- [Managing dotfiles with Nix (2021)](https://alexpearce.me/2021/07/managing-dotfiles-with-nix/)
- [Dustin Lyons' Nix Config](https://github.com/dustinlyons/nixos-config)
