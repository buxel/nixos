set encoding=utf-8                     " always use the good encoding
set mouse=a                            " allow the mouse to be used
set title                              " set the window's title to the current filename
set visualbell                         " no more beeping from Vim
set cursorline                         " highlight current line
set fillchars=vert:│                   " Solid line for vsplit separator
set showmode                           " show what mode (Insert/Normal/Visual) is currently on
set timeoutlen=500
set number                             " show line numbers
set wildmode=list:longest,list:full
set redrawtime=10000

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Whitespace
set nowrap
set tabstop=2                           " number of visual spaces per tab
set softtabstop=2                       " number of spaces in tab when editing
set expandtab                           " tabs are spaces!
set shiftwidth=2                        " how many spaces to indent/outdent

" Visual shifting (builtin-repeat)
vmap < <gv
vmap > >gv

" Better visual block selecting
set virtualedit+=block
set virtualedit+=insert
set virtualedit+=onemore

" Hide buffers or auto-save?
set hidden       " allow unsaved buffers to be hidden

" Alt-tab between buffers
nnoremap <leader><leader> <C-^>

" Make 'Y' follow 'D' and 'C' conventions'
nnoremap Y y$

" sudo & write if you forget to sudo first
cmap w!! w !sudo tee % >/dev/null

" Let split windows be different sizes
set noequalalways

" Rewrap paragraph
noremap Q gqip

" Use modeline overrides
set modeline
set modelines=10

" Remap ; to : in visual mode
nnoremap ; :

" If in Visual Mode, resize window instead of changing focus. Ctrl-[h,j,k,l]
vnoremap <c-j> <c-w>+
vnoremap <c-k> <c-w>-
vnoremap <c-h> <c-w><
vnoremap <c-l> <c-w>>

vnoremap <M-j> <c-w>+
vnoremap <M-k> <c-w>-
vnoremap <M-h> <c-w><
vnoremap <M-l> <c-w>>

" Let directional keys work in Insert Mode. Ctrl-[h,j,k,l]
inoremap <c-j> <Down>
inoremap <c-k> <Up>
inoremap <c-h> <Left>
inoremap <c-l> <Right>

" Cursor movement in command mode
cnoremap <c-j> <Down>
cnoremap <c-k> <Up>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>
cnoremap <c-x> <Del>
cnoremap <c-z> <BS>
cnoremap <c-v> <c-r>"

" Searching
set hlsearch
set ignorecase
set smartcase
set gdefault

" F5 will remove trailing whitespace and tabs
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" Clear search with comma-space
noremap <leader><space> :noh<CR>:match none<CR>:2match none<CR>:3match none<CR>

" augroup hypr_ftdetect
"   au!
"   au BufRead,BufNewFile *hypr/*.conf,*hypr/*/*.conf,*hyprland/*.conf,*hyprland/*/*.conf set ft=hypr
" augroup END
