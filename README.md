# dotfiles

## Install

- Clone (or fork) this repo
- Install `zsh` if it is not installed
- Execute `tools/link.sh`
- Review `tools/install.sh`
- Execute `tools/install.sh`
- Create `.gitconfig.local` with your git settings
- _Optional_: create a new branch or fork for your modifications

**TL;DR**

Make sure `curl`, `git`, and `zsh` are installed as the scripts depend on them.

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kaykayehnn/dotfiles/master/tools/bootstrap.sh)"
```

**TL;DR if you don't like piping into sh**

```shell
git clone https://github.com/kaykayehnn/dotfiles ~/.dotfiles
cd ~/.dotfiles
# Install ZSH in case it is not already installed
# sudo apt install zsh
./tools/link.sh
./tools/install.sh
```
