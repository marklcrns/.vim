# .vim

More portable minimalist Vim configurations

## Installation

```bash
ln -s ~/.vim/.vimrc ~/.vimrc
```

## Sharing `.vimrc` with Neovim

Create `~/.config/nvim/init.vim` file and paste the following:

```bash
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
```

