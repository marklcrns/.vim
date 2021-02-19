" Plugin key settings
function! PlugLoaded(name)
	return (has_key(g:plugs, a:name))
endfunction

let s:enable_whichkey = PlugLoaded('vim-which-key')

if s:enable_whichkey
	function! InitWhickey()
		let s:leader_key=substitute(get(g:,"mapleader","\\"), ' ', '<Space>', '')
		let s:localleader_key= get(g:,'maplocalleader',';')
		execute 'nnoremap <silent> <Leader> :<c-u>WhichKey "'.s:leader_key.'"<CR>'
		execute 'vnoremap <silent> <Leader> :<c-u>WhichKeyVisual "'.s:leader_key.'"<CR>'
		execute 'nnoremap <silent> <LocalLeader> :<c-u>WhichKey "' .s:localleader_key.'"<CR>'
		execute 'vnoremap <silent> <LocalLeader> :<c-u>WhichKeyVisual "'.s:localleader_key.'"<CR>'
		execute 'nnoremap <silent> [ :<c-u>WhichKey "["<CR>'
		execute 'nnoremap <silent> ] :<c-u>WhichKey "]"<CR>'
	endfunction
	call InitWhickey()

	" Extra mappings
	nnoremap <silent> ?s :<c-u>WhichKey 's'<CR>
	vnoremap <silent> ?s :<c-u>WhichKeyVisual 's'<CR>
	nnoremap <silent> ?d :<c-u>WhichKey 'd'<CR>
	vnoremap <silent> ?d :<c-u>WhichKeyVisual 'd'<CR>
	nnoremap <silent> ?g :<c-u>WhichKey 'g'<CR>
	vnoremap <silent> ?g :<c-u>WhichKeyVisual 'g'<CR>
endif

if PlugLoaded('ale')
	nmap <silent> gn <Plug>(ale_next)
	nmap <silent> gp <Plug>(ale_previous)
	noremap gd :ALEGoToDefinition<CR>
	noremap gr :ALEFindReferences<CR>
	noremap gs :ALESymbolSearch<CR>
	noremap <Leader>cn :ALERename<CR>
	noremap <Leader>ca :ALECodeAction<CR>
endif

if PlugLoaded('caw.vim')
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
endif

if PlugLoaded('any-jump.vim')
	nnoremap <silent> <leader>ab :AnyJumpBack<CR>
	nnoremap <silent> <Leader>aj :AnyJump<CR>
	xnoremap <silent> <Leader>aj :AnyJumpVisual<CR>
	nnoremap <silent> <leader>al :AnyJumpLastResults<CR>

	if s:enable_whichkey
		let g:which_key_map['a'] = {
					\ 'name' : '+any-jump',
					\ 'b' : 'Open previously opened file',
					\ 'j' : 'Open jump to definition window',
					\ 'l' : 'Open last jump to definition result',
					\ }
	endif
endif

if PlugLoaded('gina.vim')
	nnoremap <silent> <Leader>ga :Gina add %:p<CR>
	nnoremap <silent> <Leader>gA :Gina add .<CR>
	nnoremap <silent> <leader>gb :Gina blame --width=40<CR>
	nnoremap <silent> <Leader>gc :Gina commit<CR>
	nnoremap <silent> <leader>gd :Gina compare<CR>
	nnoremap <silent> <Leader>gF :Gina! fetch<CR>
	nnoremap <silent> <Leader>gl :Gina log --graph --all<CR>
	nnoremap <silent> <leader>go :,Gina browse :<CR>
	vnoremap <silent> <leader>go :Gina browse :<CR>
	nnoremap <silent> <Leader>gp :Gina! push<CR>
	nnoremap <silent> <leader>gs :Gina status -s<CR>

	if s:enable_whichkey
		let g:which_key_map['g']['a'] = 'Stage buffer'
		let g:which_key_map['g']['A'] = 'Stage all changes'
		let g:which_key_map['g']['b'] = 'Open git blame'
		let g:which_key_map['g']['c'] = 'Commit staged changes'
		let g:which_key_map['g']['d'] = 'Diff buffer'
		let g:which_key_map['g']['F'] = 'Fetch remote'
		let g:which_key_map['g']['l'] = 'Display git log'
		let g:which_key_map['g']['o'] = 'Open repo in browser'
		let g:which_key_map['g']['p'] = 'Push commits'
		let g:which_key_map['g']['s'] = 'Display git status'
	endif
endif

if PlugLoaded('vim-gitgutter')
	nmap ]g <Plug>(GitGutterNextHunk)
	nmap [g <Plug>(GitGutterPrevHunk)
	nmap gS <Plug>(GitGutterStageHunk)
	xmap gS <Plug>(GitGutterStageHunk)
	nmap gs <Plug>(GitGutterPreviewHunk)
	nmap <Leader>gr <Plug>(GitGutterUndoHunk)

	if s:enable_whichkey
		let g:which_key_rsbgmap['g'] = 'Go to next git changes hunk'
		let g:which_key_lsbgmap['g'] = 'Go to prev git changes hunk'
		let g:which_key_gmap['s'] = 'Preview git changes hunk'
		let g:which_key_gmap['S'] = 'Stage git changes hunk'
		let g:which_key_map['g']['r'] = 'Undo stage git changes hunk'
	endif
endif


if PlugLoaded('fern.vim')
	nnoremap <silent> <Leader>ee :<C-u>Fern . -drawer -keep -toggle -width=35 -reveal=%<CR><C-w>=
	nnoremap <silent> <Leader>ea :<C-u>Fern . -drawer -keep -toggle -width=35<CR>

	if s:enable_whichkey
		let g:which_key_map['e']['a'] = 'Toggle explorer to current file'
		let g:which_key_map['e']['e'] = 'Toggle explorer to current directory'
	endif
endif

if PlugLoaded('fzf.vim')
	nnoremap <silent> <Leader>fdb :<C-u>Buffers<CR>
	nnoremap <silent> <Leader>fdf :<C-u>Files<CR>
	nnoremap <silent> <Leader>fdr :<C-u>Rg<CR>

	if s:enable_whichkey
		let g:which_key_map['f']['d'] = {
					\ 'name' : '+finder',
					\ 'f' : 'Find files on directory',
					\ 'r' : 'Find word with rg',
					\ 'b' : 'Find on buffers',
					\ }
	endif
endif
