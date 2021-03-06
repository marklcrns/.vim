if &compatible
	" vint: -ProhibitSetNoCompatible
	set nocompatible
	" vint: +ProhibitSetNoCompatible
endif

" Set main configuration directory as parent directory
let $VIM_PATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')

" Disable vim distribution plugins
let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

" Initialize start up base requirements
if has('vim_starting')
	" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
	if &runtimepath !~# $VIM_PATH
		set runtimepath^=$VIM_PATH
		set runtimepath+=$VIM_PATH/after
	endif

	if &runtimepath !~# $LOCAL_VIM_PATH
		set runtimepath^=$LOCAL_VIM_PATH
		set runtimepath+=$LOCAL_VIM_PATH/after
	endif

	" Ensure data directories
	for s:path in [
				\ $DATA_PATH,
				\ $DATA_PATH . '/undo',
				\ $DATA_PATH . '/backup',
				\ $DATA_PATH . '/session',
				\ $VIM_PATH . '/spell' ]
		if ! isdirectory(s:path)
			call mkdir(s:path, 'p', 0770)
		endif
	endfor

	" Python interpreter settings
	if has('nvim')
		" Set python interpreter from a dedicated virtualenv created by generate_venv.sh
		let python = $DATA_PATH . '/venv/python/env/bin/python'
		let python3 = $DATA_PATH . '/venv/python3/env/bin/python3'
		if filereadable(python)
			let g:python_host_prog = python
		endif
		if filereadable(python3)
			let g:python3_host_prog = python3
		endif
	elseif has('pythonx')
		if has('python3')
			set pyxversion=3
		elseif has('python')
			set pyxversion=2
		endif
	endif

	" Enables 24-bit RGB color in the terminal
	if has('termguicolors')
		if empty($COLORTERM) || $COLORTERM =~# 'truecolor\|24bit'
			set termguicolors
		endif
	endif

	if ! has('nvim')
		set t_Co=256
		" Set Vim-specific sequences for RGB colors
		" Fixes 'termguicolors' usage in vim+tmux
		" :h xterm-true-color
		let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
		let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	endif

	" Set leader and localleader keys
	let g:mapleader="\<Space>"
	let g:maplocalleader=';'

	" Release keymappings prefixes, evict entirely for use of plug-ins.
	nnoremap <Space>  <Nop>
	xnoremap <Space>  <Nop>
	nnoremap ,        <Nop>
	xnoremap ,        <Nop>
	nnoremap ;        <Nop>
	xnoremap ;        <Nop>

	" Vim only, Linux terminal settings
	if ! has('nvim') && ! has('gui_running') && ! has('win32') && ! has('win64')
		call utils#source_file($VIM_PATH, 'core/terminal.vim')
	endif
endif

call utils#source_file($VIM_PATH, 'core/general.vim')
call utils#source_file($VIM_PATH, 'core/filetype.vim')
call utils#source_file($VIM_PATH, 'core/mappings.vim')

call utils#source_file($VIM_PATH,'config/plugins.vim')
call utils#source_file($VIM_PATH, 'config/keybinds.vim')

" Load custom status and tabline
if get(g:, 'custom_statusline_enable', 1)
	call utils#source_file($VIM_PATH, 'core/statusline.vim')
endif
if get(g:, 'custom_tabline_enable', 1)
	call utils#source_file($VIM_PATH, 'core/tabline.vim')
endif

call theme#init()
autocmd VimEnter,ColorScheme * call utils#source_file($VIM_PATH, 'core/colors.vim')

set secure
