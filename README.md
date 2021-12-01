# dotfiles

My personal dotfile repo. One directory per application, managed by [GNU Stow](https://www.gnu.org/software/stow/) as described [here](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html).

Also a general dumping ground of stuff I like having installed, to remind myself. Perhaps someday I'll automate all this...

## Usage

### Initial Setup

Follow these steps on a new system.

#### Pre-Reqs

A lot of these configs refer to [NerdFonts](https://www.nerdfonts.com). Download the `FiraCode` and `FiraMono` zipfiles from [their Downloads page](https://www.nerdfonts.com/font-downloads), then copy the `*.otf` files to `~/.local/share/fonts`, e.g.

```bash
cd ~/Downloads
# should find FiraCode.zip and FiraMono.zip
find -name 'Fira*.zip' -exec unzip {} -d fonts/ \;
rm fonts/*Windows*
mkdir ~/.local/share/fonts
cp fonts/Fira*.otf ~/.local/share/fonts
rm -rf fonts Fira*.zip
```

#### Stow dotfiles

Clone this repo to `~/dotfiles`.

**DO NOT** clone to `/src/dotfiles` or similar, unless you want to add a `-t` arg to every `stow` call!

Then stow (install) everything possible:

```bash
cd ~/dotfiles
ls -d */ | xargs stow -v --no-folding
```

#### Install programs

Install programs as needed. Order _mostly_ doesn't matter now that you have fonts, but you should install `starship` before `fish`, as the latter's config references the former.

Then consider installing other fun stuff, like
- `alacritty`: nice terminal emulator, though doesn't support FiraCode (FiraMono works)
- `ripgrep`: faster, better `grep` alternative
- [`fd`](https://github.com/sharkdp/fd): faster, better `find` alternative
- `jq`: how else do you look at JSON?

Python-specific:
- `pipx`: manage all your python-based tools
- `pyenv`: because you'll need more than one python version
- `poetry`: the only poetry package manager worth using (install w/ `pipx`!)


### Updating controlled configs

Making any change to a file placed by `stow` will be reflected here; use `git` to commit and push such changes.

### Adding new configs

1. identify folder path of new configs
1. exit program controlling said configs
1. use `mkdir` & `touch` to stub out files in `dotfiles/`, e.g.
    ```
    mkdir -p kitty/.config/kitty/
    touch kitty/.config/kitty/kitty.conf
    ```
2. use `--adopt` to adopt files
    ```
    stow --adopt kitty
    ```

TODO: automate the above steps, esp. for multi-file configs.
