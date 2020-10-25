set history=200		" keep 200 lines of command line history
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

set nobackup nowritebackup

if isdirectory($HOME . '/.vim/swapdir') == 0
  :silent !mkdir -p ~/.vim/swapdir >/dev/null 2>&1
endif
set directory=~/.vim/swapdir//

if isdirectory($HOME . '/.vim/undodir') == 0
  :silent !mkdir -p ~/.vim/undodir >/dev/null 2>&1
endif
set undodir=~/.vim/undodir//

if isdirectory($HOME . '/.vim/viewdir') == 0
  :silent !mkdir -p ~/.vim/viewdir >/dev/null 2>&1
endif
set viewdir=~/.vim/viewdir//

set undofile
set undolevels=3000
set undoreload=10000

" Show @@@ in the last line if it is truncated.
set display=truncate
set incsearch

if &t_Co > 2 || has("gui_running")
  syntax on
endif

filetype plugin indent on

" Yank and paste with the system clipboard
set clipboard=unnamed
" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

set mouse=a
