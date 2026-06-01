# Codex Notes

## Repo Shape

- This is a public Home Manager flake for personal dotfiles.
- Keep secrets, private Git identity, SSH keys, employer names, and machine-specific credentials out of this repo.
- `home.nix` is the shared base module.
- `profiles/gui.nix` adds GUI/user-facing extras such as fonts.
- `profiles/linux-gui.nix` adds Linux GUI plumbing such as fontconfig and Linux-only GUI apps such as Ghostty.
- Current profiles:
  - `linux-laptop`: `x86_64-linux`, GUI.
  - `macbook`: `aarch64-darwin`, GUI placeholder values.
  - `linux-vm`: `x86_64-linux`, headless/lightweight placeholder values.

## Nix Workflow

- Prefer `rg` for searching and inspect the existing module shape before editing.
- Use `nix eval` for focused checks while developing.
- Use `mise x -- hk check --all` for the normal verification pass; it runs the hk check suite, including `nix flake check --all-systems --no-build` for cross-platform output evaluation and `nix flake check` for current-system activation builds.
- When editing `hk.pkl` or `mise.toml`, also run `mise x -- hk validate`.
- `nix flake check --all-systems --no-build` evaluates every supported system; `nix flake check` builds only the checks for the current host system.
- Run `home-manager switch --flake .#<profile>` only for the current machine's intended profile.
- The known `builtins.derivation` warning from Home Manager docs generation is noise unless it becomes an error.
- New files referenced from `flake.nix` must be tracked in Git before Nix can evaluate them through the local Git flake.

## System Nix

- Determinate Nix owns system Nix and `determinate-nixd`.
- Do not add system Nix management to Home Manager.
- Do not use `nix upgrade-nix`; use `sudo determinate-nixd upgrade` for Determinate Nix upgrades.

## Style

- Keep modules small and capability-oriented rather than username-oriented.
- Prefer Home Manager program modules when they own real behavior, shell integration, or config files.
- Keep README bootstrap steps current with the flake profile names.
- Keep repo automation local to this repository unless there is a clear reason to make it global.
