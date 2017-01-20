" ☻ ☺	
" (∂_∂)
" → ∞ ✓ ✗ ♂ ♀ ♫ ♪ π 
"

" {{{ → [ Résumé ]
"
"  F1: help
"  F2: toggle paste
"  F3: 
"  F4: 
"  F5: 
"  F6: 
"  F7: 
"  F8: tagbar
"  F9: nerdtree
" F10:
" F11:
" F12:
"
" }}}

" → [ General ] {{{

set nocompatible " stay Vimproved 8-)
syntax on
filetype plugin indent on

" load pathogen, i put pathogen in the bundle directory for easier maintenance  
source ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" load :Man command to use man inside vim
runtime! ftplugin/man.vim 

colorscheme desert

set autowrite
set autoread
set history=1000
set modeline
set lazyredraw

set autoindent
set encoding=utf8
" allow backspace to remove autoindents, characters and lines
set backspace=indent,eol,start
set textwidth=80

" load bépo remaps
source ~/.vimrc.bepo

" put backup files in tmp directory to avoid to poluate working directory
set backupdir=~/tmp,/var/tmp,/tmp
" put swap files in tmp directory to avoid to poluate working directory
set directory=~/tmp,/var/tmp,/tmp

" }}}

" → [ Remap ] {{{

set pastetoggle=<F2>

noremap <leader>r :source ~/.vimrc<CR>

inoremap èè <Esc>
vnoremap èè <Esc>
xnoremap èè <Esc>

nnoremap <silent> <space> :nohl<CR>

" TABS
noremap <silent> &n :tabnew<CR>
noremap <silent> &q :tabclose<CR>
noremap <silent> && :tabonly<CR>
noremap &b gT
noremap &é gt
noremap &B :exe "silent! tabfirst"<CR>
noremap &É :exe "silent! tablast"<CR>
noremap <silent> &c :<C-U>exe "tabmove -".v:count1<CR>
noremap <silent> &r :<C-U>exe "tabmove +".v:count1<CR>
noremap <silent> &C :tabmove 0<CR>
noremap <silent> &R :tabmove $<CR>

noremap wvn :vnew<CR>

noremap <S-q> :CtrlPTag<cr>
noremap <C-q> :CtrlPBufTag<cr>

" }}}

" {{{ → [ Interface ]

set number
set relativenumber
set cmdheight=2
" always show the status line
set laststatus=2
" autocompletion in menus
set wildmenu
set showcmd
" don't break lines
set wrap
" colorize nbsp
" highlight NbSp ctermbg=lightgray guibg=lightred
" match NbSp /\%xa0/
" show the ASCII of the character under cursor
" set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P

" }}}

" {{{ → [ Tabs ]

" convert tabs to spaces
set expandtab
" 1 tab = 4 spaces
set tabstop=4
" number of spaces removed when pressing <BS> 
set softtabstop=4
" number of spaces inserted/removed when indenting
set shiftwidth=4

" }}}

" {{{ → [ Search ]

set ignorecase
" don't ignore case when the pattern contains at least one uppercase character
set smartcase
" highlight matchnig patterns
set hlsearch
" highlight the next matching pattern while typing, use CTRL-L to insert the next character from the match
set incsearch
" DON'T wrap around the file after hitting the bottom or the top of the file (while pressing n or N)
set nowrapscan

" }}}

" {{{ → [ Functions ]

"
" copied from vim-unimpaired
"
function! TemporaryPaste()
  let s:paste = &paste
  let s:mouse = &mouse
  set paste
  set mouse=
  augroup setup_paste
    autocmd!
    autocmd InsertLeave *
          \ if exists('s:paste') |
          \   let &paste = s:paste |
          \   let &mouse = s:mouse |
          \   unlet s:paste |
          \   unlet s:mouse |
          \ endif |
          \ autocmd! setup_paste
  augroup END
endfunction

nnoremap <silent> yo  :call TemporaryPaste()<CR>o
nnoremap <silent> yO  :call TemporaryPaste()<CR>O

"
" create subdirectories if they don't exist when using :e command
"
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" }}}

" {{{ → [ Filetypes ]

autocmd filetype python
    \ set tabstop=8 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set fileformat=unix |

autocmd filetype javascript 
    \ setl ts=2 |
    \ setl sts=2 | 
    \ setl sw=2 |

autocmd filetype ruby 
    \ setl ts=2 |
    \ setl sts=2 | 
    \ setl sw=2 |

autocmd filetype scss set ts=2 sts=2 sw=2

" }}}

" {{{ → [ Folding ]

set foldmethod=manual

" }}}

" {{{ → [ Plugins ] 

" Open Tagbar, if Tagbar is already open jump to it
nmap <silent> <F8> :TagbarOpen fj<CR>
nmap <silent> <F9> :NERDTreeToggle<CR>

let g:tagbar_map_showproto="k"

" tell ctrlp to ignore files
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|bower_components'
" tell ycm to use python3.5
let g:ycm_python_binary_path = '/usr/bin/python3.5'

autocmd bufenter * 
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) |
    \   q |
    \ endif |

nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfunction

let g:ctrlp_extensions = ['tag', 'buffertag']
" }}}

" {{{ → [ Other ] 

au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

set tags+=gems.tags

" }}}

" vim: set fdm=marker fmr={{{,}}} fdl=0 tw=80:
