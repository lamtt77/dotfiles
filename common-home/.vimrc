" {{{1 VIM RECOMMENDED DEFAULT SETTINGS

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Put these in an autocmd group, so that you can revert them with:
" ":augroup vimStartup | au! | augroup END"
augroup vimStartup
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

" }}}1

filetype plugin indent on
set history=200		" keep 200 lines of command line history
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key
set ttyfast
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience. Is it true?
set updatetime=200

set hidden
set nobackup nowritebackup
set number ruler
set colorcolumn=80

set smartindent
set expandtab
set softtabstop=4
set ignorecase smartcase

" LamT: taken from Arch
" Move temporary files to a secure location to protect against CVE-2017-1000382
if exists('$XDG_CACHE_HOME')
  let &g:directory=$XDG_CACHE_HOME
else
  let &g:directory=$HOME . '/.cache'
endif
let &g:backupdir=&g:directory . '/vim/backup//'
let &g:undodir=&g:directory . '/vim/undo//'
let &g:viewdir=&g:directory . '/vim/view//'
let &g:directory.='/vim/swap//'

" Create directories if they doesn't exist
if ! isdirectory(expand(&g:directory))
  silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if ! isdirectory(expand(&g:backupdir))
  silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if ! isdirectory(expand(&g:undodir))
  silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif
if ! isdirectory(expand(&g:viewdir))
  silent! call mkdir(expand(&g:viewdir), 'p', 0700)
endif

set undofile
set undolevels=3000
set undoreload=10000

" Show @@@ in the last line if it is truncated.
set display=truncate
set incsearch

" System clipboard Ctrl-C or Ctrl-Shift-C will additionally go to `unnamedplus` if available
if has('unnamedplus')
  set clipboard=unnamedplus,autoselect,exclude:cons\|linux
else
  set clipboard=unnamed
endif

set mouse=a

" === PLUGIN initialization start here
let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
Plug 'sainnhe/gruvbox-material'
call plug#end()
" === PLUGIN initialization end here

" === THEMEs and COLORs
set background=dark
let g:gruvbox_material_palette = 'mix'
let g:gruvbox_material_background = 'medium'
colorscheme gruvbox-material

" Enable 24-bit true colors only if your terminal supports it.
let colorterm=$COLORTERM
if colorterm =~# 'truecolor' || colorterm =~# '24bit'
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" syntax setting must come after termguicolors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

"" LamT: integrate with ibus-bamboo
"function! IBusOff()
"  let g:ibus_prev_engine = system('ibus engine')
"  execute 'silent !ibus engine xkb:us::eng'
"endfunction
"
"function! IBusOn()
"  let l:current_engine = system('ibus engine')
"  if l:current_engine !~? 'xkb:us::eng'
"    let g:ibus_prev_engine = l:current_engine
"  endif
"  execute 'silent !' . 'ibus engine ' . g:ibus_prev_engine
"endfunction
"
"augroup IBusHandler
"  autocmd CmdLineEnter [/?] call IBusOn()
"  autocmd CmdLineLeave [/?] call IBusOff()
"  autocmd InsertEnter * call IBusOn()
"  autocmd InsertLeave * call IBusOff()
"augroup END
"
"call IBusOff()
"" === end integration

" === My custom mapping start here
" global map leader should come first
let mapleader="\<space>"

" Simulate M-f and M-b as in emacs to replace for Shift Right and Left in
" Insert and Command mode
noremap! <Esc>f <S-Right>
noremap! <Esc>b <S-Left>

" C-M-u and C-M-d scroll up and down other window in normal mode; not perfect
" yet, should not do if reached top or bottom
nnoremap <Esc><C-d> <C-w>w<C-d><C-w>p
nnoremap <Esc><C-u> <C-w>w<C-u><C-w>p>

" Paste from existing selection (not from unnamedplus clipboard)
nnoremap <leader>p "*p
" === My custom mapping end here
