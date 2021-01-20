if has('vim_starting')
  filetype plugin indent on
  syntax enable
endif

" Specify a directory for plugins
call plug#begin($DATA_PATH . '/plugged')

" Make sure you use single quotes

" For nvim plugins
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Coding Utils
Plug 'sgur/vim-editorconfig'
Plug 'tpope/vim-repeat'
Plug 'tyru/caw.vim'
Plug 'machakann/vim-sandwich'
Plug 'Raimondi/delimitMate'

" UI
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'lambdalisue/fern.vim', { 'on': 'Fern' }
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-mapping-project-top.vim'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

call plug#end()

" Auto install missing plugins
autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall
  \| endif


" coc
" -----

" CoC config
let g:coc_status_error_sign = ''
let g:coc_status_warning_sign = ' '
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-css',
      \ 'coc-tsserver',
      \ 'coc-git',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-python',
      \ 'coc-ultisnips',
      \ 'coc-sh',
      \ 'coc-yank',
      \ ]

augroup CocAutoCmd
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end


" Ref: https://stackoverflow.com/a/61275100/11850077
"      https://github.com/vim/vim/issues/2004#issuecomment-324357529
function! IntegratedCocTab() abort
  " First, try to expand or jump on UltiSnips.
  let snippet = UltiSnips#ExpandSnippet()
  if g:ulti_expand_res > 0
    return snippet
  endif
  " Then, check if we're in a completion menu
  if pumvisible()
    return coc#_select_confirm()
  endif
  " Finally, do regular tab if no trigger
  return "\<Tab>"
endfunction

" Integration with delimitMate and Ultisnips
autocmd FileType * inoremap <silent> <Tab>
      \ <C-R>=IntegratedCocTab()<CR>
" Integration with delimitMate plugin. Also ignores completion.
inoremap <silent><expr> <CR>
      \ delimitMate#WithinEmptyPair() ?
      \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
      \ pumvisible() ? "\<C-]>\<CR>" : "\<C-g>u\<CR>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold   :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

" UltiSnips
" -----

" Let coc.nvim coc-ultisnips plugin handle the expand trigger mapping
" See coc configs
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
let g:UltiSnipsSnippetDirectories = [
      \ $DATA_PATH . "/dein/repos/github.com/honza/vim-snippets/UltiSnips",
      \ $VIM_PATH . "/UltiSnips"
      \ ]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit = "vertical"

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

" vim-clap
" -----

let g:clap_cache_directory = $DATA_PATH . '/clap'
let g:clap_disable_run_rooter = v:false
let g:clap_theme = 'atom_dark'
let g:clap_current_selection_sign= { 'text': '➤', 'texthl': "ClapCurrentSelectionSign", "linehl": "ClapCurrentSelection"}
let g:clap_layout = { 'relative': 'editor' }
let g:clap_enable_icon = 1
let g:clap_search_box_border_style = 'curve'
let g:clap_provider_grep_executable = 'rg'
let g:clap_provider_grep_opts = '-H --hidden --no-heading --smart-case --vimgrep -g "!.git/" -g "!node_modules/"'
let g:clap_provider_grep_enable_icon = 1
let g:clap_prompt_format = '%spinner%%forerunner_status% %provider_id%:'

" A function to config highlight of ClapSymbol
" when the background color opaque
function! s:ClapSymbolHL() abort
  let s:current_bgcolor = synIDattr(hlID("Normal"), "bg")
  if s:current_bgcolor == ''
    hi ClapSymbol guibg=NONE ctermbg=NONE
  endif
endfunction

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
  autocmd FileType fern call glyph_palette#apply()
augroup END

" WhichKey
" -----

augroup user_events
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

call which_key#register('<Space>', 'g:which_key_map')
call which_key#register(';', 'g:which_key_localmap')
call which_key#register(']', 'g:which_key_rsbgmap')
call which_key#register('[', 'g:which_key_lsbgmap')
call which_key#register('d', 'g:which_key_dmap')
call which_key#register('s', 'g:which_key_smap')
call which_key#register('g', 'g:which_key_gmap')

let g:which_key_map = {
    \ 'name' : '+leader-key',
    \ '<CR>' : 'Toggle fold at current line',
       \ '-' : 'Choose window' ,
       \ '_' : 'Choose window to swap with' ,
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
    \ 'c' : {
          \ 'name' : '+coc',
             \ 'a' : 'Code action text object',
             \ 'c' : 'Code action current word',
             \ 'C' : 'Open coc config',
             \ 'F' : 'Coc format',
             \ 'g' : {
                   \ 'name' : '+coc-git',
                   \ 'b' : 'Preview line in git browser',
                   \ 'B' : 'Copy line git url to clipboard',
                   \ 'c' : 'Coc show last commit of current line',
                   \ 'd' : 'Git diff cached',
                   \ 'f' : 'Toggle fold all except git chunks',
                   \ 'i' : 'Preview git chunk under cursor',
                   \ 's' : 'Coc list status changes',
                   \ 't' : 'Stage git chunk under cursor',
                   \ 'u' : 'Undo git chunk changes under cursor',
                  \ },
             \ 'j' : 'Coc list next',
             \ 'k' : 'Coc list prev',
             \ 'l' : {
                   \ 'name' : '+coc-list',
                     \ 'c' : 'Coc commands',
                     \ 'd' : 'Coc diagnostics',
                     \ 'e' : 'Coc extensions',
                     \ 'm' : 'Coc marketplace',
                     \ 'o' : 'File outline',
                     \ 'r' : 'Resume last coc list',
                     \ 's' : 'Search workspace symbols',
                     \ 'w' : 'Coc rgrep selected word or motion',
                     \ 'W' : 'Coc grep cursor word in buffer',
                     \ 'y' : 'Coc yank list',
                   \ },
            \ 'n' : 'Coc rename variable under cursor',
            \ 'r' : 'Coc refactor word under cursor',
            \ 's' : 'Coc search {prompt}',
            \ 'S' : 'Coc search word match {prompt}',
            \ 't' : {
                  \ 'name' : '+coc-toggles',
                  \ 'g' : 'Toggle coc git gutter',
                  \ },
            \ 'q' : 'Coc autofix current line',
            \ 'x' : 'Coc cursors operate',
            \ },
    \ 'e' : {
          \ 'name' : '+file-explorer',
             \ 'a' : 'Toggle explorer to current file',
             \ 'c' : 'Toggle coc explorer',
             \ 'e' : 'Toggle explorer to current directory',
             \ 'r' : 'Toggle explorer resume directory',
          \ },
    \ 'f' : {
          \ 'name' : '+file-management',
          \ 'D' : "Delete current file",
          \ 'd' : {
                \ 'name' : '+file-finder',
                \ ':' : 'Find on command history',
                \ 'b' : 'Find on buffers',
                \ 'c' : 'Find colorscheme',
                \ 'f' : 'Find files on directory',
                \ 'F' : 'Find files on directory (includes hidden files)',
                \ 'g' : 'Find git files',
                \ 'h' : 'Find on history',
                \ 'l' : 'Find on locationlist',
                \ 'm' : 'Find files with marks',
                \ 'o' : 'Find old files',
                \ 'p' : 'Find personal configurations',
                \ 'r' : 'Find word with grep2',
                \ 'R' : 'Find word relative to current file directory',
                \ 's' : 'Find sessions',
                \ 'u' : 'Find git diff files',
                \ 'v' : 'Find last visual selection with Grep',
                \ 'w' : 'Find word undercursor with Grep',
                \ },
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
            \ 's' : 'Subvert line /{pat}/{sub}/[flags]',
            \ 'S' : 'Subvert entire /{pat}/{sub}/[flags]',
            \ 't' : 'Thesaurus current word' ,
            \ 'w' : 'Wrap paragraph to textwidth',
            \ 'y' : {
                  \ 'name' : '+yank-text',
                  \ 'a' : 'Yank all file content',
                  \ 'p' : 'Replace all with yanked texts',
                  \ },
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
               \ 'e' : 'Conceal toggle',
               \ 'i' : 'Indent guide toggle',
               \ 's' : 'Spell checker toggle',
               \ 'v' : 'Virtualedit mode toggle',
               \ 'w' : 'Text wrap toggle',
            \ },
      \ }

let g:which_key_lsbgmap = {
      \ 'name' : '+left-square-brackets',
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

let g:which_key_gmap = {
      \ 'name' : '+g-key',
      \ 'd' : 'Go to definition',
      \ 'i' : 'Go to implementation',
      \ 'p' : 'Select last pasted',
      \ 'r' : 'Go to reference',
      \ 'y' : 'Go to type definition',
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

