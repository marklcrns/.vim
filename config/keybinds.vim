
" ale
" -----
nmap <silent> gn <Plug>(ale_next)
nmap <silent> gp <Plug>(ale_previous)
noremap gd :ALEGoToDefinition<CR>
noremap gr :ALEFindReferences<CR>
noremap gs :ALESymbolSearch<CR>
noremap <Leader>cn :ALERename<CR>
noremap <Leader>ca :ALECodeAction<CR>


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

" any-jump
" -----
"
nnoremap <silent> <leader>ab :AnyJumpBack<CR>
nnoremap <silent> <Leader>aj :AnyJump<CR>
xnoremap <silent> <Leader>aj :AnyJumpVisual<CR>
nnoremap <silent> <leader>al :AnyJumpLastResults<CR>

" fugitive
" -----

nnoremap <Leader>gb :<C-u>Git blame<CR>
nnoremap <Leader>gdc :<C-u>Gdiff --cached<CR>
nnoremap <Leader>gdd :<C-u>Gdiff<Space>
nnoremap <Leader>gdt :<C-u>Git difftool<CR>
nnoremap <Leader>gds :<C-u>Gdiffsplit!<CR>
nnoremap <Leader>gdh :<C-u>Ghdiffsplit<CR>
nnoremap <Leader>gdv :<C-u>Gvdiffsplit<CR>
nnoremap <Leader>gl :<C-u>Glog<CR>
nnoremap <Leader>gL :<C-u>0Glog<CR>
nnoremap <Leader>gF :<C-u>Gfetch<CR>
nnoremap <Leader>gg :<C-u>Ggrep<Space>
nnoremap <Leader>gG :<C-u>Glog --grep= -- %<Left><Left><Left><Left><Left>
nnoremap <Leader>gr :<C-u>Git reset<CR>
nnoremap <Leader>gs :<C-u>Gstatus<CR>
nnoremap <Leader>gp :<C-u>Gpush<CR>
