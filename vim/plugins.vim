"
" vim-plug check (from https://github.com/perdy/dotfiles/blob/master/nvim/plugins.vim)
"
" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

"
" PLUGIN LIST
"
call plug#begin(expand('<sfile>:p:h') . '/plugged')
  " sensible defaults
  Plug 'tpope/vim-sensible'

  " Additional info for ga command
  Plug 'tpope/vim-characterize'

  " Terraform syntax highlighting and commands
  Plug 'hashivim/vim-terraform'

  " powershell syntax highlighting
  Plug 'pprovost/vim-ps1'

  " plist editing
  Plug 'darfink/vim-plist'

 " change/delete/add surrounding quotes/brackets/tags/etc.
  Plug 'tpope/vim-surround'

  " automatically add closing brackets/parenthesis while typing
  Plug 'm4xshen/autoclose.nvim'
  " Plug 'townk/vim-autoclose'

  " commenting lines using gc
  Plug 'tomtom/tcomment_vim'
 
  " narrow region view, open selection in a new window for editing
  Plug 'chrisbra/NrrwRgn'

  " use rainbow colors for nested parens and brackets
  Plug 'kien/rainbow_parentheses.vim'

  " git +/- signs and cmds for hunk staging and previewing and folding
  Plug 'airblade/vim-gitgutter'

  " git fugitive & line helpers
  Plug 'tpope/vim-fugitive'
  Plug 'ruanyl/vim-gh-line'

  " cool statusline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " smart '/' search
  Plug 'pgdouyon/vim-evanesco'

  " fuzzy file search
   Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
   Plug 'junegunn/fzf.vim'

  " word search
  Plug 'mileszs/ack.vim'

  " buffer manipulation
  Plug 'schickling/vim-bufonly'

  " nerdtree
  Plug 'scrooloose/nerdtree'

  " tmux
  Plug 'christoomey/vim-tmux-navigator'

  " linting
  Plug 'w0rp/ale'

  " buffer explorer
  Plug 'jlanzarotta/bufexplorer'

  " show function context
  Plug 'wellle/context.vim'
call plug#end()

"
" TMUX
"
let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_disable_when_zoomed = 1

" rainbow parentheses
augroup parentheses_configs
  autocmd VimEnter * RainbowParenthesesToggleAll
  autocmd Syntax * RainbowParenthesesLoadRound
  autocmd Syntax * RainbowParenthesesLoadSquare
  autocmd Syntax * RainbowParenthesesLoadBraces
augroup END

" gitgutter
highlight clear SignColumn
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=red
let g:gitgutter_max_signs = 500  " keep vim snappy
let g:gitgutter_sign_modified_removed = '≈'
let g:gitgutter_sign_removed_first_line = '↑'

" linting & formatting
let g:ale_fixers = { 
  \'python': ['black'],
\}
let g:ale_fix_on_save = 1
let g:ale_linters = {
  \'python': ['flake8'],
\}
let g:ale_python_flake8_options = '--max-doc-length=72' " PEP8
let g:ale_python_black_options = '--line-length=79'     " PEP8
let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_error = '😡'
let g:ale_sign_warning = '🤔'
highlight clear ALEErrorSign
highlight clear ALEWarningSign
