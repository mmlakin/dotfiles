set secure " prevent rc files from auto running dangerous cmds

source ~/.config/nvim/plugins.vim " install plugins

set nocompatible " not vim compatible
set ttyfast " make redraw quick
set mouse=a " enable mouse
set number " enable line numbers
" keep at least one line above cursor
set scrolloff=1
" copy+paste
set clipboard=unnamed
" ignore case when searching except when search includes uppercase
set ignorecase
set smartcase

set autoread
" ignore file extensions
set wildignore+=.DS_Store
set wildignore+=*.bmp,*.png,*.jpg,*.jpeg,*.gif
set wildignore+=*.so,*.swp,*.zip,*.bz2

set hidden " allow unsaved buffers to go into the background
set inccommand=nosplit " real-time replacement

" don't clutter cwd with backup and swap files
set backupdir^=~/.vim/.backup
" '//' incorporate full path into swap filenames
set dir ^=~/.vim/.backup//
" persistent undo (through file)
silent !mkdir ~/.vim/.undo > /dev/null 2>&1
set undodir=~/.vim/.undo
set undofile
"
" prevent creation of backup & swap files
set nobackup
set noswapfile
set nowb

" default replace tab with 4 spaces
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" auto change cwd to current file
set autochdir

" shell-like tab completion for file paths
set wildmode=list:longest


"""""""""""""""""""""""" MACROS + REMAPS
" leader key
let g:mapleader = "\<SPACE>"

" paste and save clipboard to registers x and y
nnoremap <Leader>p :let @x=@* \| let @y=@+ \| put<CR>

" bufexplorer shortcut
"nnoremap <Leader>ls :BufExplorerHorizontalSplit<CR>
nnoremap <Leader>l :<C-u>Buffers<CR>

" next buffer shortcut
nnoremap <Leader><Tab> :bn<CR>

" FZF shortcut
nnoremap <leader>f :<C-u>Files! ~<CR> 
