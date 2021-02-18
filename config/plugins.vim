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
Plug 'pechorin/any-jump.vim'

" File Managers
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-mapping-project-top.vim'

" Git
Plug 'lambdalisue/gina.vim'

" Misc
Plug 'liuchengxu/vim-which-key'
Plug 'airblade/vim-rooter'

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


" fzf
" -----
let g:fzf_layout = { 'down': '~40%' }

" Completely delegate to ripgrep
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" vim-rooter
" -----
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_manual_only = 1
let g:rooter_patterns = [
			\ '=src',
			\ '.git/',
			\ 'README.*',
			\ 'node_modules/',
			\ 'pom.xml',
			\ 'env/',
			\ '.root',
			\ '.editorconfig',
			\ ]
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1
let g:rooter_cd_cmd = 'lcd'


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

" Gina
" -----

call gina#custom#command#alias('status', 'st')
call gina#custom#command#option('st', '-s')
call gina#custom#command#option('status', '-b')

" call gina#custom#command#option('/\v(status|branch|ls|grep|changes)', '--opener', 'botright 10split')
" call gina#custom#command#option('/\v(blame|diff|log)', '--opener', 'tabnew')
call gina#custom#command#option('commit', '--opener', 'below vnew')
call gina#custom#command#option('commit', '--verbose')

let s:width_quarter = string(winwidth(0) / 4)
let s:width_half = string(winwidth(0) / 2)

call gina#custom#command#option('blame', '--width', s:width_quarter)
let g:gina#command#blame#formatter#format = '%au: %su%= on %ti %ma%in'

" Open in vertical split
call gina#custom#command#option(
			\ '/\%(branch\|changes\|status\|grep\|log\|reflog\)',
			\ '--opener', 'split'
			\)

" Fixed medium width types
call gina#custom#execute(
			\ '/\%(changes\|status\|ls\)',
			\ 'vertical resize ' . s:width_half . ' | setlocal winfixwidth'
			\)

" Fixed small width special types
call gina#custom#execute(
			\ '/\%(branch\)',
			\ 'vertical resize ' . s:width_quarter . ' | setlocal winfixwidth'
			\)

" Alias 'p'/'dp' globally
call gina#custom#action#alias('/.*', 'dp', 'diff:preview')
call gina#custom#mapping#nmap('/.*', 'dp', ':<C-u>call gina#action#call(''dp'')<CR>', {'noremap': 1, 'silent': 1})
" call gina#custom#action#alias('/\%(blame\|log\)', 'preview', 'botright show:commit:preview')
call gina#custom#mapping#nmap('/.*', 'p',
			\ ':<C-u>call gina#action#call(''preview'')<CR>',
			\ {'noremap': 1, 'silent': 1, 'nowait': 1})

" Echo chunk info with K
call gina#custom#mapping#nmap('blame', 'K', '<Plug>(gina-blame-echo)')

" Blame mappings
let g:gina#command#blame#use_default_mappings = 0
call gina#custom#mapping#nmap('blame', '<Return>', '<Plug>(gina-blame-open)')
call gina#custom#mapping#nmap('blame', '<Backspace>', '<Plug>(gina-blame-back)')
call gina#custom#mapping#nmap('blame', '<C-r>', '<Plug>(gina-blame-C-L)')

" Dirty workaround to prevent overwrriting vim-tmux-navigator mappings
if match(&runtimepath, 'vim-tmux-navigator') != -1
	call gina#custom#mapping#nmap('status', '<C-j>', ':<C-u>TmuxNavigateDown<CR>')
	call gina#custom#mapping#nmap('status', '<C-k>', ':<C-u>TmuxNavigateUp<CR>')
endif


" WhichKey
" -----

call which_key#register('<Space>', 'g:which_key_map')
call which_key#register(';', 'g:which_key_localmap')
call which_key#register(']', 'g:which_key_rsbgmap')
call which_key#register('[', 'g:which_key_lsbgmap')
call which_key#register('d', 'g:which_key_dmap')
call which_key#register('s', 'g:which_key_smap')
call which_key#register('g', 'g:which_key_gmap')

augroup user_events
	autocmd! FileType which_key
	autocmd  FileType which_key set laststatus=0 noshowmode noruler
				\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

let g:which_key_timeout = 200
let g:which_key_exit = ["\<C-[>", "\<C-c>", "\<C-g>"]
let g:which_key_sep = '»'

let g:which_key_display_names = {
			\				' ': '␣',
			\		'<C-H>': '←',
			\		'<C-I>': '⇆',
			\		'<TAB>': '⇆',
			\ '<S-TAB>': 'S⇆',
			\		 '<CR>': '↵',
			\ }

let g:which_key_map = {
			\ 'name' : '+leader-key',
			\ '<CR>' : 'Toggle fold at current line',
			\ ';' : {
			\ 'name' : '+single-purpose',
			\ 'm' : 'Open clipboard register relative path as markdown',
			\ },
			\ '1' : 'Go to first tab',
			\ '5' : 'Go to previous tab',
			\ '9' : 'Go to last tab',
			\ 'f' : {
			\ 'name' : '+file-manager',
			\ 'D' : 'Delete current file',
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
			\ 'G' : 'Grep operator',
			\ 'i' : {
			\ 'name' : '+interface',
			\ 'd' : {
			\ 'name' : '+diff',
			\ 'd' : 'Diff unsaved changes',
			\ 'h' : 'Horizontal file diff split from current directory',
			\ 'H' : 'Horizontal file diff split from $HOME',
			\ 'v' : 'Vertical file diff split from current directory',
			\ 'V' : 'Vertical file diff split from $HOME',
			\ },
			\ },
			\ 'J' : 'Move line down',
			\ 'K' : 'Move line up',
			\ 'l' : {
			\ 'name' : '+languages',
			\ 'j' : {
			\ 'name' : '+java',
			\ 'c' : 'Javac compile',
			\ 'C' : 'Javac compile all from directory',
			\ 'j' : 'Save compile and run in next tmux pane',
			\ 'r' : 'Save compile and run Java in vim terminal',
			\ },
			\ 'g' : {
			\ 'name' : '+grammar',
			\ },
			\ 'm' : {
			\ 'name' : '+markdown',
			\ },
			\ 't' : {
			\ 'name' : '+tools',
			\ },
			\ },
			\ 'o' : {
			\ 'name' : '+open',
			\ 'g' : 'Open file in google chrome',
			\ 'o' : 'Open file with xdg',
			\ },
			\ 'q' : 'Adaptive buffer quit',
			\ 'Q' : 'Quit vim',
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
			\ 'L' : 'List sessions',
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
			\ 'name' : '+local-leader-key'	,
			\ 'o' : {
			\ 'name' : '+open',
			\ 'l'	: 'Toggle locationlist',
			\ 'q'	: 'Toggle quickfix',
			\ },
			\ 'q'		 : 'Toggle quickfix',
			\ 'r'		 : 'Quick run',
			\ 's' : {
			\ 'name' : '+ui-toggles',
			\ 'b' : 'Toggle dark/light background',
			\ 'e' : 'Conceal toggle',
			\ 'g' : 'Gutter toggle',
			\ 's' : 'Spell checker toggle',
			\ 't' : 'Tab char toggle',
			\ 'r' : 'Auto split resize toggle',
			\ 'v' : 'Virtualedit mode toggle',
			\ 'w' : 'Text wrap toggle',
			\ 'l' : {
			\ 'name' : '+cursor',
			\ 'c' : 'Cursorcolumn toggle',
			\ 'l' : 'Cursorline toggle',
			\ 'x' : 'Crosshair toggle',
			\ },
			\ },
			\ }

let g:which_key_lsbgmap = {
			\ 'name' : '+left-square-brackets',
			\ '[' : 'Prev function beginning',
			\ ']' : 'Prev function end',
			\ '=' : 'Marker any prev',
			\ '-' : 'Marker same prev',
			\ "'" : 'Marker unique prev',
			\ '"' : 'Comment prev',
			\ 'b' : 'Buffer prev',
			\ 'B' : 'Buffer first',
			\ 'c' : 'Diff jump prev',
			\ 'd' : 'Coc diagnostic prev',
			\ 'g' : 'Git prev chunk',
			\ 'l' : 'Locationlist prev',
			\ 'L' : 'Locationlist first',
			\ 't' : 'Tab prev',
			\ 'T' : 'Tab first',
			\ 'q' : 'Quickfix prev',
			\ 'Q' : 'Quickfix first',
			\ }

let g:which_key_rsbgmap = {
			\ 'name' : '+right-square-brackets',
			\ ']' : 'Next function beginning',
			\ '[' : 'Next function end',
			\ '=' : 'Marker any next',
			\ '-' : 'Marker same next',
			\ "'" : 'Marker unique next',
			\ '"' : 'Comment next',
			\ 'b' : 'Buffer next',
			\ 'B' : 'Buffer last',
			\ 'c' : 'Diff jump next',
			\ 'd' : 'Coc diagnostic next',
			\ 'g' : 'Git next chunk',
			\ 'l' : 'Locationlist next',
			\ 'L' : 'Locationlist last',
			\ 't' : 'Tab next',
			\ 'T' : 'Tab last',
			\ 'q' : 'Quickfix next',
			\ 'Q' : 'Quickfix last',
			\ }

let g:which_key_dmap = {
			\ 'name' : '+d-key',
			\ }

let g:which_key_gmap = {
			\ 'name' : '+g-key',
			\ 'p' : 'Select last pasted',
			\ }

let g:which_key_smap = {
			\ 'name' : '+s-key',
			\ }

let g:which_key_map['e'] = { 'name': '+file-explorer' }
let g:which_key_map['g'] = { 'name': '+git' }

let g:which_key_map['g']['D'] = ['GitOpenDirty', 'Open all dirty in splits']

filetype plugin indent on
syntax enable
