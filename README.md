# Dotfiles

Personal configuration managed with Git and [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

- `ghostty`
- `nvim`
- `opencode`
- `tmux`
- `vim`
- `zsh`

Each package mirrors its destination path relative to `$HOME`. Stow keeps the
files in this repository and creates symlinks in the home directory.

## macOS Setup

Install Stow with Homebrew:

```sh
brew install stow
```

Clone the repository:

```sh
git clone git@github.com:Mi-lex/dot-files.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
```

Preview changes before creating symlinks:

```sh
stow --simulate --verbose --no-folding --target="$HOME" \
  ghostty nvim opencode tmux vim zsh
```

Install all packages:

```sh
stow --no-folding --target="$HOME" ghostty nvim opencode tmux vim zsh
```

Install or remove one package:

```sh
stow --no-folding --target="$HOME" nvim
stow --delete --target="$HOME" nvim
```

After adding, moving, or removing files in a package, refresh its symlinks:

```sh
stow --restow --no-folding --target="$HOME" nvim
```

## Secret Scanning

GitHub Actions runs Gitleaks against the full repository history on every push
and pull request.

Install the CLI on macOS:

```sh
brew install gitleaks
```

Scan the full history locally:

```sh
gitleaks git --redact .
```

Scan staged changes before committing:

```sh
gitleaks git --staged --redact .
```

## OpenCode

Run OpenCode from the repository root so it uses the dotfiles workspace rather
than the entire home directory:

```sh
opencode "$HOME/.dotfiles"
```
