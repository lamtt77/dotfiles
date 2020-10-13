set history=200		" keep 200 lines of command line history
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate
set incsearch

if &t_Co > 2 || has("gui_running")
  syntax on
endif

filetype plugin indent on

" LamT: starting here
set mouse-=a
