""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""Global Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"modern vim, forget about vi compatibility
set nocompatible

" run the following in the shell for initial installation of plugins
" vim +PlugInstall +qall

" automatic instllation of vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" initialize plugins
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Must use single quotes

Plug 'ap/vim-css-color'
Plug 'bling/vim-airline'
Plug 'ervandew/supertab'
Plug 'haya14busa/incsearch.vim'
Plug 'haishanh/night-owl.vim'
Plug 'mattn/emmet-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
Plug 'sheerun/vim-polyglot'
Plug 'sjl/splice.vim'
Plug 'terryma/vim-expand-region'
Plug 'w0rp/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/IndexedSearch'

" Initialize plugin system
call plug#end()

" enable 24bit true color
if (has("termguicolors"))
    set termguicolors
endif

"Enable loading filetype and indentation plugins
set fileformat=unix
set ignorecase
set smartcase "overrides ignorecase if search contains uppercase
set hlsearch
set showmode "Shows the current editing mode
set noeb vb t_vb= "disable beeping
set novisualbell "disable screen blinking
set synmaxcol=0  "full syntax highlighting including long lines

set title "Set title of the window
set autoread " auto reload the file if it changes

set showcmd "show (partial) commands (or size of selection in Visual mode) in status line
set number
set relativenumber

"Always show number of lines changed
set report=0

set showmatch
set matchtime=2 "briefly jump to a matching bracket for 0.2s
set scrolljump=5 "jump 5 lines when running out of the screen

"Use 4 spaces for <Tab> and :retab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround "round indent to multiple of 'shiftwidth' for > and < commands

set termencoding=utf-8

set cursorline "Better highlighting of the current line

set magic "some characters in pattern are taken literally
set hidden "Allows u to have unwritten buffers

"Go back to the position the cursor was on the last time this file was edited
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute("normal `\"") | endif

"Use menu to show command-line completion (in 'full' case)
"improve the way autocomplete works

"Set command-line completion mode:
"   - on first <Tab>, when more than one match, list all matches and complete
"     the longest common  string
"   - on second <Tab>, complete the next full match and show menu

set wildmode=list:longest,list:full
set completeopt=menu,longest
set pumheight=15 "menu contains a max of 15 items

"change to a centralised swap directory
set directory=/tmp
set viewdir=/tmp
set undodir=/tmp
" always change to same directory as current file
set autochdir
"do not use backups
set nobackup
" use system clipboard
set clipboard=unnamed

"right clicking produces a menu
set mouse=a
set mousemodel=popup
set mousehide "hides the mouse while typing

"Show 3 lines between a change and a fold that contains unchanged lines
set diffopt+=context:3

"check if running in terminal and set to 256 colors
colorscheme night-owl

"Sign column same color as line numbers
highlight clear SignColumn

set smartindent
set foldlevelstart=99 "disable initial folding of file

set noerrorbells
set shortmess=atToOI "disable welcome message

let mapleader = " " "Set mapleader
set timeoutlen=500 "Lower the timeout after typing the leader key
set modeline
set noshowmode

set virtualedit=block "virtual edit mode in visual block so can go past EOL
set gdefault "set substitution to be global by default e.g. :s///g
set ttyfast "set fast terminal for better redrawing

set guifont=Fira\ Code\ Medium\ 11

"more natural splits
set splitright
set splitbelow

"swap exists warning, damn annoying, edit anyway
:au SwapExists * let v:swapchoice = 'e'

if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>[6 q\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>[4 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
else
	let &t_SI = "\<Esc>[6 q"
	let &t_SR = "\<Esc>[4 q"
	let &t_EI = "\<Esc>[2 q"
endif

" Remove trailing whitespace from end of file
autocmd BufWritePre * :%s/\s\+$//e

" automatically give executable permissions if file begins with #! and contains
" '/bin/' in the path
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod a+x <afile> | endif | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"fix page up and page down so that cursor doesnt move
noremap <PageUp> <C-U><C-U>
noremap <PageDown> <C-D><C-D>
inoremap <PageUp> <C-O><C-U><C-O><C-U>
inoremap <PageDown> <C-O><C-D><C-O><C-D>

"To save, press ctrl-s.
nnoremap <c-s> :up<CR>
inoremap <c-s> <Esc>:up<CR>
vnoremap <c-s> :up<CR>

" L is easier to type
noremap L $

"Y copies to end of line
noremap Y y$

" keep cursor in place when joining lines
nnoremap J mzJ`z

"visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

"Edit the vimrc file
nnoremap <silent> <leader>ev :e $HOME/.vimrc<CR>
nnoremap <silent> <leader>ez :e $HOME/.zshrc<CR>
au BufWritePost .vimrc source %

set pastetoggle=<F12>

" copy and paste to clipboard
vnoremap <C-c> "+y
map <C-v> "+P

" Automatically jump to end of text you pasted:
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Quickly select text you just pasted:
noremap gV `[v`]

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vnoremap <silent> <expr> p <sid>Repl()

nnoremap <leader>/ :noh<cr>

"prevent the f1 key from triggering
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

"prevent manual key
nnoremap K <nop>

" stop command line history
" map q: :q

"save on losing focus, saves file when tabbing away from the editor
"do not save if buffer is untitled
au FocusLost ^(\[No Name\]) :wa

"jj now exits insert mode
inoremap jj <ESC>

" absolute line numbers in insert mode, relative otherwise for easy movement
au InsertEnter * :set nu nornu
au InsertLeave * :set nu rnu

"center display after searches
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Unfuck my screen
" nnoremap <c-l> :syntax sync fromstart<cr>:redraw!<cr>

"easily enter visual block mode
nnoremap vv <C-v>

" ; is an alias for :
nnoremap ; :

" Better command line editing
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>"

" closes the buffer without closing the window
function! BufferDelete()
    if &modified
        echohl ErrorMsg
        echomsg "No write since last change. Not closing buffer."
        echohl NONE
    else
        let s:total_nr_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

        if s:total_nr_buffers == 1
            bdelete
            echo "Buffer deleted. Created new buffer."
        else
            bprevious
            bdelete #
            echo "Buffer deleted."
        endif
    endif
endfunction
cnoremap BD :call BufferDelete()<CR>

" inserts the super(<class_name>, self).<method_name>(<method_args>) for
" python
nnoremap <leader>s mz?^class<CR>w"cyiw'zasuper(<C-R>c, self).<C-C>?def <CR>w"cy$gi<C-R>c<C-C>x%ldW:s/=.\{-\},/,/e<CR>:noh<CR>$

" for when we forget to use sudo to open/edit a file
cnoremap w!! w !sudo tee % >/dev/null

"easier split navigation
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

"easier buffer navigation
nnoremap <C-Tab> :bnext<cr>
nnoremap <C-S-Tab> :bprevious<cr>

"open help in a vertical split
cnoremap vh :vert help

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"REMAPS TO PREVENT BAD HABITS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <esc> <nop>

"mappings for convenience of browsing lines
"gj and gk now perform up and down on real lines instead
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ag.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:agprg="rg --column --nocolor --smart-case"
" Ag opens the first match in a buffer as the default, super annoying
nnoremap <leader>a :Ag!<Space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" search project directory
noremap <leader>pf :GFiles<cr>
"search buffer
noremap <leader>bb :Buffers<cr>
"search MRU
noremap <leader>fr :History<cr>
"search lines in current file
noremap <leader>ss :BLines<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Splice
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let splice_initial_layout_grid = 1
let splice_initial_mode = "grid"
let splice_initial_scrollbind_grid = 1
let splice_initial_scrollbind_loupe = 1
let splice_initial_scrollbind_compare = 1
let splice_initial_scrollbind_path = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Airline (Statusbar)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:powerline_loaded = 1
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_min_count = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Supertab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = "context"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_signs = 0
let g:syntastic_enable_balloons  =  1
let g:syntastic_enable_highlighting  =  0
let g:syntastic_auto_loc_list = 1
let g:syntastic_python_checkers = ['flake8']
if executable('flake8-python2')
    let g:syntastic_python_flake8_exec = 'flake8-python2'
endif
let g:syntastic_python_flake8_args = '--max-complexity 10 --ignore="E122,E124,E126,E127,E128"'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE (Asynchronous Lint Engine)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_fixers = {}
let g:ale_javascript_prettier_options = '--print-width 1000 --no-semi --tab-width 4 --trailing-comma es5'
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['python'] = ['yapf']
let g:ale_fix_on_save = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Incsearch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#consistent_n_direction = 1
let g:incsearch#do_not_save_error_message_history = 1
let g:incsearch#magic = '\v' " very magic (sane use of regexes for searching)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Expand Region
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" hitting v multiple times expands the selection
vmap v <Plug>(expand_region_expand)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jsx_ext_required = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let python_highlight_all=1
au FileType python setlocal colorcolumn=80 commentstring=#%s

" Automatic syntax highlighting for django template files
au BufRead,BufNewFile *.html set filetype=htmldjango

" disable the linting from python-mode
let g:pymode_lint = 0

" disable rope
let g:pymode_rope = 0

" jedi related
let g:jedi#auto_initialization = 1
let g:jedi#documentation_command = '<leader>k'
let g:jedi#popup_on_dot = 0
