# dotfiles

Personal configuration files managed with [chezmoi](https://www.chezmoi.io/).

## Managed files

- `~/Brewfile` on macOS only
- `~/.config/fish/config.fish`
- `~/.config/ghostty/config`
- `~/.config/MangoHud/MangoHud.conf` on Linux only
- `~/.config/mise/config.toml`
- `~/.config/mpv/input.conf` and `~/.config/mpv/mpv.conf`
- `~/.config/starship/starship.toml`
- `~/.config/tmux/tmux.conf`
- `~/.config/tmux/plugins/tokyo-night-tmux` as a chezmoi external

## Install chezmoi

On macOS, install Homebrew first, then install chezmoi:

```sh
brew install chezmoi
```

On Linux, install chezmoi through the distribution package manager. The
[Fedora post-installation setup](https://github.com/RaduAvramescu/fedora-postinstall)
installs it with DNF on Workstation or layers it with rpm-ostree on Silverblue.
Reboot after layering packages on Silverblue before applying the dotfiles.

Verify the installation without changing any dotfiles:

```sh
chezmoi --version
chezmoi doctor
```

See the official [chezmoi installation guide](https://www.chezmoi.io/install/)
for other platforms and installation methods.

## Platform packages

Homebrew is used only on macOS. The macOS Brewfile installs chezmoi, cosign,
mise, Bash, Fish, Starship, tmux, Ghostty, and the terminal fonts.

Linux does not manage a Brewfile or initialize Homebrew. Use distribution
packages or standalone installers for the tools you use. The Fedora setup
installs chezmoi, Fish, Starship, and JetBrains Mono Nerd Font; the Silverblue
setup also installs mise. Install mise separately on Workstation, and install
tmux and Ghostty separately if you use their managed configurations.

Fish adds `~/.local/bin` to `PATH` on both platforms so standalone tools such as
mise are available.

The account login shell does not need to be changed from Bash. Ghostty launches
Fish directly, and tmux uses Fish as its `default-shell`.

## Development tools

[mise](https://mise.jdx.dev/) manages the global Node.js LTS release and pnpm
11 on both macOS and Linux. Project-level mise configuration can override these
defaults, and existing `.nvmrc` files are recognized for Node.js version
selection.

pnpm's storage locations are left at their platform defaults. chezmoi adds the
default global executable directory to `PATH`:

- `$XDG_DATA_HOME/pnpm/bin` when `XDG_DATA_HOME` is set
- `~/Library/pnpm/bin` on macOS otherwise
- `~/.local/share/pnpm/bin` on Linux otherwise

List or install global packages with:

```sh
pnpm list --global --depth 0
pnpm add --global <package>
pnpm bin --global
```

Do not run `pnpm setup`; chezmoi manages the Fish environment and pnpm paths.

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

On macOS, review and apply only the Brewfile first. Installing its packages before
rendering all targets ensures that the Fish-dependent Ghostty and tmux templates
can resolve the Fish executable:

```sh
chezmoi diff "$HOME/Brewfile"
chezmoi apply "$HOME/Brewfile"
brew bundle --file="$HOME/Brewfile"
```

On Linux, install Fish and Starship before continuing, along with mise if you
use the development tool configuration. Skip the Brewfile commands above.

On either platform, review and apply the configuration:

```sh
chezmoi status
chezmoi diff
chezmoi apply
```

The final apply installs the Tokyo Night tmux theme under
`~/.config/tmux/plugins/tokyo-night-tmux` and writes the global mise
configuration. Install and verify the configured development tools:

```sh
mise install
mise doctor
mise ls --current
mise exec -- node --version
mise exec -- pnpm --version
```

Do not use `chezmoi init --apply` on a machine with existing dotfiles unless
the resulting changes have already been reviewed.

## Daily workflow

The Fish, Ghostty, and tmux source files are templates. Use
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
Fish, Ghostty, and tmux targets. The macOS Brewfile is a normal managed file.

After applying configuration changes:

- Open a new shell for Fish startup changes.
- Run `mise install` after changing `~/.config/mise/config.toml`.
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
