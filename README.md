# .vim

More portable Vim configs (mainly as a local user)

## Installation

Clone repository into `~/.vim`

```sh
git clone https://github.com/marklcrns/.vim ~/.vim
```

Then simply run `make` to install all the necessary dependencies and
directories.

```sh
cd ~/.vim

make
# or
make install
```


## Sharing `.vimrc` with Neovim

Create `~/.config/nvim/init.vim` file and paste the following:

```sh
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
```


## Installing latest Vim locally (without `sudo` permission)

First make sure to create, if not existing `~/.local` directory (or whichever
directory you want to install vim locally, e.g. `~/usr/local`)

```sh
git clone https://github.com/vim/vim.git

# Make sure the prefix flag points to your local installation directory of choice
./configure --prefix:$HOME/.local/ && make && make install

# Export path to local bin if not already
export PATH=$HOME/.local/bin:$PATH

# Set local vim as default editor
export VISUAL=$HOME/.local/bin/vim
export EDITOR=$VISUAL
```

Check for vim installation

```sh
vim --version
```

Done!

