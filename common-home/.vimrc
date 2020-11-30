" === First thing: enable 24-bit true colors only if your terminal supports it. {{{1
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
  "let &guifont = 'Monaco:h13'
  set guioptions=a        " no toolbar and scrollbars
  set mousehide
  command! Bigger  let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)+1', '')
  command! Smaller let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)-1', '')
endif
" }}}1

" === ALL Settings {{{1
" ideally just one common augroup for vimrc!
augroup vimrc
  autocmd!
augroup END

" Absolute Path for python3 and ruby (mainly to satisfy nvim)
let g:python3_host_prog = '/usr/bin/python3'

let g:loaded_2html_plugin     = 1
let g:loaded_spellfile_plugin = 1   " spellvim built-in plugin

filetype plugin indent on
set completefunc  =syntaxcomplete#Complete " Ctrl-X Ctrl-U: user complete
set complete     +=d    " include #define or macro

set pastetoggle   =<F2>
set history       =1000 " keep 1000 lines of command line history

set timeoutlen    =500  " change back to default 1000ms if got issue
set ttimeout            " time out for key codes
set ttimeoutlen   =10   " wait only up to 10ms after Esc for special key
set ttyfast
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience. TODO Is it true in general or only for Coc plugin?
set updatetime    =300

set hidden
" set autoread          " sometimes I like to know if buffer has changed
" set autowrite
set nobackup nowritebackup

set showcmd             " display incomplete commands
set wildmenu            " display completion matches in a status line
set suffixes     +=.a,.1,.class
set wildignore   +=*.o,*.so,*.zip,*.png
set wildoptions   =tagfile

set laststatus    =2
set scrolloff     =3
" set number
set ruler
set colorcolumn   =80

set shortmess     =aIT
set display       =truncate " Show @@@ in the last line if it is truncated
set lazyredraw
set list

" customized from https://github.com/mhinz/dotfiles/blob/master/.vim/vimrc
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
  let &showbreak = '↪ '
  autocmd vimrc InsertEnter * set listchars-=trail:⣿
  autocmd vimrc InsertLeave * set listchars+=trail:⣿
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
  let &showbreak = '-> '
  autocmd vimrc InsertEnter * set listchars-=trail:.
  autocmd vimrc InsertLeave * set listchars+=trail:.
endif

" spelling
set spellfile         =~/.vim/spell/en.utf-8.add
set spelllang         =en

" set diffopt          +=vertical,foldcolumn:0,indent-heuristic,algorithm:patience
set foldmethod        =marker
set foldopen         -=hor
set foldopen         +=jump
let g:vimsyn_folding  ='f'

set autoindent
set smarttab
set shiftround
set softtabstop=2 shiftwidth=2 expandtab
set ignorecase smartcase
set infercase           " smarter keyword completion
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

set noswapfile
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
" }}}

" === PLUGINs initialization {{{1
" Load up the match it built-in plugin which provides smart % XML/HTML matching.
runtime macros/matchit.vim

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
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" offload a bunch of my manual emacs-like mappings, remember <C-X><C-A> replaced for the old <C-A> in insert and command mode
Plug 'tpope/vim-rsi'

Plug 'junegunn/fzf',             { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim',          { 'on': 'GV'}
Plug 'junegunn/vim-easy-align'

" ranger can do many things netrw can't
Plug 'francoiscabrol/ranger.vim' | let g:ranger_map_keys = 0

Plug 'voldikss/vim-floaterm'

Plug 'mhinz/vim-grepper',        { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'dyng/ctrlsf.vim'

Plug 'romainl/vim-qf'            | let g:qf_mapping_ack_style = 1

" Plug 'mg979/vim-visual-multi', {'branch': 'master'}   " save 5ms startup if don't use

Plug 'michaeljsmith/vim-indent-object'
" Plug 'wellle/targets.vim'         " So many text objects, not used yet

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/tagalong.vim', { 'for': 'html'}
Plug 'mattn/emmet-vim',          { 'for': 'html'}
Plug 'lifepillar/pgsql.vim',     { 'for': 'sql'}
" Plug 'honza/vim-snippets'

Plug 'majutsushi/tagbar',        { 'on': 'TagbarToggle'}
Plug 'mbbill/undotree',          { 'on': 'UndotreeToggle'}

" from https://github.com/Phantas0s/.dotfiles/blob/dd7f9c85353347fdf76e4847063745bacc390460/nvim/init.vim
" Plug 'reedes/vim-lexical' " Dictionnary, thesaurus...
call plug#end()
" }}} === PLUGIN initialization end here

" === THEMEs and COLORs
set background                    =dark
let g:gruvbox_material_palette    ='mix'
let g:gruvbox_material_background ='medium'
colorscheme gruvbox-material

" My default settings for using netrw with :Lex
let g:netrw_banner          =0 " hide / unhide with Shift-I
let g:netrw_liststyle       =1 " multi-columns view for files
let g:netrw_winsize         =40
let g:netrw_use_errorwindow =0 " fix an annoying netrw error displayed on top vim-8.2-1988

" DiffOrig convenient command to see the difference between the current buffer
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

" fugitive status line, this requires set ruler on
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" === fzf plugin
let $FZF_DEFAULT_OPTS .= ' --inline-info'

let $FZF_DEFAULT_COMMAND = 'find * -path "*/\.*"
  \ -prune -o -path "node_modules/**"
  \ -prune -o -path "target/**"
  \ -prune -o -path "dist/**"
  \ -prune -o -type f -print -o -type l -print 2> /dev/null'

" ripgrep then ag silver search
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --hidden --glob "!.git" --files --follow'
  set grepprg=rg\ --hidden\ --vimgrep\ --glob\ '!*{.git,node_modules,build,bin,obj,tags}'
elseif executable('ag')
 https://github.com/junegunn/dotfiles/blob/master/vimrc let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --hidden\ --vimgrep
endif

" All files with `fd`, from https://github.com/junegunn/dotfiles/blob/master/vimrc
command! -nargs=? -complete=dir AF
  \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
  \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
  \ })))

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

" === supercharge default `:grep`, from https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3#file-grep-vim
" this would require properly set grepprg; alternatively type `:gr` or `:lgr` to use the legacy ones
function! Grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

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
command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'

" === CtrlSF
let g:ctrlsf_backend = 'rg'
let g:ctrlsf_extra_backend_args = {
  \ 'rg': '--hidden',
  \ 'ag': '--hidden'
  \ }

" === LamT: integrate with ibus-bamboo {{{1
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
" === end integration }}}

" When editing a file, always jump to the last known cursor position.
autocmd vimrc BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" Automatically reload .vimrc file on save
autocmd vimrc BufWritePost .vimrc so ~/.vimrc

" customize by filetype
autocmd vimrc FileType cpp,cxx,h,hpp,c setlocal ts=8 sw=4 noet
autocmd vimrc FileType go,py setlocal ts=8 sw=4 expandtab
autocmd vimrc Filetype vim,js,ts,html setlocal sts=2 sw=2 expandtab

autocmd vimrc BufWritePre * :call lamutils#TrimWhitespace()

" Open images with feh->sxiv
autocmd vimrc BufEnter *.png,*.jpg,*gif silent! exec "! sxiv ".expand("%") | :bw

" === All my custom and `steal` mappings start here {{{1
" global map leader should come first
let mapleader="\<space>"

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U>       <C-G>u<C-U>

" === supercharge `valid` command-line mode <CR>, from https://gist.github.com/romainl/5b2cfb2b81f02d44e1d90b74ef555e31
" included a minor fix from https://github.com/sparkcanon/nvim/blob/9ef3e7399fc8006e5a1f14caec2cc6a7b18d4629/autoload/listcommands.vim
cnoremap <expr> <cr> ccr#CCR()

nnoremap Y           y$

" sane windows switching like `dwm`, must switch to <M-...> for `nvim`
nnoremap <Esc>j      <C-w>w
nnoremap <Esc>k      <C-w>W
tnoremap <Esc>j      <C-w>w
tnoremap <Esc>k      <C-w>W
" C-M-u and C-M-d scroll up and down other window in normal mode; not perfect yet, should not do if reached top or bottom
nnoremap <Esc><C-d>  <C-w>w<C-d><C-w>p
nnoremap <Esc><C-u>  <C-w>w<C-u><C-w>p>

" Simulate Insert key for MacOS, rarely use anyway
inoremap <C-F12>     <Insert>

nnoremap <leader>w   :update<cr>
" edit macro
nnoremap <leader>M   :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" Paste from existing selection (not from unnamedplus clipboard)
nnoremap <leader>p   "*p

" Fuzzy search in `pwd` directory (current project)
nnoremap <silent> <leader>,         :FZF<cr>
" Fuzzy search in curent buffer directory
nnoremap <silent> <leader>.         :Files <C-r>=expand("%:h")<cr>/<cr>
nnoremap <silent> <leader><Enter>   :Buffers<cr>
nnoremap <silent> <Leader>L         :Lines<CR>
nnoremap <silent> <Leader>`         :Marks<CR>
nnoremap <silent> <leader><space>   :Rg<cr>
xnoremap <silent> <leader><space>   "sy:Rg <C-r>s<cr>
" All files
nnoremap <silent> <leader>af        :AF<cr>
imap     <c-x><c-j>                 <plug>(fzf-complete-file-ag)
imap     <c-x><c-l>                 <plug>(fzf-complete-line)

"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')

" Git Grep
nnoremap <silent> <leader>gg        :GGrep<cr>

" === convenient mappings
" visual mode pressing * or # searches for the current selection, use `//` to resume that search pattern
vnoremap <silent> * :<C-u>call lamutils#VisualSelection('', '')<cr>/<C-r>=@/<cr><cr>
vnoremap <silent> # :<C-u>call lamutils#VisualSelection('', '')<cr>?<C-r>=@/<cr><cr>

" change to directory of current file
nnoremap <leader>cd                 :cd %:p:h<cr>
" toggle maximum current window
nnoremap <silent> <leader>zz        :call lamutils#ZoomToggle()<cr>

" maintain visual mode after shifting > and <
vnoremap < <gv
vnoremap > >gv

" Quickfix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" move lines
nnoremap <silent> <C-k> :move-2<cr>
nnoremap <silent> <C-j> :move+<cr>
xnoremap <silent> <C-k> :move-2<cr>gv
xnoremap <silent> <C-j> :move'>+<cr>gv

"" Markdown headings
"nnoremap <leader>1 m`yypVr=``
"nnoremap <leader>2 m`yypVr-``
"nnoremap <leader>3 m`^i### <esc>``4l
"nnoremap <leader>4 m`^i#### <esc>``5l
"nnoremap <leader>5 m`^i##### <esc>``6l

" #!! | Shebang, some good `steal`
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)
" <leader>bs | buf-search
nnoremap <leader>bs :cex []<BAR>bufdo vimgrepadd @@g %<BAR>cw<s-left><s-left><right>

" write even though you did not sudo to begin with: w!!
cnoremap w!! w !sudo tee % >/dev/null
" replace all for word under cursor, yank that word for later use anyway
nnoremap <leader>rr                 yiw:%s/\<<C-r>0\>//g<left><left>
" replace all but in visual selection
xnoremap <leader>rr                 "sy:%s/\<<C-r>s\>//g<left><left>

" Ranger mappings, default current buffer directory
nnoremap <leader>rg                 :Ranger<cr>

" vim-floaterm mappings
nnoremap <leader>fr                 :RangerNvim<cr>
nnoremap <leader>fl                 :LF<cr>
nnoremap <leader>fn                 :NNN<cr>

" === vim-easy-align mappings
" interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" interactive EasyAlign in visual mode (e.g. vipga) and LiveEasyAlign (C-p)
xmap ga <Plug>(EasyAlign)
xmap <Leader>ga <Plug>(LiveEasyAlign)
" from https://github.com/junegunn/dotfiles/blob/master/vimrc
nnoremap <buffer> <leader>a[        vi[<c-v>$:EasyAlign\ g/^\S/<cr>gv=
nnoremap <buffer> <leader>a{        vi{<c-v>$:EasyAlign\ g/^\S/<cr>gv=
nnoremap <buffer> <leader>a(        vi(<c-v>$:EasyAlign\ <cr>gv=

" === grepper mappings
nnoremap <leader>gr :Grepper -tool git<cr>
" this will support much more gs + motion
nmap gs <plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

" after searching for text, this will do project wide find and replace.
nnoremap <leader>R
  \ :let @s='\<'.expand('<cword>').'\>'<cr>
  \ :Grepper -noprompt -cword<cr>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" same as above except it works with a visual selection.
xnoremap <leader>R                  "sy
  \ :Grepper -noprompt -query '<C-r>s'<cr>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" === CtrlSF mappings
nmap     <leader>sf <Plug>CtrlSFPrompt
vmap     <leader>sf <Plug>CtrlSFVwordPath
vmap     <leader>sF <Plug>CtrlSFVwordExec
nmap     <leader>sn <Plug>CtrlSFCwordPath
nmap     <leader>sp <Plug>CtrlSFPwordPath
nnoremap <leader>so :CtrlSFOpen<cr>
nnoremap <leader>st :CtrlSFToggle<cr>

"" === DEBUG with TermDebug
"packadd termdebug
"let g:termdebug_wide=1
"noremap <silent> <leader>td :Termdebug<cr>
"noremap <silent> <leader>ts :Step<cr>
"noremap <silent> <leader>to :Over<cr>

" }}} === My custom mapping end here

" vim:sts=2 sw=2 et:foldmethod=marker
