XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install: create-dirs symlink-vimrc

update: update-repo

create-dirs:
	@mkdir -vp "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo}

symlink-vimrc:
	ln -s "${HOME}/.vim/vimrc ${HOME}/.vimrc"

update-repo:
	git pull --ff --ff-only

clean:
	rm -rf "$(XDG_CACHE_HOME)/vim"

.PHONY: install create-dirs symlink-vimrc update-repo clean
