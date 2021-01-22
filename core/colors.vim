" Highlights: General GUI {{{
" ----------------------------------------------------------------------------
" Ref: https://github.com/mhinz/vim-janah
highlight Comment guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
" Transparent bg
" highlight Normal guibg=NONE ctermbg=NONE
" }}}

" Plugin: Vim-indent-guides {{{
" NOTE: g:indent_guides_auto_colors must be 0
" ----------------------------------------------------------------------------
highlight IndentGuidesOdd  guibg=#222222 ctermbg=235
highlight IndentGuidesEven guibg=#272727 ctermbg=236
" }}}

" GetColorSynatxGroup
" ---------------------------------------------------------
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
			\ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>



