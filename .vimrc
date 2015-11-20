" --- Main settings ---
set t_Co=256
set t_AB=^[[48;5;%dm
set t_AF=^[[38;5;%dm
map <xCSI>[62~ <MouseDown>
set showmode
set showmatch
set smartindent
set term=xterm-256color
set mouse=a
set ttyfast
set incsearch
set showcmd
set wildmenu
set title
set titleold=
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set tabpagemax=50                   "allow max 15 tabs to be opened at the same time
set showtabline=2                   "shows tabbar at all times, even with only one tab open
set clipboard=unnamed               "use osx clipboard
set t_kb= t_kD=                 "backspace / del fix for iterm?
set hlsearch                        "enable search highlighting
set autoread                        "automatically update external changes in buffer
set ruler                           "Show cursor location info on status line
set scrolloff=2                     "Scroll when 2 lines from top/bottom
:fixdel
:set backspace=2
:hi Visual term=reverse cterm=reverse guibg=LightGrey
syntax enable
colors solarized

" swap files to ~/.vim/
" double slashes means adding paths to swapfile for managing duplicate filenames
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 50 files
"           | |   +--Remember up to 10000 lines in each register
"           | |   |      +--Remember up to 1MB in each register
"           | |   |      |     +--Remember last 1000 search patterns
"           | |   |      |     |     +---Remember last 1000 commands
"           | |   |      |     |     |
"           v v   v      v     v     v
set viminfo=h,'50,<10000,s1000,/1000,:1000
" use square blocks in visual block mode
set virtualedit=block



" --- Default Mappings ---
map :W :w
map :Q :q
" Map visual block mode to visual mode
nnoremap v <C-V>
nnoremap <C-V> v
vnoremap v <C-V>
vnoremap <C-V> v
" make BS/DEL work as expected in visual modes (i.e. delete the selected text)...
vmap <BS> x



" --- Functions ---

" Make the 101st column stand out
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%101v', 100)

" Highlight match when jumping to it
function! HLNext (blinktime)
    set invcursorline
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    set invcursorline
    redraw
endfunction

nnoremap <silent> n n:call HLNext(0.04)<cr>
nnoremap <silent> N N:call HLNext(0.04)<cr>

" Set chars for displaying whitespace / tabs
exec "set lcs=tab:\uBB\uBB,trail:\uB7,nbsp:~"
augroup VisibleNaughtiness
    autocmd!
    autocmd BufEnter  *       set list
    autocmd BufEnter  *.txt   set nolist
    autocmd BufEnter  *.vp*   set nolist
    autocmd BufEnter  *       if !&modifiable
    autocmd BufEnter  *           set nolist
    autocmd BufEnter  *       endif
augroup END

" Persistent undo
if has('persistent_undo')
    set undodir=$HOME/.VIM_UNDO_FILES
    set undolevels=5000
    set undofile
endif

" Only one VIM session can open a file, other will auto close
augroup NoSimultaneousEdits
    autocmd SwapExists *  let v:swapchoice = 'q'
    autocmd SwapExists *  echohl ErrorMsg
    autocmd SwapExists *  echo 'Duplicate edit session (readonly)'
    autocmd SwapExists *  echohl None
    autocmd SwapExists *  sleep 1
"    autocmd SwapExists *  call Make_session_finder( expand('<afile>') )
augroup END

" Syntax highlighting for smarty files
au BufRead,BufNewFile *.tpl set filetype=smarty
" twig syntax
au BufRead,BufNewFile *.twig set filetype=htmljinja


" --- Plugins ---

" pathogen
call pathogen#infect()

" indenting per filetype
if has('autocmd')
  filetype plugin indent on
endif

" phpdoc
source ~/.vim/php-doc.vim
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" Load matchit.vim, but only if the user hasn't installed a newer version.
if findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" search replace visual block with ctrl + r
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" powerline
set guifont=Meslo\ LG\ M\ DZ\ Regular\ for\ Powerline:h15
let g:airline_powerline_fonts = 1
set laststatus=2
