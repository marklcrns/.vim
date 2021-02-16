" Set custom augroup
augroup user_events
	autocmd!
augroup END

" Specify a directory for plugins
call plug#begin($DATA_PATH . '/plugged')

" Make sure you use single quotes

" Syntax
" Plug 'dense-analysis/ale'

" Coding Utils
Plug 'sgur/vim-editorconfig'
Plug 'tpope/vim-repeat'
Plug 'tyru/caw.vim'
Plug 'machakann/vim-sandwich'
Plug 'Raimondi/delimitMate'
Plug 'pechorin/any-jump.vim', { 'on': 'AnyJump' }

" File Managers
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim', { 'on': ['Fern'] }
Plug 'lambdalisue/fern-git-status.vim', { 'on': ['Fern'] }
Plug 'lambdalisue/fern-mapping-project-top.vim', { 'on': ['Fern'] }

" Git
Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git', 'Gfetch', 'Gpush', 'Gstatus', 'Glog', 'Gclog', 'Gllog', 'Gdiffsplit', 'Gvdiffsplit'] }

" Misc
Plug 'liuchengxu/vim-which-key'

call plug#end()

" Auto install missing plugins
autocmd VimEnter *
			\  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
			\|   PlugInstall
			\| endif


" Fern
" -----

" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

augroup my-fern-hijack
  autocmd!
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction

let g:fern#renderer = "nerdfont"
let g:fern_git_status#disable_ignored = 1
let g:fern_git_status#disable_untracked = 1
let g:fern_git_status#disable_submodules = 1

" Custom settings and mappings.
let g:fern#disable_default_mappings = 1


function! s:init_fern() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer><expr>
        \ <Plug>(fern-my-expand-or-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-collapse)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer><nowait> h <Plug>(fern-action-collapse)
  nmap <buffer><nowait> l <Plug>(fern-my-expand-or-collapse)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
  nmap <buffer><nowait> c <Plug>(fern-action-copy)
  nmap <buffer><nowait> m <Plug>(fern-action-move)
  nmap <buffer><nowait> R <Plug>(fern-action-rename)
  nmap <buffer><nowait> N <Plug>(fern-action-new-path)
  nmap <buffer><nowait> D <Plug>(fern-action-remove)
  nmap <buffer><nowait> r <Plug>(fern-action-reload)
  nmap <buffer><nowait> C <Plug>(fern-action-clipboard-copy)
  nmap <buffer><nowait> M <Plug>(fern-action-clipboard-move)
  nmap <buffer><nowait> P <Plug>(fern-action-clipboard-paste)
  nmap <buffer><nowait> s <Plug>(fern-action-open:split)
  nmap <buffer><nowait> gs <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer><nowait> v <Plug>(fern-action-open:vsplit)
  nmap <buffer><nowait> gv <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer><nowait> H <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> L <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> J <Plug>(fern-action-mark:toggle)j
  nmap <buffer><nowait> K <Plug>(fern-action-mark:toggle)k
  nmap <buffer><nowait> , <Plug>(fern-action-hidden:toggle)
  " Note: Requires lambdalisue/fern-mapping-project-top.vim
  nmap <buffer><nowait> ^ <Plug>(fern-action-project-top:reveal)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
  " Startup workaround
  autocmd FileType fern call fern_git_status#init()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern,startify call glyph_palette#apply()
augroup END


" ale
" -----

let g:ale_set_balloons = 1
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
set omnifunc=ale#completion#OmniFunc

" vim-editorconfig
" -----

let g:editorconfig_verbose = 1
let g:editorconfig_blacklist = {
			\ 'filetype': [
			\   'git.*', 'fugitive', 'help', 'defx', 'denite.*', 'startify',
			\   'dashboard', 'vista.*', 'tagbar', 'lsp-.*', 'clap_.*', 'any-jump',
			\   'gina-.*'
			\  ],
			\ 'pattern': ['\.un~$']
			\ }

" deliMitmate
" -----

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_jump_expansion = 1
let g:delimitMate_smart_quotes = 1
let g:delimitMate_matchpairs = "(:),[:],{:}"

" any-jump
" -----

let g:any_jump_disable_default_keybindings = 1
let g:any_jump_window_width_ratio  = 0.8
let g:any_jump_window_height_ratio = 0.8
let g:any_jump_window_top_offset   = 5
let g:any_jump_search_prefered_engine = 'rg'

" WhichKey
" -----

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
			\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:which_key_map = {
			\ 'name' : '+leader-key',
			\ '<CR>' : 'Toggle fold at current line',
			\ '/' : {
			\ 'name' : '+commenter',
			\ '/' : 'Comment toggle',
			\ 'a' : 'Comment line/selected end',
			\ 'b' : 'Comment box',
			\ 'c' : 'Comment line/selected',
			\ 'i' : 'Comment line/selected beginning',
			\ 'j' : 'Jump next comment',
			\ 'k' : 'Jump Prev comment',
			\ 'w' : 'Comment wrap toggle',
			\ },
			\ '1' : 'Go to first tab',
			\ '5' : 'Go to previous tab',
			\ '9' : 'Go to last tab',
			\ 'a' : {
			\ 'name' : '+any-jump',
			\ 'b' : 'Open previously opened file',
			\ 'j' : 'Open jump to definition window',
			\ 'l' : 'Open last jump to definition result',
			\ },
			\ 'f' : {
			\ 'name' : '+file-management',
			\ 'D' : "Delete current file",
			\ 'g' : 'Vimgrep (project-wide) and load into quickfix',
			\ 'q' : 'Save and quit',
			\ 'Q' : 'Save all and quit',
			\ 'r' : {
			\ 'name' : '+change-directory',
			\ 'r' : 'Change working directory to root',
			\ 'd' : 'Change working directory to current file',
			\ 'l' : 'Change working directory to current file (window only)',
			\ },
			\ 's' : 'Save buffer',
			\ 'S' : 'Save all buffers',
			\ 'w' : 'Wipe buffer',
			\ 'y' : {
			\ 'name' : '+yank-path',
			\ 'e' : 'Yank absolute file path without extension',
			\ 'E' : 'Yank relative file path without extension',
			\ 'p' : 'Yank absolute file path',
			\ 'P' : 'Yank relative file path',
			\ 'f' : 'Yank file name without extension',
			\ 'F' : 'Yank file name',
			\ 'd' : 'Yank absolute directory path',
			\ 'D' : 'Yank relative directory path',
			\ 'o' : 'Open/Create file from yanked path',
			\ 'x' : 'Yank file extension only',
			\ },
			\ },
			\ 'g' : {
			\ 'name' : '+git-operate',
			\ 'd' : {
			\ 'name' : '+git-diff',
			\ 'c' : 'Git diff cached',
			\ 'd' : 'Git diff',
			\ 's' : 'Git diffsplit',
			\ 't' : 'Git difftool',
			\ 'h' : 'Git diffsplit horizontal',
			\ 'v' : 'Git diffsplit vertical',
			\ },
			\ 'D' : 'Git open all dirty files (uncommited) in H splits',
			\ 'F' : 'Git fetch',
			\ 'g' : 'Ggrep {word}',
			\ 'G' : 'Git log grep current file',
			\ 'l' : 'Git log quickfix',
			\ 'L' : 'Git log current file quickfix',
			\ 'p' : 'Git push',
			\ 'P' : 'Terminal git push',
			\ 's' : 'Git status',
			\ 'v' : 'Git commit browser',
			\ },
			\ 'G' : 'Grep operator',
			\ 'J' : 'Move line down',
			\ 'K' : 'Move line up',
			\ 'o' : {
			\ 'name' : '+open',
			\ 'g' : 'Open file in google chrome',
			\ 'o' : 'Open file with xdg',
			\ },
			\ 'q' : 'Adaptive buffer quit',
			\ 'Q' : 'Quit neovim',
			\ 'r' : {
			\ 'name' : '+text-manipulate',
			\ ' ' : 'Remove whitespaces',
			\ 'c' : 'Lowercase entire file (or selected lines)',
			\ 'C' : 'Capitalize entire file (or selected lines)',
			\ 'e' : {
			\ 'name' : '+register',
			\ 'g' : 'display-register(+abjk)',
			\ 'j' : 'Cycle forward (copy selected if visual)',
			\ 'J' : 'Paste cycle forward',
			\ 'k' : 'Cycle backward (copy selected if visual)',
			\ 'K' : 'Paste cycle backward',
			\ },
			\ 'F' : 'Search and replace confirmation last selected',
			\ 'i' : 'Fix indentation',
			\ 'l' : 'Enumerate selected lines (visual)',
			\ 'L' : 'Enumerate entire file',
			\ 'n' : 'Search forward and replace',
			\ 'N' : 'Search backward and replace',
			\ 'p' : 'Duplicate paragraph',
			\ 'r' : 'Search and replace',
			\ 'R' : 'Search and replace current line',
			\ 'w' : 'Wrap paragraph to textwidth',
			\ 'y' : {
			\ 'name' : '+yank-text',
			\ 'a' : 'Yank all file content',
			\ 'p' : 'Replace all with yanked texts',
			\ },
			\ },
			\ 's' : {
			\ 'name' : '+sessions',
			\ 'l' : 'Load session {session-name}',
			\ 's' : 'Save session {session-name}',
			\ 'u' : 'Detach session (save session and detach)',
			\ 'q' : 'Close session (save session, detach, and close all buffers)',
			\ },
			\ 't' : {
			\ 'name' : '+tab-operate',
			\ 'n' : 'New tab',
			\ 'e' : 'Tab edit ',
			\ 'm' : 'Move tab',
			\ 'q' : 'Close current tab',
			\ },
			\ }

let g:which_key_localmap = {
			\ 'name' : '+local-leader-key'  ,
			\ 'l'    : 'toggle-locationlist',
			\ 'q'    : 'Toggle quickfix',
			\ 'r'    : 'Quick run',
			\ 's' : {
			\ 'name' : '+ui-toggles',
			\ 'b' : 'Toggle dark/light background',
			\ 'e' : 'Conceal toggle',
			\ 'i' : 'Indent guide toggle',
			\ 't' : 'Tab char toggle',
			\ 'v' : 'Virtualedit mode toggle',
			\ 'w' : 'Text wrap toggle',
			\ },
			\ }

let g:which_key_lsbgmap = {
			\ 'name' : '+left-square-brackets',
			\ 'b' : 'Buffer prev',
			\ 'B' : 'Buffer first',
			\ 'c' : 'Diff jump prev',
			\ 'l' : 'Locationlist prev',
			\ 'L' : 'Locationlist first',
			\ 't' : 'Tab prev',
			\ 'T' : 'Tab first',
			\ 'q' : 'Quickfix prev',
			\ 'Q' : 'Quickfix first',
			\ }

let g:which_key_rsbgmap = {
			\ 'name' : '+right-square-brackets',
			\ 'b' : 'Buffer next',
			\ 'B' : 'Buffer last',
			\ 'c' : 'Diff jump next',
			\ 'l' : 'Locationlist next',
			\ 'L' : 'Locationlist last',
			\ 't' : 'Tab next',
			\ 'T' : 'Tab last',
			\ 'q' : 'Quickfix next',
			\ 'Q' : 'Quickfix last',
			\ }

let g:which_key_timeout = 200
let g:which_key_exit = ["\<C-[>", "\<C-c>", "\<C-g>"]

let g:which_key_display_names = {
			\       ' ': 'SPC',
			\   '<C-H>': 'BS',
			\   '<C-I>': 'TAB',
			\   '<TAB>': 'TAB',
			\ '<S-TAB>': 'S-TAB',
			\    '<CR>': 'ENTER',
			\ }

call which_key#register('<Space>', 'g:which_key_map')
call which_key#register(';', 'g:which_key_localmap')
call which_key#register(']', 'g:which_key_rsbgmap')
call which_key#register('[', 'g:which_key_lsbgmap')
call which_key#register('d', 'g:which_key_dmap')
call which_key#register('s', 'g:which_key_smap')
call which_key#register('g', 'g:which_key_gmap')

filetype plugin indent on
syntax enable
