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

" First thing: enable 24-bit true colors only if your terminal supports it.
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

if has('gui_running')
    "set guifont=Menlo:h13
    "set gfn:Monaco:h13
    " no toolbar and scrollbars
    set guioptions=
    set shortmess=atI   " Don't show the intro message at start and truncate msgs (avoid press ENTER msgs)
endif

filetype plugin indent on

" Absolute Path for python3 and ruby (mainly to satisfy nvim)
let g:python3_host_prog = '/usr/bin/python3'
set completefunc=syntaxcomplete#Complete    " Ctrl-X Ctrl-U: user complete

set history=1000        " keep 1000 lines of command line history

set ttimeout            " time out for key codes
set ttimeoutlen=100     " wait up to 100ms after Esc for special key
set ttyfast
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience. TODO Is it true in general or only for Coc plugin?
set updatetime=200

set hidden
" set autoread          " sometimes I like to know if buffer has changed
set nobackup nowritebackup

set showcmd             " display incomplete commands
set wildmenu            " display completion matches in a status line
set scrolloff=3
" set number
set ruler
set colorcolumn=80

set display=truncate    " Show @@@ in the last line if it is truncated
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set list

set autoindent
set expandtab           " C/C++ will need to set to noexpandtab
set smarttab
set softtabstop=4 shiftwidth=4
set ignorecase smartcase
set nowrap

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

set incsearch

" System clipboard Ctrl-C or Ctrl-Shift-C will additionally go to `unnamedplus` if available
if has('unnamedplus')
  if has('nvim')
    set clipboard^=unnamedplus
  else
    set clipboard^=unnamedplus,autoselect,exclude:cons\|linux
  endif
else
  set clipboard^=unnamed
endif

" set shell
"if executable('zsh')
"  set shell=zsh
"else
"  set shell=bash
"endif

if has('mouse') " mouse support?
  set mouse=a
endif

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
Plug 'tpope/vim-fugitive'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'francoiscabrol/ranger.vim' | let g:ranger_map_keys = 0

Plug 'voldikss/vim-floaterm'

Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'dyng/ctrlsf.vim'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'michaeljsmith/vim-indent-object'
" Plug 'wellle/targets.vim'         " So many text objects, not used yet
call plug#end()
" === PLUGIN initialization end here

" === THEMEs and COLORs
set background=dark
let g:gruvbox_material_palette = 'mix'
let g:gruvbox_material_background = 'medium'
colorscheme gruvbox-material

" My default settings for using netrw with :Lex
let g:netrw_banner=0                " hide / unhide with Shift-I
let g:netrw_liststyle=1             " multi-columns view for files
let g:netrw_winsize=40
let g:netrw_use_errorwindow=0       " fix an annoying netrw error displayed on top vim-8.2-1988

" fugitive status line, this requires set ruler on
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" === fzf plugin
let $FZF_DEFAULT_COMMAND = 'find * -path "*/\.*"
    \ -prune -o -path "node_modules/**"
    \ -prune -o -path "target/**"
    \ -prune -o -path "dist/**"
    \ -prune -o -type f -print -o -type l -print 2> /dev/null'

" ripgrep then ag silver search
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --hidden --glob "!.git" --files --follow'
elseif executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
endif

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --glob "!.git" --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --hidden --glob "!.git" --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" === vim-floaterm
command! NNN FloatermNew nnn
command! LF FloatermNew lf
command! RangerNvim FloatermNew ranger

" === vim-grepper
let g:grepper = {}
let g:grepper.tools = ['git', 'rg', 'ag']
let g:grepper.jump = 1
let g:grepper.next_tool     = '<leader>gr'
let g:grepper.simple_prompt = 1
let g:grepper.quickfix      = 0

" === CtrlSF
let g:ctrlsf_backend = 'rg'
let g:ctrlsf_extra_backend_args = {
  \ 'rg': '--hidden',
  \ 'ag': '--hidden'
  \ }

command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'

"" LamT: integrate with ibus-bamboo
"function! ibusoff()
"  let g:ibus_prev_engine = system('ibus engine')
"  execute 'silent !ibus engine xkb:us::eng'
"endfunction
"
"function! ibuson()
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

augroup trimwhitespace
  autocmd BufWritePre * :call lamutils#TrimWhitespace()
augroup end

" === All my custom mappings start here
" global map leader should come first
let mapleader="\<space>"

" Simulate M-f and M-b as in emacs to replace for Shift Right and Left in Insert and Command mode
noremap! <Esc>f             <S-Right>
noremap! <Esc>b             <S-Left>
" C-M-u and C-M-d scroll up and down other window in normal mode; not perfect yet, should not do if reached top or bottom
nnoremap <Esc><C-d>         <C-w>w<C-d><C-w>p
nnoremap <Esc><C-u>         <C-w>w<C-u><C-w>p>

" Simulate Insert key for MacOS, rarely use anyway
inoremap <C-F12>            <Insert>

" Paste from existing selection (not from unnamedplus clipboard)
nnoremap <leader>p                  "*p

" Fuzzy search in `pwd` directory (current project)
nnoremap <silent> <leader>,         :FZF<CR>
" Fuzzy search in curent buffer directory
nnoremap <silent> <leader>.         :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent> <leader>b         :Buffers<CR>
nnoremap <silent> <leader><space>   :Rg<CR>
xnoremap <silent> <leader><space>   "sy:Rg <C-r>s<CR>
" Git Grep
nnoremap <silent> <leader>gg        :GGrep<CR>

" === convenient mappings
" visual mode pressing * or # searches for the current selection, use `//` to resume that search pattern
vnoremap <silent> * :<C-u>call lamutils#VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call lamutils#VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" change to directory of current file
nnoremap <Leader>cd                 :cd %:p:h<CR>
" maintain visual mode after shifting > and <
vnoremap < <gv
vnoremap > >gv
" write even though you did not sudo to begin with: w!!
cnoremap w!! w !sudo tee % >/dev/null
" replace all for word under cursor
nnoremap <leader>rr                 yiw:%s/\<<C-r><C-w>\>//g<left><left>
" replace all but in visual selection
xnoremap <leader>rr                 "sy:%s/\<<C-r>s\>//g<left><left>

" Ranger mappings, default current buffer directory
nnoremap <leader>rg                 :Ranger<CR>

" vim-floaterm mappings
nnoremap <leader>fr                 :RangerNvim<CR>
nnoremap <leader>fl                 :LF<CR>
nnoremap <leader>fn                 :NNN<CR>

" === grepper mappings
nnoremap <leader>gr :Grepper -tool git<cr>
" this will support much more gs + motion
nmap gs <plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

" after searching for text, this will do project wide find and replace.
nnoremap <leader>R
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -noprompt -cword<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" same as above except it works with a visual selection.
xnoremap <leader>R                     "sy
  \ :Grepper -noprompt -query '<C-r>s'<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" === CtrlSF mappings
nmap     <leader>sf <Plug>CtrlSFPrompt
vmap     <leader>sf <Plug>CtrlSFVwordPath
vmap     <leader>sF <Plug>CtrlSFVwordExec
nmap     <leader>sn <Plug>CtrlSFCwordPath
nmap     <leader>sp <Plug>CtrlSFPwordPath
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>

" === My custom mapping end here

" vim:sts=2 sw=2 et:
