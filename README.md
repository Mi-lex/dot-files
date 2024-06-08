# Configuration

## Configurable components

* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/)
* [tmux](https://github.com/tmux/tmux)
* [zohide](https://github.com/ajeetdsouza/zoxide)
* vim

Inspired by [how to store dot files tutorial](https://www.atlassian.com/git/tutorials/dotfiles)

## Usage
```shell
git clone --bare https://github.com/Mi-lex/dot-files.git $HOME/.cfg

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

config checkout
```
