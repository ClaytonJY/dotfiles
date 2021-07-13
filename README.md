# dotfiles

My personal dotfile repo. One directory per application, managed by [GNU Stow](https://www.gnu.org/software/stow/) as described [here](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html).

## Usage

Clone this to `~/dotfiles`, `cd dotfiles`, then `stow --no-folding <application>` to deploy the version-controlled configs for `<application>` as symlinks.

(the `--no-folding` option is especially important for programs like VSCode that have a lot of stuff you might not care to version mixed in)
