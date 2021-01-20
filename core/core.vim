if &compatible
  " vint: -ProhibitSetNoCompatible
  set nocompatible
  " vint: +ProhibitSetNoCompatible
endif

" Set main configuration directory as parent directory
let $VIM_PATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH =
      \ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')

function! s:source_file(path, ...)
  " Source user configuration files with set/global sensitivity
  let use_global = get(a:000, 0, ! has('vim_starting'))
  let abspath = resolve($VIM_PATH . '/' . a:path)
  if ! use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  let tempfile = tempname()
  let content = map(readfile(abspath),
        \ "substitute(v:val, '^\\W*\\zsset\\ze\\W', 'setglobal', '')")
  try
    call writefile(content, tempfile)
    execute printf('source %s', fnameescape(tempfile))
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction

" " Enables 24-bit RGB color in the terminal
" if has('termguicolors')
"   if empty($COLORTERM) || $COLORTERM =~# 'truecolor\|24bit'
"     set termguicolors
"   endif
" endif

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

if has('vim_starting')
  " When using VIMINIT trick for exotic MYVIMRC locations, add path now.
  if &runtimepath !~# $VIM_PATH
    set runtimepath^=$VIM_PATH
    set runtimepath+=$VIM_PATH/after
  endif

  " Ensure data directories
  for s:path in [
        \ $DATA_PATH,
        \ $DATA_PATH . '/undo',
        \ $DATA_PATH . '/backup',
        \ $DATA_PATH . '/session',
        \ $VIM_PATH . '/spell' ]
    if ! isdirectory(s:path)
      call mkdir(s:path, 'p')
    endif
  endfor

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
endif

" Python interpreter settings
if has('pythonx')
  if has('python3')
    set pyxversion=3
  elseif has('python')
    set pyxversion=2
  endif
endif

call s:source_file('core/general.vim')
call s:source_file('core/filetype.vim')
call s:source_file('core/mappings.vim')

" Initialize plugin-manager and load plugins config files
call s:source_file('config/plugins.vim')
call s:source_file('config/keybinds.vim')

call theme#init()

set secure

