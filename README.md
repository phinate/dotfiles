# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

Install GNU Stow:

```sh
# macOS
brew install stow

# Debian/Ubuntu
sudo apt install stow
```

## Structure

Each top-level directory is a stow "package" that mirrors the home directory structure:

```
.dotfiles/
├── claude/.claude/          -> ~/.claude/ (CLAUDE.md, settings.json)
├── nvim/.config/nvim/       -> ~/.config/nvim/
├── starship/.config/starship.toml -> ~/.config/starship.toml
├── wezterm/.wezterm.lua     -> ~/.wezterm.lua
└── zsh/.zshrc               -> ~/.zshrc
```

## Usage

Clone the repo and `cd` into it:

```sh
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
```

### Apply all packages

```sh
stow */
```

### Apply a single package

```sh
stow nvim
```

### Remove symlinks for a package

```sh
stow -D nvim
```

### Re-stow (remove then re-apply, useful after restructuring)

```sh
stow -R nvim
```

### Preview changes without applying (dry run)

```sh
stow -n -v nvim
```

## Notes

- Stow creates symlinks relative to the parent directory of the stow directory. Since this repo lives at `~/.dotfiles`, symlinks are created in `~`.
- If a target file already exists and is not a symlink managed by stow, stow will refuse to overwrite it. Back up or remove the existing file first.
- The `old/` directory is excluded from stow operations since it doesn't follow the stow package layout.
