# .vim

More portable minimalist Vim configurations

## Installation

Clone repository into `~/.vim`

```bash
git clone https://github.com/marklcrns/nvim-config ~/.vim
```

Then simply run `make` to install all the necessary dependencies and
directories.

```bash
cd ~/.vim

make
# or
make install
```


## Sharing `.vimrc` with Neovim

Create `~/.config/nvim/init.vim` file and paste the following:

```bash
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
```

