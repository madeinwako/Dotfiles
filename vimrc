"------------------------------------
" vim general setting
"------------------------------------
set autoindent
set smartindent
set number
set shiftwidth=2
set noswapfile
set nobackup

set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac

syntax on
"colorscheme hybrid

"------------------------------------
" vim normal mode setting 
"------------------------------------

"------------------------------------
"  unite.vim setting
"------------------------------------

" 入力モードで開始する
let g:unite_enable_start_insert=0
" バッファ一覧
noremap <C-U><C-B> :Unite buffer<CR>
" ファイル一覧
noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>
" 最近使ったファイルの一覧
noremap <C-U><C-R> :Unite file_mru<CR>
" レジスタ一覧
noremap <C-U><C-Y> :Unite -buffer-name=register register<CR>
" ファイルとバッファ
noremap <C-U><C-U> :Unite buffer file_mru<CR>
" 全部
noremap <C-U><C-A> :Unite UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

"switch color theme with unite.vim
noremap <C-U><C-P> :Unite colorscheme -auto-preview<CR>

"------------------------------------
"  neobundle setting section 
"------------------------------------

"Neobundle set up
"reference to  https://github.com/Shougo/neobundle.vim/blob/master/README.md
set nocompatible

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
" Recommended to install
NeoBundle 'Shougo/vimproc'


""""""""""""""""""""""""""""""""""""""""
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'scrooloose/nerdtree'

" color theme setting with neobundle
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'altercation/solarized'
NeoBundle 'vim-scripts/newspaper.vim'
NeoBundle 'w0ng/vim-hybrid'

" git tools 
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

" lightline
NeoBundle 'itchyny/lightline.vim'

"html
NeoBundle 'tell-k/vim-browsereload-mac'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'taichouchou2/html5.vim'

"javascript 
NeoBundle 'mattn/emmet-vim'
"NeoBundle 'taichouchou2/surround.vim'
NeoBundle 'open-browser.vim'
NeoBundle 'mattn/webapi-vim'
"NeoBundle 'taichouchou2/vim-javascript'
NeoBundle 'marijnh/tern_for_vim', {
  \ 'build': {
  \   'others': 'npm install'
  \}}

filetype plugin on
filetype indent on

NeoBundleCheck

"------------------------------------
"lightline setting
"------------------------------------
set laststatus=2
set t_Co=256

let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'mode_map': {'c': 'NORMAL'},
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
			\ },
			\ 'component_function': {
			\   'modified': 'MyModified',
			\   'readonly': 'MyReadonly',
			\   'fugitive': 'MyFugitive',
			\   'filename': 'MyFilename',
			\   'fileformat': 'MyFileformat',
			\   'filetype': 'MyFiletype',
			\   'fileencoding': 'MyFileencoding',
			\   'mode': 'MyMode'
			\ }
			\ }

function! MyModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
	return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
				\  &ft == 'unite' ? unite#get_status_string() :
				\  &ft == 'vimshell' ? vimshell#get_status_string() :
				\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
	try
		if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
			return fugitive#head()
		endif
	catch
	endtry
	return ''
endfunction

function! MyFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

