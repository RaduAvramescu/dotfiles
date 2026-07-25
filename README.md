# dotfiles

Personal configuration files managed with [chezmoi](https://www.chezmoi.io/).

## Managed files

- `~/Brewfile`
- `~/.config/fish/config.fish`
- `~/.config/ghostty/config`
- `~/.config/MangoHud/MangoHud.conf` on Linux only
- `~/.config/mpv/input.conf` and `~/.config/mpv/mpv.conf`
- `~/.config/starship/starship.toml`
- `~/.config/tmux/tmux.conf`
- `~/.config/tmux/plugins/tokyo-night-tmux` as a chezmoi external

## Install chezmoi

This repository uses Homebrew for its cross-platform command-line packages.
Install Homebrew first, then install chezmoi:

```sh
brew install chezmoi
```

Verify the installation without changing any dotfiles:

```sh
chezmoi --version
chezmoi doctor
```

See the official [chezmoi installation guide](https://www.chezmoi.io/install/)
for other platforms and installation methods.

## Platform packages

The managed Brewfile is rendered for the current platform:

- macOS installs Bash, Fish, Starship, tmux, Ghostty, and the fonts used by
  Ghostty and the tmux theme.
- Bluefin uses its system Fish, Starship, and tmux packages. Homebrew remains
  responsible for chezmoi and cosign. Install Ghostty through the distribution.
- Other Linux distributions install Fish, Starship, and tmux through Homebrew.
  Ghostty and terminal fonts remain distribution-managed.

The account login shell does not need to be changed from Bash. Ghostty launches
Fish directly, and tmux uses Fish as its `default-shell`.

## Set up a new machine

Initialize the default chezmoi source directory from GitHub. Use `--ssh` when
the machine has GitHub SSH access:

```sh
chezmoi init --ssh RaduAvramescu/dotfiles
```

Without GitHub SSH access, use HTTPS:

```sh
chezmoi init RaduAvramescu/dotfiles
```

Review and apply only the Brewfile first. Installing its packages before
rendering all targets ensures that the Fish-dependent Ghostty and tmux templates
can resolve the Fish executable:

```sh
chezmoi diff "$HOME/Brewfile"
chezmoi apply "$HOME/Brewfile"
brew bundle --file="$HOME/Brewfile"
```

Then review and apply the remaining configuration:

```sh
chezmoi status
chezmoi diff
chezmoi apply
```

The final apply also installs the Tokyo Night tmux theme under
`~/.config/tmux/plugins/tokyo-night-tmux`.

Do not use `chezmoi init --apply` on a machine with existing dotfiles unless
the resulting changes have already been reviewed.

## Daily workflow

The Brewfile, Fish, Ghostty, and tmux source files are templates. Use
`chezmoi edit --apply` so chezmoi edits the source template and renders the
target:

```sh
chezmoi edit --apply ~/.config/fish/config.fish
```

The same command also works for non-template files. If a normal managed file is
edited directly in the home directory, copy it back into the source state with:

```sh
chezmoi re-add ~/.config/starship/starship.toml
```

`chezmoi re-add` does not update templates. Use `chezmoi edit` for the
Brewfile, Fish, Ghostty, and tmux targets.

After applying configuration changes:

- Open a new shell for Fish startup changes.
- Press `Ctrl+Shift+,` on Linux or `Cmd+Shift+,` on macOS to reload Ghostty.
- Run `tmux source-file ~/.config/tmux/tmux.conf` to reload tmux.
- Starship reads its TOML configuration when drawing the prompt.

The tmux theme external is checked for updates at most once per week. Force an
immediate refresh with:

```sh
chezmoi apply --refresh-externals=always ~/.config/tmux
```

Review and commit source changes with normal Git commands:

```sh
chezmoi status
chezmoi diff
chezmoi cd
git status
git add .
git commit
git push
exit
```

To inspect upstream changes before applying them:

```sh
chezmoi git pull -- --autostash --rebase
chezmoi diff
chezmoi apply
```

Once comfortable with the changes, `chezmoi update` combines the pull and
apply steps.

Refer to the official [command overview](https://www.chezmoi.io/user-guide/command-overview/)
and [daily operations guide](https://www.chezmoi.io/user-guide/daily-operations/)
for more details.
