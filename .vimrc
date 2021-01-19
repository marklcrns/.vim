" ==================== General Settings ==================== "

filetype plugin indent on

" Only enable syntax when vim is starting
if has('vim_starting')
  syntax enable
endif

set background=dark
source ~/.vim/gruvbox.vim

" General {{{
set mouse=nv                 " Disable mouse in command-line mode
set report=0                 " Don't report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path+=**                 " Directories to search when using gf and friends
set isfname-==               " Remove =, detects filename in var=/foo/bar
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=2500           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set formatoptions-=o         " Disable comment-continuation (normal 'o'/'O')
if has('patch-7.3.541')
  set formatoptions+=j       " Remove comment leader when joining lines
endif

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

" What to save for views and sessions:
set viewoptions=folds,cursor,curdir,slash,unix
set sessionoptions=curdir,help,tabpages,winsize

if has('mac')
  let g:clipboard = {
        \   'name': 'macOS-clipboard',
        \   'copy': {
        \      '+': 'pbcopy',
        \      '*': 'pbcopy',
        \    },
        \   'paste': {
        \      '+': 'pbpaste',
        \      '*': 'pbpaste',
        \   },
        \   'cache_enabled': 0,
        \ }
endif

if has('clipboard')
  set clipboard& clipboard+=unnamedplus
endif

" Wildmenu {{{
" --------
if has('wildmenu')
  if ! has('nvim')
    set wildmode=list:longest
  endif

  " if has('nvim')
  "   set wildoptions=pum
  " else
  "   set nowildmenu
  "   set wildmode=list:longest,full
  "   set wildoptions=tagfile
  " endif
  set wildignorecase
  set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
  set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
  set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
  set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
  set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
  set wildcharm=<C-z>  " substitue for 'wildchar' (<Tab>) in macros
endif
" }}}

" Vim Directories {{{
" ---------------
set nobackup
set nowritebackup
set undofile noswapfile
set directory=$DATA_PATH/swap//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set undodir=$DATA_PATH/undo//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set backupdir=$DATA_PATH/backup/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set viewdir=$DATA_PATH/view/
" Use the coc-spell-checker to do this
" set spellfile=$VIM_PATH/spell/en.utf-8.add

" History saving
set history=2000

if has('nvim') && ! has('win32') && ! has('win64')
  set shada=!,'300,<50,@100,s10,h
else
  set viminfo='300,<10,@50,h,n$DATA_PATH/viminfo
endif

augroup user_persistent_undo
  autocmd!
  au BufWritePre /tmp/*          setlocal noundofile
  au BufWritePre COMMIT_EDITMSG  setlocal noundofile
  au BufWritePre MERGE_MSG       setlocal noundofile
  au BufWritePre *.tmp           setlocal noundofile
  au BufWritePre *.bak           setlocal noundofile
augroup END

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)

  set noswapfile
  set nobackup
  set noundofile
  if has('nvim')
    set shada="NONE"
  else
    set viminfo="NONE"
  endif
endif

" Secure sensitive information, disable backup files in temp directories
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
  set backupskip+=.vault.vim
endif

" Disable swap/undo/viminfo/shada files in temp directories or shm
augroup user_secure
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
        \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=
augroup END

" }}}

" Tabs and Indents {{{
" ----------------
set textwidth=80    " Text width maximum chars before wrapping
set expandtab       " Expand tabs to spaces
set tabstop=2       " The number of spaces a tab is
set shiftwidth=2    " Number of spaces to use in auto(indent)
set softtabstop=-1  " Automatically keeps in sync with shiftwidth
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

if exists('&breakindent')
  set breakindentopt=shift:2,min:20
endif

" }}}

" Timing {{{
" ------
set timeout ttimeout
set timeoutlen=500   " Time out on mappings
set ttimeoutlen=10   " Time out on key codes
set updatetime=100   " Idle time to write swap and trigger CursorHold
set redrawtime=1500  " Time in milliseconds for stopping display redraw

" }}}

" Searching {{{
" ---------
set ignorecase    " Search ignoring case
set smartcase     " Keep case when searching with *
set infercase     " Adjust case in insert completion mode
set incsearch     " Incremental search
set wrapscan      " Searches wrap around the end of the file
set hlsearch      " Highlight search results

set complete=.,w,b,k  " C-n completion: Scan buffers, windows and dictionary

if exists('+inccommand')
  set inccommand=split
endif

if executable('rg')
  set grepformat=%f:%l:%m
  let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
elseif executable('ag')
  set grepformat=%f:%l:%m
  let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
endif

" }}}

" Behavior {{{
" --------
set autoread                    " Auto readfile
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \ ;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=useopen           " Jump to the first open window
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore whitespace
set completeopt=menu,menuone    " Always show menu, even for one item
set completeopt+=noselect,noinsert

if exists('+completepopup')
  set completeopt+=popup
  set completepopup=height:4,width:60,highlight:InfoPopup
endif

" Use the new Neovim :h jumplist-stack
if has('nvim-0.5')
  set jumpoptions=stack
endif

if has('patch-8.1.0360') || has('nvim-0.4')
  set diffopt+=internal,algorithm:patience
  " set diffopt=indent-heuristic,algorithm:patience
endif
" }}}

" Editor UI {{{
set number              " Show number
set relativenumber      " Show relative number
set noshowmode          " Don't show mode on bottom
set noruler             " Disable default status ruler
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=5     " Keep at least 5 lines left/right
set fillchars+=vert:\|  " add a bar for vertical splits
set list
let &showbreak='↳  '
set listchars=tab:\▏\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·
set title
" Title length.
set titlelen=95
" Title string.
let &g:titlestring="
      \ %{expand('%:p:~:.')}%(%m%r%w%)
      \ %<\[%{fnamemodify(getcwd(), ':~')}\] - Neovim"

set showmatch           " Jump to matching bracket
set matchpairs+=<:>     " Add HTML brackets to pair matching
set matchtime=1         " Tenths of a second to show the matching paren

set showtabline=2       " Always show the tabs line
set winwidth=30         " Minimum width for active window
set winminwidth=10      " Minimum width for inactive windows
" set winheight=4         " Minimum height for active window
set winminheight=1      " Minimum height for inactive window
set pumheight=15        " Pop-up menu's line height
set helpheight=12       " Minimum help window height
set previewheight=12    " Completion preview height

set showcmd             " Show command in status line
set cmdheight=2         " Height of the command line
set cmdwinheight=5      " Command-line lines
set noequalalways       " Don't resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=+0      " Column highlight at textwidth's max character-limit
set display=lastline

if has('folding') && has('vim_starting')
  set foldenable
  set foldmethod=indent
  set foldlevelstart=99
endif

if has('nvim-0.4')
  set signcolumn=auto:1
elseif exists('&signcolumn')
  set signcolumn=auto
endif

if has('conceal') && v:version >= 703
  " For snippet_complete marker
  set conceallevel=2
  " set concealcursor=niv
endif

if exists('+previewpopup')
  set previewpopup=height:10,width:60
endif

" Pseudo-transparency for completion menu and floating windows
if has('termguicolors') && &termguicolors
  if exists('&pumblend')
    set pumblend=10
  endif
  if exists('&winblend')
    set winblend=10
  endif
endif
" }}}


" ==================== Mappings ==================== "

let mapleader = ' '
let maplocalleader = ';'


" BASIC MAPPINGS -------------------- {{{
function! ExitMappings()
  " Quit without saving
  nnoremap <silent> <Leader>q :silent q!<CR>
  xnoremap <silent> <Leader>q <Esc>:silent q!<CR>
  " Quit all without saving
  nnoremap <silent> <Leader>Q :silent qa!<CR>
  xnoremap <silent> <Leader>Q <Esc>:silent qa!<CR>
  " Write/Save buffer
  nnoremap <silent> <leader>fs :silent w<bar>echo "buffer saved!"<CR>
  xnoremap <silent> <leader>fs <Esc>:silent w<bar>echo "buffer saved!"<<CR>
  " Write/Save all buffer
  nnoremap <silent> <leader>fS :silent wa<bar>echo "all buffer saved!"<CR>
  xnoremap <silent> <leader>fS <Esc>:silent wa<bar>echo "all buffer saved!"<CR>
  " Save and quit
  nnoremap <silent> <leader>fq :silent wq!<CR>
  xnoremap <silent> <leader>fq <Esc>:silent wq!<CR>
  " Wipe buffer
  nnoremap <silent> <leader>fw :bw<bar>echo "buffer wiped!"<CR>
  xnoremap <silent> <leader>fw :<Esc>bw<bar>echo "buffer wiped!"<CR>
  " Save all and quit
  nnoremap <leader>fQ :confirm wqa!<CR>
  xnoremap <leader>fQ :<Esc>confirm wqa!<CR>
endfunction

function! ImprovedDefaultMappings()
  " Prevent x from overriding what's in the clipboard.
  noremap x "_x
  noremap X "_X
  " Prevent selecting and pasting from overwriting what you originally copied.
  xnoremap p pgvy
  " Re-select blocks after indenting in visual/select mode
  xnoremap < <gv
  xnoremap > >gv|
  " Keep cursor at the bottom of the visual selection after you yank it.
  vnoremap y ygv<Esc>
  " Fixes `[c` and `]c` not working
  nnoremap [c [c
  nnoremap ]c ]c
  " Scroll step sideways
  nnoremap zl z4l
  nnoremap zh z4h
  " Open file under the cursor in a vsplit
  nnoremap gf :vertical wincmd f<CR>
  " The plugin rhysd/accelerated-jk moves through display-lines in normal mode,
  " these mappings will move through display-lines in visual mode too.
  vnoremap j gj
  vnoremap k gk

  " DISABLE: Conflict with rhysd/accelerated-jk
  " " Makes Relative Number jumps work with text wrap
  " noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
  " noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
  " vnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
  " vnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

  " Improve scroll, credits: https://github.com/Shougo
  noremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
        \ 'zt' : (winline() == 1) ? 'zb' : 'zz'
  noremap <expr> <C-f> max([winheight(0) - 2, 1])
        \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
  noremap <expr> <C-b> max([winheight(0) - 2, 1])
        \ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
  noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
  noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")
  " Closing pop-up auto-completion before inserting new line in insert mode
  inoremap <expr> <M-o> (pumvisible() <bar><bar> &insertmode) ? '<C-e><C-o>o' : '<C-o>o'
  inoremap <expr> <M-O> (pumvisible() <bar><bar> &insertmode) ? '<C-e><C-O>O' : '<C-O>O'
endfunction

function! ExtendedBasicMappings()
  " Remaps macro record key since q has been remapped
  nnoremap Q q
  " Disables esc key on some modes to force new habit
  " Allow <Esc> to exit terminal-mode back to normal:
  tnoremap <Esc> <C-\><C-n>
  " Esc from insert, visual and command mode shortcuts (also moves cursor to the right)
  inoremap fd <Esc>`^
  inoremap kj <Esc>`^
  vnoremap fd <Esc>`<
  vnoremap df <Esc>`>
  cnoremap <C-[> <C-c>
  cnoremap <C-g> <C-c>
  " Exit from terminal-mode to normal
  tnoremap <Esc> <C-\><C-n>
  " Insert actual tab instead of spaces. Useful when `expandtab` is in use
  inoremap <S-Tab> <C-v><Tab>
  " Yank to end
  nnoremap Y y$
	" Easier line-wise movement
	nnoremap gh g^
	nnoremap gl g$
  " Jump entire buffers in jumplist
  nnoremap g<C-i> :<C-u>call JumpBuffer(-1)<CR>
  nnoremap g<C-o> :<C-u>call JumpBuffer(1)<CR>
  " Insert newline below
  inoremap <S-CR> <C-o>o
  " Resize tab windows after top/bottom window movement
  nnoremap <C-w>K <C-w>K<C-w>=
  nnoremap <C-w>J <C-w>J<C-w>=
  " Select last paste
  nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'
  " Increment/Decrement next searcheable number by one. Wraps at end of file.
  function! AddSubtract(char, back)
    let pattern = &nrformats =~ 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
    call search(pattern, 'cw' . a:back)
    execute 'normal! ' . v:count1 . a:char
    silent! call repeat#set(":\<C-u>call AddSubtract('" .a:char. "', '" .a:back. "')\<CR>")
  endfunction
  nnoremap <silent> <M-a> :<C-u>call AddSubtract("\<C-a>", '')<CR>
  nnoremap <silent> <M-x> :<C-u>call AddSubtract("\<C-x>", '')<CR>
  " Increment/Decrement previous searcheable number by one. Wraps at start of file.
  nnoremap <silent> <M-S-a> :<C-u>call AddSubtract("\<C-a>", 'b')<CR>
  nnoremap <silent> <M-S-x> :<C-u>call AddSubtract("\<C-x>", 'b')<CR>
endfunction
" }}} BASIC MAPPINGS

" OPERATOR MAPPINGS -------------------- {{{
function! OperatorMappings()
  " Inside next and last parenthesis
  onoremap in( :<C-u>normal! f(vi(<CR>
  onoremap il( :<C-u>normal! F)vi(<CR>
  " Around next and last parenthesis
  onoremap an( :<C-u>normal! f(va(<CR>
  onoremap al( :<C-u>normal! F)va(<CR>
endfunction
" }}} OPERATOR MAPPINGS

" FILE AND WINDOWS MAPPINGS -------------------- {{{
function! FilePathMappings()
  " Resources: https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
  " Yank buffer's absolute path without file extension to '+' clipboard
  nnoremap <Leader>fye :let @+=expand("%:p:r")<bar>echo 'Yanked absolute file path without extension'<CR>
  " Yank buffer's relative path without file extension to '+' clipboard
  nnoremap <Leader>fyE :let @+=expand("%:r")<bar>echo 'Yanked relative file path without extension'<CR>
  " Yank buffer's absolute file path to '+' register
  nnoremap <Leader>fyp :let @+=expand("%:p")<bar>echo 'Yanked absolute file path'<CR>
  " Yank buffer's relative file path to '+' register
  nnoremap <Leader>fyP :let @+=expand("%:~:.")<bar>echo 'Yanked relative file path'<CR>
  " Yank buffer file name without extension to '+' register
  nnoremap <Leader>fyf :let @+=expand("%:t:r")<bar>echo 'Yanked file name without extension'<CR>
  " Yank buffer file name to '+' register
  nnoremap <Leader>fyF :let @+=expand("%:t")<bar>echo 'Yanked file name'<CR>
  " Yank buffer's absolut directory path to '+' register
  nnoremap <Leader>fyd :let @+=expand("%:p:h")<bar>echo 'Yanked absolute directory path'<CR>
  " Yank buffer's relative directory path to '+' register
  nnoremap <Leader>fyD :let @+=expand("%:p:h:t")<bar>echo 'Yanked relative directory path'<CR>
  " Yank buffer's file extension only to '+' clipboard
  nnoremap <Leader>fyx :let @+=expand("%:e")<bar>echo 'Yanked file extension'<CR>
  " :edit file path from clipboard register
  nnoremap <Leader>fyo :execute "e " . getreg('+')<bar>echo 'Opened ' . expand("%:p")<CR>
endfunction

function! FileManagementMappings()
  nnoremap <Leader>fD :echohl WarningMsg<bar> echom "File " . expand("%:p") . " deleting..."<bar>echohl None<bar>call delete(expand("%"))<bar>bdelete!<CR>
  " Set working directory to current file location for all windows
  nnoremap <Leader>frd :cd %:p:h<CR>:pwd<CR>
  " Set working directory to current file location only for the current window
  nnoremap <Leader>frl :lcd %:p:h<CR>:pwd<CR>
  " Open current file with xdg-open and disown
  nnoremap <silent><Leader>oo :!xdg-open "%:p" & disown<CR>
  " Open current file in google chrome and disown
  nnoremap <silent><Leader>og :!google-chrome "%:p" & disown<CR>
endfunction

function! WindowsManagementMappings()
  noremap <silent> q :SmartBufClose<cr>

  " Tab operation
  nnoremap <silent> <Leader>1 :<C-u>tabfirst<CR>
  nnoremap <silent> <Leader>5 :<C-u>tabprevious<CR>
  nnoremap <silent> <Leader>9 :<C-u>tablast<CR>
  nnoremap <silent> <Leader>tn :tabnew<cr>
  nnoremap <silent> <Leader>tq :tabclose<cr>
  nnoremap <silent> <Leader>te :tabedit
  nnoremap <silent> <Leader>tm :tabmove
  nnoremap <silent> [t :tabprevious<CR>
  nnoremap <silent> ]t :tabnext<CR>
  nnoremap <silent> ]T :tabmove+<CR>
  nnoremap <silent> [T :tabmove-<CR>

  " Move between buffers
  nnoremap <silent> ]b :bnext<CR>
  nnoremap <silent> [b :bprevious<CR>
  nnoremap <silent> ]B :blast<CR>
  nnoremap <silent> [B :bfirst<CR>

  " Window-control prefix
  nnoremap  [Window]   <Nop>
  nmap      s [Window]

  " Background dark/light toggle and contrasts
  nmap <silent> [Window]H :<C-u>call <SID>toggle_background()<CR>
  nmap <silent> [Window]- :<c-u>call <SID>toggle_contrast(-v:count1)<cr>
  nmap <silent> [Window]= :<c-u>call <SID>toggle_contrast(+v:count1)<cr>

  " Splits
  nnoremap <silent> [Window]v  :<C-u>split<CR>
  nnoremap <silent> [Window]g  :<C-u>vsplit<CR>
  " Split current buffer, go to previous window and previous buffer
  nnoremap <silent> [Window]sv :split<CR>:wincmd p<CR>:e#<CR>
  nnoremap <silent> [Window]sg :vsplit<CR>:wincmd p<CR>:e#<CR>
  " Resize splits
  nnoremap [Window]k :resize -3<CR>
  nnoremap [Window]j :resize +3<CR>
  nnoremap [Window]h :vertical resize -3<CR>
  nnoremap [Window]l :vertical resize +3<CR>
  nnoremap [Window]q :close<CR>
  nnoremap <Up>      :resize -1<CR>
  nnoremap <Down>    :resize +1<CR>
  nnoremap <Left>    :vertical resize -1<CR>
  nnoremap <Right>   :vertical resize +1<CR>
  " Switch between splits
  nnoremap <M-h> <C-w>h
  nnoremap <M-l> <C-w>l
  nnoremap <M-j> <C-w>j
  nnoremap <M-k> <C-w>k

  " Deletes buffer but keeps the split
  " Ref: https://stackoverflow.com/a/19619038/11850077
  noremap [Window]d :b#<bar>bd#<CR>
  nnoremap <silent> [Window]z  :<C-u>call <SID>custom_zoom()<CR>
endfunction
" }}} FILE AND WINDOWS MAPPINGS

" UTILITIES MAPPINGS -------------------- {{{
function! UtilityMappings()
  " Select last inserted characters.
  inoremap <M-v> <ESC>v`[
  " Use backspace key for matching pairs
  nmap <BS> %
  xmap <BS> %
  " Drag current line(s) vertically and auto-indent
  nnoremap <Leader>J :m+<CR>
  nnoremap <Leader>K :m-2<CR>
  vnoremap J :m'>+<CR>gv=gv
  vnoremap K :m'<-2<CR>gv=gv
  " Load all a:input value from files of the same extension as the current
  " buffer within project directory.
  " Ref: https://stackoverflow.com/a/4106211/11850077
  function! VimgrepWrapper(input, ...)
    " arg2 'c' for ignorecasing and 'C' for match casing
    let casing = get(a:, 1, "")
    let ext = expand("%:e")
    " Find files only with same extension as current buffer if theres a file
    " extension, else no file type filter.
    if ext
      exec "noautocmd vimgrep /\\" . casing . a:input . "/j **/*." . expand("%:e")
    else
      exec "noautocmd vimgrep /\\" . casing . a:input . "/j **/*"
    endif
    exec "cw"
  endfunction
  nnoremap <Leader>fg :call VimgrepWrapper("")<Left><Left>
  nnoremap <Leader>gD :GitOpenDirty<CR>
endfunction

function! CommandMappings()
  " Commandline basic movements
  "cnoremap w!! w !sudo tee % >/dev/null
  cnoremap <C-p> <Up>
  cnoremap <C-b> <Left>
  cnoremap <C-f> <Right>
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-d> <Del>
  cnoremap <C-h> <BS>
  " print insert buffer file directory path
  cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>
  " Easy wildcharm navigation
  cnoremap <expr><C-j> pumvisible() ? "\<C-n>" : nr4char(&wildcharm)
  cnoremap <expr><C-k> pumvisible() ? "\<C-p>" : nr3char(&wildcharm)
  cnoremap <expr><Tab> pumvisible() ? "\<C-e>".nr2char(&wildcharm) : nr2char(&wildcharm)
endfunction

function! YankPasteMappings()
  " Yank and paste line under cursor to and from "x register
  " nnoremap <C-y> "xyy"xp$
  inoremap <C-y> <Esc>"xyy"xp`.A
  " Duplicate current line then enter line substitution. DEPRECATED by vim-abolish
  " inoremap <C-y> <ESC>yypV:s//g<Left><Left>
  " Auto indent while pasting
  function! AutoIndentPaste()
    " Don't apply on these filetypes
    if &filetype =~ 'markdown\|vimwiki\|text|\snippets\|tex'
      return
    endif
    " Format and indent pasted text automatically. Also select pasted texts after
    nnoremap <buffer> p p=`]
    nnoremap <buffer> P P=`]
  endfunction
  autocmd BufWritePre * call AutoIndentPaste()
endfunction

function! EmacsLikeMappings()
  inoremap <C-h> <BS>
  inoremap <C-d> <Del>
  inoremap <C-a> <Home>
  inoremap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"
  " Cursor navigation
  inoremap <C-b> <Left>
  inoremap <C-f> <Right>
  inoremap <expr><C-n> pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<Up>"
  " move between sentences
  inoremap <M-a> <C-[>(i
  inoremap <M-e> <C-[>)i
endfunction

function! QuickFixLocationListMappings()
  " Move through the loclist
  nnoremap <silent> [l :lprevious<CR>
  nnoremap <silent> ]l :lnext<CR>
  nnoremap <silent> [L :lfirst<CR>
  nnoremap <silent> ]L :llast<CR>
  " Toggle Locationlist
  function! LocationlistToggle()
    for i in range(1, winnr('$'))
      let bnum = winbufnr(i)
      if getbufvar(bnum, '&buftype') == 'locationlist'
        lclose
        return
      endif
    endfor
    lopen
  endfunction
  nnoremap <silent> <LocalLeader>l :call LocationlistToggle()<CR>
  " Move through the quickfix list
  nnoremap <silent> [q :cprevious<CR>
  nnoremap <silent> ]q :cnext<CR>
  nnoremap <silent> [Q :cfirst<CR>
  nnoremap <silent> ]Q :clast<CR>
  " Toggle Quickfix
  function! QuickfixToggle()
    for i in range(1, winnr('$'))
      let bnum = winbufnr(i)
      if getbufvar(bnum, '&buftype') == 'quickfix'
        cclose
        return
      endif
    endfor
    copen
  endfunction
  nnoremap <silent> <LocalLeader>q :call QuickfixToggle()<CR>
  " When using `dd` in the quickfix list, remove the item from the quickfix list.
  " Ref: https://stackoverflow.com/a/48817071/11850077
  function! RemoveQFItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    execute curqfidx + 1 . "cfirst"
    :copen
  endfunction
  :command! RemoveQFItem :call RemoveQFItem()
  " Use map <buffer> to only map dd in the quickfix window. Requires +localmap
  autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
endfunction

function! RegisterMappings()
  " Cycle through vim register +abjkx.
  " Register `+` as the system clipboard and `x` as temp holder
  " `j` cycles forward, `k` cycles backward
  nnoremap <Leader>rej :let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>
  nnoremap <Leader>rek :let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>
  " Cycle through registers then paste register `+`
  nnoremap <Leader>reJ :let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>p
  nnoremap <Leader>reK :let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>p
  vnoremap <Leader>reJ :let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>p
  vnoremap <Leader>reK :let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>p
  " Copy selected then cycle through registers
  vnoremap <Leader>rej y<ESC>:let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>
  vnoremap <Leader>rek y<ESC>:let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>
  " Display register +abjk
  nnoremap <Leader>reg :reg +abjk<CR>
endfunction

function! DiffMappings()
  " Diff split with a file (auto wildcharm trigger)
  if !&wildcharm | set wildcharm=<C-z> | endif
  exe 'nnoremap <Leader>idv :vert diffsplit '.expand("%:p:h").'/'.nr2char(&wildcharm)
  exe 'nnoremap <Leader>idh :diffsplit '.expand("%:p:h").'/'.nr2char(&wildcharm)
  exe 'nnoremap <Leader>idV :vert diffsplit $HOME/'.nr2char(&wildcharm)
  exe 'nnoremap <Leader>idH :diffsplit $HOME/'.nr2char(&wildcharm)
  " Git mappings for mergetools or diff mode
  " Add the following to .gitconfig, then run `git mergetool nvimdiff <MERGE_CONFLICT_FILE>`
  " [merge]
  "   tool = nvimdiff
  " [mergetool "nvimdiff"]
  "   cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'
  " [mergetool]
  "   prompt = true
  nnoremap <expr> dob &diff ? ':diffget BASE<CR>'   : ''
  nnoremap <expr> dob &diff ? ':diffget BASE<CR>'   : ''
  nnoremap <expr> dol &diff ? ':diffget LOCAL<CR>'  : ''
  nnoremap <expr> dor &diff ? ':diffget REMOTE<CR>' : ''
  " Quit nvim with an error code. Useful when aborting git mergetool or git commit
  nnoremap <expr> cq  &diff ? ':cquit<CR>'          : ''
  function! PrintMergeDiffMappings()
    echom "dob :diffget BASE"
    echom "dol :diffget LOCAL"
    echom "dor :diffget REMOTE"
    echom "cq  :cquit"
    echom "]c  Next conflict"
    echom "[c  Previous conflict"
    echom " "
    echom "To view these again, type :messages or :call PrintMergeDiffMappings()"
  endfunction

  nmap <silent> <Leader>idd :DiffOrig<CR>
endfunction

function! FoldsMappings()
  " Toggle fold
  nnoremap <Leader><CR> za
  " Focus the current fold by closing all others
  nnoremap z<CR> zMzvzt
  " Toggle fold all
  nnoremap <expr> zm &foldlevel ? 'zM' :'zR'
  " Jumping to next closed fold
  " Ref: https://stackoverflow.com/a/9407015/11850077
  function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
      exe cmd
      let [l0, l] = [l, line('.')]
      let open = foldclosed(l) < 0
    endwhile
    if open
      call winrestview(view)
    endif
  endfunction
  nnoremap <silent> zj :call NextClosedFold('j')<cr>
  nnoremap <silent> zk :call NextClosedFold('k')<cr>
endfunction
" }}} UTILITIES MAPPINGS

" TEXT MANIPULATION MAPPINGS -------------------- {{{
function! TextManipulationMappings()
  " whitespace.vim
  nnoremap <silent><Leader>r<Space> :<C-u>WhitespaceErase<CR>
  vnoremap <silent><Leader>r<Space> :WhitespaceErase<CR>
  " Wrap paragraph to textwidth
  nnoremap <Leader>rw gwap
  xnoremap <Leader>rw gw
  " Duplicate paragraph
  nnoremap <leader>rp yap<S-}>p
  " Duplicate selected line
  " Ref: https://stackoverflow.com/a/3806683/11850077
  vnoremap <Leader>rp y`]p
  " Change current word in a repeatable manner (repeatable with ".")
  nnoremap <leader>rn *``cgn
  nnoremap <leader>rN *``cgN
  " Change selected word in a repeatable manner
  vnoremap <expr> <leader>rn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
  vnoremap <expr> <leader>rN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"
  " Search and replace whole buffer
  nnoremap <Leader>rr :%s//gc<Left><Left><Left>
  " Search and replace current line only
  nnoremap <Leader>rR :s//gc<Left><Left><Left>
  " Search and replace within visually selected only
  xnoremap <Leader>rr :s//gc<Left><Left><Left>
  " Returns visually selected text
  function! s:get_selection(cmdtype)
    let temp = @s
    normal! gv"sy
    let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  " Search and replace last selected with confirmation
  nnoremap <Leader>rF :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>
  xnoremap <Leader>rF :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>
  " To enumerate lines with macro: https://stackoverflow.com/a/32053439/11850077
  " To enumerate lines with few commands: https://stackoverflow.com/a/48408001/11850077
  " Ref: https://vi.stackexchange.com/a/690
  nnoremap <Leader>rL :%s/^/\=line('.').". "<CR>
  " Ref: https://stackoverflow.com/a/51291652
  vnoremap <silent> <Leader>rl :<C-U>let i=1 \| '<,'>g/^/s//\=i.'. '/ \| let i=i+1 \| nohl<CR>
  " Fix indentation of whole buffer
  nnoremap <Leader>ri gg=G<C-o>
  " Ref: https://stackoverflow.com/a/17440797/11850077
  " Capitaliz each word of the selected
  vnoremap <Leader>rC :s/\<./\u&/g \| nohl<CR>
  " Capitalize each word of current entire file
  nnoremap <Leader>rC :%s/\<./\u&/g<CR>:nohl<CR>
  " Lowercase each word of the selected
  vnoremap <Leader>rc :s/\<./\l&/g<CR>:nohl<CR>
  " Lowercase each word of current entire file
  nnoremap <Leader>rc :%s/\<./\l&/g<CR>:nohl<CR>
  " Yank everything from current file
  nnoremap <Leader>rya ggVGy:echom "Yanked all file contents!"<CR>
  " Replace all with yanked texts
  nnoremap <Leader>ryp ggVGP:echom "Replaced all with yanked texts!"<CR>
  " Jumps to previously misspelled word and fixes it with the first in the suggestion
  " Update: also echo changes and line and col number
  " Ref: https://castle.Dev/post/lecture-notes-1/
  inoremap <C-s> <Esc>:set spell<bar>norm i<C-g>u<Esc>[s"syiW1z="tyiW:let @l=line('.')<bar>let @c=virtcol('.')<CR>``a<C-g>u<Esc>:set nospell<bar>:echo getreg('l') . ":" . getreg('c') . " spell fixed (" . getreg('s') . " -> " . getreg('t') . ")"<CR>la
endfunction
" }}} TEXT MANIPULATION MAPPINGS

" ==================== Custom single purpose functions and mappings ==================== "

function! s:toggle_background()
  if ! exists('g:colors_name')
    echomsg 'No colorscheme set'
    return
  endif
  let l:scheme = g:colors_name

  if l:scheme =~# 'dark' || l:scheme =~# 'light'
    " Rotate between different theme backgrounds
    execute 'colorscheme' (l:scheme =~# 'dark'
          \ ? substitute(l:scheme, 'dark', 'light', '')
          \ : substitute(l:scheme, 'light', 'dark', ''))
  else
    execute 'set background='.(&background ==# 'dark' ? 'light' : 'dark')
    if ! exists('g:colors_name')
      execute 'colorscheme' l:scheme
      echomsg 'The colorscheme `'.l:scheme
            \ .'` doesn''t have background variants!'
    else
      echo 'Set colorscheme to '.&background.' mode'
    endif
  endif
endfunction

function! s:toggle_contrast(delta)
  let l:scheme = ''
  if g:colors_name =~# 'solarized8'
    let l:schemes = map(['_low', '_flat', '', '_high'],
          \ '"solarized8_".(&background).v:val')
    let l:contrast = ((a:delta + index(l:schemes, g:colors_name)) % 4 + 4) % 4
    let l:scheme = l:schemes[l:contrast]
  endif
  if l:scheme !=# ''
    execute 'colorscheme' l:scheme
  endif
endfunction

function! s:window_empty_buffer()
  let l:current = bufnr('%')
  if ! getbufvar(l:current, '&modified')
    enew
    silent! execute 'bdelete '.l:current
  endif
endfunction

" Simple zoom toggle
function! s:custom_zoom()
  if exists('t:custom_zoomed')
    unlet t:custom_zoomed
    wincmd =
  else
    let t:custom_zoomed = { 'nr': bufnr('%') }
    vertical resize
    resize
    normal! ze
  endif
endfunction


call ExitMappings()
call ImprovedDefaultMappings()
call ExtendedBasicMappings()
call OperatorMappings()
call FilePathMappings()
call FileManagementMappings()
call WindowsManagementMappings()
call UtilityMappings()
call CommandMappings()
call YankPasteMappings()
call EmacsLikeMappings()
call QuickFixLocationListMappings()
call RegisterMappings()
call DiffMappings()
call FoldsMappings()
call TextManipulationMappings()

" ==================== Filetype Plugins ==================== "

augroup user_plugin_filetype "{{{
  autocmd!

  " Disable swap/undo/viminfo/shada files in temp directories or shm
  silent! autocmd BufNewFile,BufReadPre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
        \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=

  " Trigger `autoread` when files changes on disk
  " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
  " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

  " Notification after file change
  " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

  " Disables automatic commenting on newline:
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Reload vim config automatically
  autocmd BufWritePost $VIM_PATH/{*.vim,*.yaml,vimrc} nested
        \ source $MYVIMRC | redraw

  " Reload Vim script automatically if setlocal autoread
  autocmd BufWritePost,FileWritePost *.vim nested
        \ if &l:autoread > 0 | source <afile> |
        \   echo 'source ' . bufname('%') |
        \ endif

  " Update filetype on save if empty
  autocmd BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

  " Automatically set read-only for files being edited elsewhere
  autocmd SwapExists * nested let v:swapchoice = 'o'

  " Equalize window dimensions when resizing vim window
  autocmd VimResized * tabdo wincmd =

  " Force write shada on leaving nvim
  autocmd VimLeave * if has('nvim') | wshada! | else | wviminfo! | endif

  " Check if file changed when its window is focus, more eager than 'autoread'
  autocmd FocusGained * checktime

  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

  autocmd Syntax * if line('$') > 5000 | syntax sync minlines=200 | endif

  " Python
  autocmd FileType python
        \ setlocal expandtab smarttab nosmartindent
        \ | setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
augroup END "}}}

" ==================== Local Plugins ==================== "

source ~/.vim/smartbufclose.vim
source ~/.vim/whitespace.vim
source ~/.vim/grep-operator.vim
source ~/.vim/filesystem.vim
source ~/.vim/nicefold.vim
source ~/.vim/jumpfile.vim

