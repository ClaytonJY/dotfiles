# dotfiles

My personal dotfile repo. Managed with [`nix`](https://nixos.org/manual/nix/stable/introduction.html) and [`home-manager`](https://nix-community.github.io/home-manager/index.html).

## Bootstrapping a new environment

Install basic OS prerequisites first.

```shell
# Debian, Ubuntu, Pop!_OS, etc.
sudo apt update && sudo apt install -y curl git
```

On macOS, install the Xcode Command Line Tools if `git` is missing.

```shell
xcode-select --install
```

If this machine already has an older upstream Nix install from the Determinate
installer, follow the [Determinate migration guide](https://docs.determinate.systems/guides/migrating-from-upstream-nix/)
instead of running the fresh install command below.

```shell
ts=$(date +%Y%m%d-%H%M%S)

if [ -e /etc/nix/nix.conf ]; then
  sudo cp -a /etc/nix/nix.conf "/etc/nix/nix.conf.pre-determinate-${ts}"
fi

if [ -e /nix/receipt.json ]; then
  sudo mv /nix/receipt.json "/nix/receipt-upstream-${ts}.json"
fi

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Otherwise, use the [Determinate Systems Nix Installer](https://docs.determinate.systems/) to install Determinate Nix and `determinate-nixd`.

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Then refresh the shell environment:

```shell
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

Then clone this repository. Use SSH if the machine already has GitHub SSH keys:

```shell
git clone git@github.com:ClaytonJY/dotfiles.git ~/.config/home-manager
cd ~/.config/home-manager
```

Or use HTTPS on a fresh machine:

```shell
git clone https://github.com/ClaytonJY/dotfiles.git ~/.config/home-manager
cd ~/.config/home-manager
```

Configure a private Git identity outside this public repo:

```shell
mkdir -p ~/.config/git
if [ ! -e ~/.config/git/local.gitconfig ]; then
  cp git/identity.gitconfig.example ~/.config/git/local.gitconfig
fi
nano ~/.config/git/local.gitconfig
```

This configuration sets `user.useConfigOnly = true`, so Git will fail clearly
instead of guessing an identity if the local file is missing or incomplete.

For work-specific identities, copy the same example again:

```shell
if [ ! -e ~/.config/git/example-company.gitconfig ]; then
  cp git/identity.gitconfig.example ~/.config/git/example-company.gitconfig
fi
nano ~/.config/git/example-company.gitconfig
```

Then add private `includeIf` routing rules to `~/.config/git/local.gitconfig`.
Use `gitdir:` rules for local checkout directories or `hasconfig:remote.*.url:`
rules for specific Git hosting orgs.

Profiles are named by role and platform:

| Profile | Platform | GUI | Intended use |
| --- | --- | --- | --- |
| `linux-laptop` | `x86_64-linux` | yes | Linux laptop or desktop |
| `macbook` | `aarch64-darwin` | yes | Apple Silicon MacBook |
| `linux-vm` | `x86_64-linux` | no | Headless or lightweight Linux VM |

Each profile sets `home.username` and `home.homeDirectory` in `flake.nix`.
Before switching on a machine with a different account name or home path, update
that profile's values.

All profiles currently share `home.stateVersion = "26.05"` from `home.nix`.
Treat this as the baseline for fresh Home Manager activations, not as a value to
bump during routine lockfile or package updates. Only change it when you
intentionally accept the stateful migrations gated by that Home Manager release.
If an existing machine was first activated with an older state version, keep that
older value for the machine, likely by moving `home.stateVersion` into
profile-specific modules before switching.

To start using this configuration, first bootstrap `home-manager` with the
profile for this machine:

```shell
mkdir -p ~/.local/state/nix/profiles
nix run .#home-manager -- switch --flake .#linux-laptop
```

Use `.#macbook` on an Apple Silicon MacBook, or `.#linux-vm` on a Linux VM.

For `linux-laptop` on a non-NixOS distribution, finish the GPU setup before
launching Ghostty or other GPU-accelerated Nix apps. The profile enables Home
Manager's `targets.genericLinux` integration, but creating the system-wide
`/run/opengl-driver` link requires a separate sudo command. Look for the
`Activating checkExistingGpuDrivers` warning in the switch output and run the
exact command it prints, which looks like:

```text
sudo /nix/store/HASH-non-nixos-gpu/bin/non-nixos-gpu-setup
```

`HASH` is a placeholder; use the path from your current switch output. If you
missed the warning, rerun `home-manager switch --flake .#linux-laptop` to see it
again. The setup persists across reboots, but later Home Manager switches may
print a new command when the graphics libraries need updating. Run that command
when prompted, then fully quit and reopen Ghostty.

Without this setup, Ghostty can report that it is unable to acquire an OpenGL
context even when native apps work. See [Ghostty's GTK OpenGL context
troubleshooting](https://ghostty.org/docs/help/gtk-opengl-context), its
[non-NixOS installation guidance](https://ghostty.org/docs/install/binary#nix-on-other-distros),
and [Home Manager's GPU setup documentation](https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md).

Then install this repo's development check tools and local Git hooks:

```shell
mise trust
mise install
```

This installs `hk` and `pkl` from [`mise.toml`](mise.toml), then runs
`hk install --mise` for this clone. The hooks are local to this repository:
`pre-commit` checks formatting, while `pre-push` runs the full check suite.

On Linux, then change the default shell to `fish`:

```shell
fish_path=$(command -v fish)

# add fish to list of shells, if needed
if ! grep -qxF "$fish_path" /etc/shells; then
  echo "$fish_path" | sudo tee -a /etc/shells
fi

# change login shell to fish
chsh -s "$fish_path"
# or on some systems (e.g. most VMs)
sudo chsh -s "$fish_path" "$USER"
```

On macOS, run the `macbook` profile first, confirm the installed Fish path with
`which fish`, and use the system shell settings or `chsh` if you want Fish as
the login shell.

If this repository was cloned over HTTPS on a fresh machine, use the installed
GitHub CLI to set up SSH and flip the remote afterward:

```shell
gh auth login --git-protocol ssh
ssh -T git@github.com
git remote set-url origin git@github.com:ClaytonJY/dotfiles.git
git remote -v
```

`gh auth login --git-protocol ssh` will offer to upload an existing SSH key, or
create and upload one if none is available.

## Development

### Working with Codex

Future Codex sessions should start with [`AGENTS.md`](AGENTS.md), which captures
the repo shape, known warnings, profile model, and verification expectations.

For a normal verification pass, run:

```shell
hk check --all
```

That runs the same check suite as the repo hooks. If `hk` is not on `PATH` in
the current shell, use the explicit mise form:

```shell
mise x -- hk check --all
```

The full suite checks Nix formatting, evaluates all supported systems with
`nix flake check --all-systems --no-build`, then runs `nix flake check` to build
the flake checks for the current host system. Home Manager activation packages
are exposed as flake-native checks, so Linux hosts build the Linux profiles and
Apple Silicon Macs build the `macbook` profile.

The automated hooks are intentionally repo-local. This avoids writing hk config
into Home Manager-managed global Git config while still making checks automatic
for commits and pushes from this clone.

When making changes to the configuration here, apply with

```shell
home-manager switch --flake .#linux-laptop
```

Use the matching profile on other machines:

```shell
home-manager switch --flake .#macbook
home-manager switch --flake .#linux-vm
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
- [hk docs](https://hk.jdx.dev/)
- [mise docs](https://mise.jdx.dev/)

- [Fonts - NixOS wiki](https://nixos.wiki/wiki/Fonts)

- [Declarative management of dotfiles with Nix and Home Manager (2021)](https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager)
- [Managing dotfiles with Nix (2021)](https://alexpearce.me/2021/07/managing-dotfiles-with-nix/)
- [Dustin Lyons' Nix Config](https://github.com/dustinlyons/nixos-config)
