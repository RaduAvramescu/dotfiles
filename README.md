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

## Install chezmoi

This repository uses Homebrew, so the preferred installation is:

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

Review the proposed changes before applying them:

```sh
chezmoi status
chezmoi diff
```

Apply the Brewfile first, install its packages, and then apply all dotfiles:

```sh
chezmoi apply "$HOME/Brewfile"
brew bundle --file="$HOME/Brewfile"
chezmoi diff
chezmoi apply
```

Do not use `chezmoi init --apply` on a machine with existing dotfiles unless
the resulting changes have already been reviewed.

## Daily workflow

Edit a managed file in the source state and apply it immediately:

```sh
chezmoi edit --apply ~/.config/fish/config.fish
```

Alternatively, edit a normal file in the home directory and copy the change
back into the source state:

```sh
chezmoi re-add ~/.config/starship/starship.toml
```

`chezmoi re-add` does not update templates. Edit the Ghostty template with
`chezmoi edit` instead.

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
