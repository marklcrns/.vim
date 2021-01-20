
" vim-clap
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
