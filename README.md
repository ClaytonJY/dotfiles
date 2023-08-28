# dotfiles

My personal dotfile repo. Managed with [`nix`](https://nixos.org/manual/nix/stable/introduction.html) and [`home-manager`](https://nix-community.github.io/home-manager/index.html).

## Usage

Use the [Determinate Systems Nix Installer](https://zero-to-nix.com/concepts/nix-installer) to install nix, and `git clone` this repository

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

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
# or on some systems (e.g. most VMs)
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

## Non-Nix

There's a lot of things that seem like they could or should be managed here, but aren't.

### Pyenv Build Dependencies

Haven't yet figured out how to include all the pieces needed to `pyenv install` a new version of python.

On a Debian-like system, per the [pyenv docs](https://github.com/pyenv/pyenv/wiki#suggested-build-environment):

```shell
sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

### Poetry

Using a nix-managed poetry leads to weird issues with packaged like `numpy`, see [this thread](https://discourse.nixos.org/t/nixos-with-poetry-installed-pandas-libstdc-so-6-cannot-open-shared-object-file/8442).

So instead I `pipx install poetry`.

## Resources

- [`nix` package search](https://search.nixos.org/packages)
- [`home-manager` options search](https://mipmip.github.io/home-manager-option-search/)

- [Fonts - NixOX wiki](https://nixos.wiki/wiki/Fonts)

- [Declarative management of dotfiles with Nix and Home Manager (2021)](https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager)
- [Managing dotfiles with Nix (2021)](https://alexpearce.me/2021/07/managing-dotfiles-with-nix/)
- [Zero to Nix](https://zero-to-nix.com/)
- [Dustin Lyons' Nix Config](https://github.com/dustinlyons/nixos-config)
