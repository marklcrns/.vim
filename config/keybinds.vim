
" coc
" -----

nnoremap <silent> <leader>cC :<C-u>CocConfig<Cr>
" Using CocList
" Show commands
nnoremap <silent> <leader>clc  :<C-u>CocList commands<cr>
" Show all diagnostics
nnoremap <silent> <leader>cld  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>cle  :<C-u>CocList extensions<cr>
" Marketplace list
nnoremap <silent> <leader>clm  :<C-u>CocList marketplace<cr>
" Find symbol of current document
nnoremap <silent> <leader>clo  :<C-u>CocList outline<cr>
" Resume latest coc list
nnoremap <silent> <leader>clr  :<C-u>CocListResume<CR>
" Search workspace symbols
nnoremap <silent> <leader>cls  :<C-u>CocList -I symbols<cr>
" Show yank list (coc-yank)
nnoremap <silent> <leader>cly  :<C-u>CocList -A --normal yank<cr>

" Rgrep selected or by motion
nnoremap <leader>clw :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@
vnoremap <leader>clw :<C-u>call <SID>GrepFromSelected(visualmode())<CR>

function! s:GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList grep '.word
endfunction

" Grep in current buffer under cursor
nnoremap <silent> <Leader>clW  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>

" Do default action for next item.
nnoremap <silent> <leader>cj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>ck  :<C-u>CocPrev<CR>
" Use `[d` and `]d` for navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
" Remap for rename current word
nmap <leader>cn <Plug>(coc-rename)
" Remap for format selected region
vmap <leader>cF <Plug>(coc-format-selected)
nmap <leader>cF <Plug>(coc-format-selected)
" Applying codeAction to the selected region.
xmap <silent><leader>ca <Plug>(coc-codeaction-selected)
nmap <silent><leader>ca <Plug>(coc-codeaction-selected)
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>cc <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>cq <Plug>(coc-fix-current)
" Insert current filetype template on cursor
nmap <leader>cm <Plug>(coc-template)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" coc-git
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show commit contains current position
nmap <Leader>cgc <Plug>(coc-git-commit)
" show chunk diff at current position
nmap <Leader>cgi <Plug>(coc-git-chunkinfo)
" show git status
nnoremap <silent> <leader>cgs  :<C-u>CocList --normal gstatus<CR>
nnoremap <Leader>cgb :CocCommand git.browserOpen<CR>
nnoremap <Leader>cgB :CocCommand git.copyUrl<CR>
nnoremap <Leader>cgd :CocCommand git.diffCached<CR>
nnoremap <Leader>cgf :CocCommand git.foldUnchanged<CR>
nnoremap <Leader>cgt :CocCommand git.chunkStage<CR>
nnoremap <Leader>cgu :CocCommand git.chunkUndo<CR>

" Coc toggles
nnoremap <Leader>ctg :<C-u>CocCommand git.toggleGutters<Cr>
nnoremap <Leader>cts :<C-u>CocCommand cSpell.toggleEnableSpellChecker<Cr>

" Use K for show documentation in float window
" nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" Use K to show documentation in preview for vim window and float for nvim
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    let l:found = CocAction('doHover')
  endif
endfunction

" use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" float window scroll
nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-f>"
nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
" multiple cursors
nmap <silent> <C-c> <Plug>(coc-cursors-position)
" use normal command like `<leader>xi(`
nmap <leader>cx <Plug>(coc-cursors-operator)

nmap <expr> <silent> <C-s> <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  " Adjusted for vim-asterisk plugin
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

nnoremap <silent> <leader>cs :<C-u>CocSearch<Space>
nnoremap <silent> <leader>cS :<C-u>CocSearch -w<Space>

nmap <leader>cr <Plug>(coc-refactor)

" Movement within 'ins-completion-menu'
imap <expr><C-j> pumvisible() ? "\<Down>" : "\<C-j>"
imap <expr><C-k> pumvisible() ? "\<Up>" : "\<ESC>d$a"

" Scroll pages in menu
" inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>" a
" inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
" imap     <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
" imap     <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

nnoremap <expr><C-n> coc#util#has_float() ?
      \ coc#util#float_scrollable() ?
      \ coc#util#float_scroll(1)
      \ : ""
      \ : "\<C-n>"
nnoremap <expr><C-p> coc#util#has_float() ?
      \ coc#util#float_scrollable() ?
      \ coc#util#float_scroll(0)
      \ : ""
      \ : "\<C-p>"

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" coc.nvim
" -----

nnoremap <silent> <Leader>fd: :<C-u>Clap command_history<CR>
nnoremap <silent> <Leader>fdc :<C-u>Clap colors<CR>
nnoremap <silent> <Leader>fdb :<C-u>Clap buffers<CR>
nnoremap <silent> <Leader>fdr :<C-u>Clap grep<CR>
nnoremap <silent> <Leader>fdR :<C-u>Clap grep %:p:h<CR>
nnoremap <silent> <Leader>fds :<C-u>Clap sessions<CR>
nnoremap <silent> <Leader>fdm :<C-u>Clap marks<CR>
nnoremap <silent> <Leader>fdf :<C-u>Clap files ++finder=rg --files<cr>
nnoremap <silent> <Leader>fdF :<C-u>Clap files ++finder=rg --hidden --files<cr>
nnoremap <silent> <Leader>fdg :<C-u>Clap gfiles<CR>
nnoremap <silent> <Leader>fdw :<C-u>Clap grep ++query=<cword><cr>
nnoremap <silent> <Leader>fdh :<C-u>Clap history<CR>
nnoremap <silent> <Leader>fdW :<C-u>Clap windows<CR>
nnoremap <silent> <Leader>fdl :<C-u>Clap loclist<CR>
nnoremap <silent> <Leader>fdu :<C-u>Clap git_diff_files<CR>
nnoremap <silent> <Leader>fdv :<C-u>Clap grep2 ++query=@visual<CR>
vnoremap <silent> <Leader>fdv <Esc>:<C-u>Clap grep2 ++query=@visual<CR>
nnoremap <silent> <Leader>fdp :<C-u>Clap personalconf<CR>
"like emacs counsel-find-file
nnoremap <silent> <C-x><C-f> :<C-u>Clap filer<CR>

autocmd user_events FileType clap_input call s:clap_mappings()

function! s:clap_mappings()
  nnoremap <silent> <buffer> <nowait> <Space> :call clap#handler#tab_action()<CR>
  inoremap <silent> <buffer> <Tab>   <C-R>=clap#navigation#linewise('down')<CR>
  inoremap <silent> <buffer> <S-Tab> <C-R>=clap#navigation#linewise('up')<CR>
  nnoremap <silent> <buffer> <C-j> :<C-u>call clap#navigation#linewise('down')<CR>
  nnoremap <silent> <buffer> <C-k> :<C-u>call clap#navigation#linewise('up')<CR>
  nnoremap <silent> <buffer> <C-n> :<C-u>call clap#navigation#linewise('down')<CR>
  nnoremap <silent> <buffer> <C-p> :<C-u>call clap#navigation#linewise('up')<CR>
  nnoremap <silent> <buffer> <C-f> :<c-u>call clap#navigation#scroll('down')<CR>
  nnoremap <silent> <buffer> <C-b> :<c-u>call clap#navigation#scroll('up')<CR>

  nnoremap <silent> <buffer> q     :<c-u>call clap#handler#exit()<CR>
  nnoremap <silent> <buffer> <Esc> :call clap#handler#exit()<CR>
  inoremap <silent> <buffer> <Esc> <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
  inoremap <silent> <buffer> jj    <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
endfunction

" any-jump
" -----

nnoremap <silent> <leader>ab :AnyJumpBack<CR>
nnoremap <silent> <Leader>aj :AnyJump<CR>
xnoremap <silent> <Leader>aj :AnyJumpVisual<CR>
nnoremap <silent> <leader>al :AnyJumpLastResults<CR>

" caw
" -----

function! InitCaw() abort
  if ! (&l:modifiable && &buftype ==# '')
    silent! nunmap <buffer> <Leader>V
    silent! xunmap <buffer> <Leader>V
    silent! nunmap <buffer> <Leader>v
    silent! xunmap <buffer> <Leader>v
    silent! nunmap <buffer> gc
    silent! xunmap <buffer> gc
    silent! nunmap <buffer> gcc
    silent! xunmap <buffer> gcc
  else
    xmap <buffer> <Leader>// <Plug>(caw:hatpos:toggle)
    nmap <buffer> <Leader>// <Plug>(caw:hatpos:toggle)
    xmap <buffer> <Leader>/a <Plug>(caw:dollarpos:comment)
    nmap <buffer> <Leader>/a <Plug>(caw:dollarpos:comment)
    xmap <buffer> <Leader>/b <Plug>(caw:box:comment)
    nmap <buffer> <Leader>/b <Plug>(caw:box:comment)
    xmap <buffer> <Leader>/c <Plug>(caw:hatpos:comment)
    nmap <buffer> <Leader>/c <Plug>(caw:hatpos:comment)
    xmap <buffer> <Leader>/j <Plug>(caw:jump:comment-next)
    nmap <buffer> <Leader>/j <Plug>(caw:jump:comment-next)
    xmap <buffer> <Leader>/k <Plug>(caw:jump:comment-prev)
    nmap <buffer> <Leader>/k <Plug>(caw:jump:comment-prev)
    xmap <buffer> <Leader>/i <Plug>(caw:zeropos:comment)
    nmap <buffer> <Leader>/i <Plug>(caw:zeropos:comment)
    xmap <buffer> <Leader>/w <Plug>(caw:wrap:toggle)
    nmap <buffer> <Leader>/w <Plug>(caw:wrap:toggle)
    nmap <buffer> gc <Plug>(caw:prefix)
    xmap <buffer> gc <Plug>(caw:prefix)
    nmap <buffer> gcc <Plug>(caw:hatpos:toggle)
    xmap <buffer> gcc <Plug>(caw:hatpos:toggle)
  endif
endfunction
autocmd FileType * call InitCaw()
call InitCaw()

" WhichKey
" -----

nnoremap <silent> <Leader>      :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey ';'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ';'<CR>
nnoremap <silent> [             :<c-u>WhichKey '['<CR>
nnoremap <silent> ]             :<c-u>WhichKey ']'<CR>
nnoremap <silent> ?s            :<c-u>WhichKey 's'<CR>
vnoremap <silent> ?s            :<c-u>WhichKeyVisual 's'<CR>
nnoremap <silent> ?d            :<c-u>WhichKey 'd'<CR>
vnoremap <silent> ?d            :<c-u>WhichKeyVisual 'd'<CR>
nnoremap <silent> ?g            :<c-u>WhichKey 'g'<CR>
vnoremap <silent> ?g            :<c-u>WhichKeyVisual 'g'<CR>

" Fern
" -----

nnoremap <silent> <Leader>ee :<C-u>Fern . -drawer -keep -toggle -width=35 -reveal=%<CR><C-w>=
nnoremap <silent> <Leader>ea :<C-u>Fern . -drawer -keep -toggle -width=35<CR>
