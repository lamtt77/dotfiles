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
  if has("gui_gtk2") || has("gui_gtk3")
    let &guifont = 'Liberation Mono 11'
  elseif has("gui_macvim")
    let &guifont = 'Monaco:h11'
  else
    let &guifont = 'Liberation Mono:h11'
  endif

  command! Bigger  let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)+1', '')
  command! Smaller let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)-1', '')

  set guioptions=a        " no toolbar and scrollbars, but autoselect on
  set vb t_vb=            " no beep nor flash please
  set guiheadroom=0
  set mousehide
  set antialias
endif
" }}}1

" === ALL Settings {{{1
" my default augroup for vimrc!
augroup vimrc
  autocmd!
augroup END

" global map leader should come first (before plugins)
let mapleader="\<space>"

let g:loaded_2html_plugin     = 1
let g:loaded_spellfile_plugin = 1   " spellvim built-in plugin

filetype plugin indent on
set completefunc  =syntaxcomplete#Complete " Ctrl-X Ctrl-U: user complete
set complete     +=kspell,d                " include #define or macro, and spelling suggestions if on
" set complete-=i                            " disable scanning included files
" set complete-=t                            " disable searching tags
set completeopt   =longest,menuone,noselect

set dictionary   +=/usr/share/dict/words   " sudo pacman -S words

set pastetoggle   =<F2>
set history       =1000 " keep 1000 lines of command line history

set timeoutlen    =500  " change back to default 1000ms if got issue
set ttimeout            " time out for key codes

" from https://github.com/vim/vim/issues/2588 - workaround to make vim recognize meta key as <M...> similar to gvim or nvim
" with some caveats, but this will fix a delay when press <Esc> in vim if using meta key mapping
if !has('gui_running')
  set ttimeoutlen=5
  " set up Meta to work properly for most keys in terminal vim
  " NOTE: these do not work: <m-space>,<m->>,<m-[>,<m-]>,<m-{up,down,left,right}>
  " NOTE: <m-@>,<m-O> only work in xterm and gvim - not st, urxvt, etc
  " NOTE: map <m-\|> or <m-bar>
  " LamT NOTE: reduce some keys to avoid issue for macvim 8.2-Patches:1-1719 on iTerm2
  " for ord in range(33,61)+range(63,90)+range(92,126)
  for ord in range(33,61)+range(63,90)+range(94,126)
    let char = ord is 34 ? '\"' : ord is 124 ? '\|' : nr2char(ord)
    exec printf("set <m-%s>=\<esc>%s", char, char)
    if exists(':tnoremap') " fix terminal control sequences
      exec printf("tnoremap <silent> <m-%s> <esc>%s", char, char)
    endif
  endfor
  " set up <c-left> and <c-right> properly
  " NOTE: if below don't work, compare with ctrl-v + CTRL-{LEFT,RIGHT} in INSERT mode
  " NOTE: <c-up>,<c-down> do not work in any terminal
  exe "set <c-right>=\<esc>[1;5C"
  exe "set <c-left>=\<esc>[1;5D"
endif

set ttyfast
" default 4000ms (4s) is not good for async operation
set updatetime    =200

set showcmd             " display incomplete commands
set wildmenu            " display completion matches in a status line
set suffixes     +=.a,.1,.class
set suffixesadd  +=.lua
set wildignore   +=*.o,*.so,*.zip,*.png,*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildoptions   =tagfile,fuzzy

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
set incsearch
set textwidth=78

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

set hidden
set autoread
" set autowrite
set nobackup nowritebackup
set noswapfile

set undofile
set undolevels=3000
set undoreload=10000

set sessionoptions-=options
set sessionoptions+=localoptions

" more scrollback lines for :term, default 10000
set termwinscroll=100000

" System clipboard Ctrl-C or Ctrl-Shift-C will additionally go to `unnamedplus` if available
if has('unnamedplus')
  " indepedently use of `+` for clipboard and `*` for autoslect
  set clipboard^=unnamedplus,autoselect,exclude:cons\|linux
else
  set clipboard^=unnamed
endif

if has('mouse')
  set mouse=a
endif
" }}}1

" === PLUGINs initialization {{{1
packadd! matchit    " built-in plugin which provides smart % XML/HTML matching.

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
Plug 'sainnhe/gruvbox-material'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-unimpaired'       " startup time a bit slow nowadays (>20ms), replaced by manual mappings
" Plug 'tpope/vim-abolish'          " easily search, substitute, abbreviate multiple version of words, coercion to camel case / snake case / dote case / title case...
" Plug 'tpope/vim-sleuth'           " automatically adjusts shiftwidth and expandtab intelligently based on the existing indentation
" Plug 'tpope/vim-projectionist'

" Plug 'moll/vim-bbye'                " optional dependency for vim-symlink, delete buffers (close files) without closing your windows or messing up your layout
" Plug 'aymericbeaumet/vim-symlink'   " fix an annoying vim-fugitive symlink issue  # by introduced other annoying issue

Plug 'junegunn/fzf',                { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim',             { 'on': 'GV'}
Plug 'junegunn/vim-easy-align'

" bug if overwin-f2 switch to a `:terminal`, only works in `nvim`
Plug 'easymotion/vim-easymotion',   { 'on': '<plug>(easymotion-overwin-f2)' }
  let g:EasyMotion_smartcase = 1

" ranger can do many things netrw can't
Plug 'francoiscabrol/ranger.vim'    | let g:ranger_map_keys = 0

Plug 'mhinz/vim-signify'
  let g:signify_vcs_list          = ['git']
  let g:signify_skip_filetype     = { 'journal': 1 }
  " let g:signify_sign_add          = '│'
  " let g:signify_sign_change       = '│'
  " let g:signify_sign_changedelete = '│'
Plug 'mhinz/vim-grepper',           { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
" TODO vim project for one specific vimrc / project + startify for startup cow
" Plug 'amiorin/vim-project'
Plug 'mhinz/vim-startify'
  let g:startify_change_to_dir       = 0
  let g:startify_custom_header       = 'startify#pad(startify#fortune#boxed())'
  let g:startify_enable_special      = 0
  let g:startify_fortune_use_unicode = 1
  let g:startify_update_oldfiles     = 1
  let g:startify_use_env             = 1
  " " LamT: not working yet
  " function! GetUniqueSessionName()
  "   let path = fnamemodify(getcwd(), ':~:t')
  "   let path = empty(path) ? 'no-project' : path
  "   let branch = gitbranch#name()
  "   let branch = empty(branch) ? '' : '-' . branch
  "   return substitute(path . branch, '/', '-', 'g')
  " endfunction
  " autocmd VimLeavePre * silent execute 'SSave! ' . GetUniqueSessionName()

Plug 'dyng/ctrlsf.vim'

Plug 'romainl/vim-qf'               | let g:qf_mapping_ack_style = 1

Plug 'michaeljsmith/vim-indent-object'
" Plug 'wellle/targets.vim'         " So many text objects, not used yet
" for more text objects visit https://github.com/kana/vim-textobj-user/wiki

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/tagalong.vim',    { 'for': 'html'}
Plug 'mattn/emmet-vim',             { 'for': 'html'}
Plug 'lifepillar/pgsql.vim',        { 'for': 'sql'}
Plug 'Lnl7/vim-nix'

" Plug 'mg979/vim-visual-multi', {'branch': 'master'}   " save 5ms startup if don't use
" Plug 'nelstrom/vim-visual-star-search'  " allows * and # searches to occur on the current visual selection
" Plug 'junegunn/limelight.vim'   " Dim paragraphs above and below the active paragraph
" Plug 'vimwiki/vimwiki'
" Plug 'lervag/vimtex'

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'dense-analysis/ale'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'benmills/vimux'
" Plug 'benmills/vimux-golang'
" Plug 'ekalinin/Dockerfile.vim'
" Plug 'hashivim/vim-terraform'
" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
"   let g:vim_markdown_folding_disabled = 1   " performance not great with big file
" Plug 'vim-vdebug/vdebug'
" Plug 'lifepillar/vim-cheat40'

Plug 'majutsushi/tagbar',           { 'on': 'TagbarToggle'}   | let g:tagbar_sort = 0
Plug 'mbbill/undotree',             { 'on': 'UndotreeToggle'} | let g:undotree_WindowLayout = 2

Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<Tab>"
  let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

Plug 'editorconfig/editorconfig-vim'
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
source ~/.vim/vim-lsp-lam.vim

" Dictionnary, thesaurus... https://github.com/Phantas0s/.dotfiles/blob/dd7f9c85353347fdf76e4847063745bacc390460/nvim/init.vim
Plug 'reedes/vim-lexical'
  let g:lexical#thesaurus = ['~/.vim/thesaurus/mthesaur.txt',]

" Plug 'puremourning/vimspector'
"   let g:vimspector_base_dir        = expand('$HOME/.vim/plugged/vimspector')
"   let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools' ]
"   let g:vimspector_enable_mappings = 'HUMAN'
call plug#end()
" }}} === PLUGIN initialization end here

" === Plugins specific settings, commands and autocmds {{{1
" === THEMEs and COLORs
set background                    =dark
let g:gruvbox_material_palette    ='mix'
let g:gruvbox_material_background ='medium'
silent! colorscheme gruvbox-material

" My default settings for using netrw with :Lex
let g:netrw_banner          =0         " hide / unhide with Shift-I
let g:netrw_liststyle       =1         " 1=long-listing 3=tree-view
" let g:netrw_winsize         =40       " default 50% seems to best alignment in most cases
let g:netrw_use_errorwindow =0         " fix an annoying netrw error displayed on top vim-8.2-1988
let g:netrw_sort_sequence   ='[\/]$,*' " sort is affecting only: directories on the top, files below

" fugitive status line, this requires set ruler on
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" DiffOrig convenient command to see the difference between the current buffer
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

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
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
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

" === vim-lsp: language server, TODO find a more valid place in ~/.vim
" refer to mappings in ~/.vim/vim-lsp-lam.vim
" === END vim-lsp

" When editing a file, always jump to the last known cursor position.
autocmd vimrc BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" Automatically reload .vimrc file on save
autocmd vimrc BufWritePost .vimrc so ~/.vimrc

" customize by filetype
autocmd vimrc FileType cpp,cxx,h,hpp,c setlocal ts=8 sts=4 sw=4 noet
autocmd vimrc FileType go,py setlocal ts=8 sw=4 expandtab
autocmd vimrc Filetype vim,js,ts,html setlocal sts=2 sw=2 expandtab

" quickly jump to header or source filetype, TODO add more filetype when needed
autocmd vimrc BufLeave *.{c,cpp} mark C
autocmd vimrc BufLeave *.h       mark H

autocmd vimrc BufWritePre * :call lamutils#TrimWhitespace()

" Open images with feh->sxiv
autocmd vimrc BufEnter *.png,*.jpg,*gif silent! exec "! sxiv ".expand("%") | :bw

" a good `steal`, looking for this behaviour for a while
augroup FORMATOPTIONS
  autocmd!
  autocmd BufWinEnter * set fo-=c fo-=r fo-=o " Disable continuation of comments to the next line
  autocmd BufWinEnter * set formatoptions+=j  " Remove a comment leader when joining lines
  autocmd BufWinEnter * set formatoptions+=l  " Don't break a line after a one-letter word
  autocmd BufWinEnter * set formatoptions+=n  " Recognize numbered lists
  autocmd BufWinEnter * set formatoptions-=q  " Don't format comments
  autocmd BufWinEnter * set formatoptions-=t  " Don't autowrap text using 'textwidth'
augroup END

augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END

" fugitive
autocmd vimrc BufReadPost fugitive:// setlocal bufhidden=delete
" }}}1

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

" === All my custom and `steal` mappings start here {{{1
" use `noremap` for almost everything, but `map` for `Plug` command, do NOT comment at the end of map

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a line break.
inoremap <C-U>          <C-G>u<C-U>

" === supercharge `valid` command-line mode <CR>, from https://gist.github.com/romainl/5b2cfb2b81f02d44e1d90b74ef555e31
" included a minor fix from https://github.com/sparkcanon/nvim/blob/9ef3e7399fc8006e5a1f14caec2cc6a7b18d4629/autoload/listcommands.vim
cnoremap <expr> <cr>    ccr#CCR()

nnoremap Y              y$

" sane windows switching like `dwm`
nnoremap  <M-j>         <C-w>w
nnoremap  <M-k>         <C-w>W
tnoremap  <M-j>         <C-w>w
tnoremap  <M-k>         <C-w>W

" C-M-u and C-M-d scroll up and down other window in normal mode
" FIXME not perfect yet, should not do if reached top or bottom and only works with gvim or nvim to avoid mapping via <Esc>
nnoremap  <C-M-d>       <C-w>w<C-d><C-w>p
nnoremap  <C-M-u>       <C-w>w<C-u><C-w>p>

" vim-rsi style, meta key in that plugin does not work properly under :terminal and `st`
inoremap  <M-b>         <S-Left>
inoremap  <M-f>         <S-Right>
inoremap  <M-d>         <C-O>dw
inoremap  <M-n>         <Down>
inoremap  <M-p>         <Up>
cnoremap  <M-b>         <S-Left>
cnoremap  <M-f>         <S-Right>
cnoremap  <M-d>         <S-Right><C-W>
cnoremap  <M-n>         <Down>
cnoremap  <M-p>         <Up>
inoremap        <C-A>   <C-O>^
inoremap   <C-X><C-A>   <C-A>
cnoremap        <C-A>   <Home>
cnoremap   <C-X><C-A>   <C-A>
inoremap <expr> <C-B>   getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap        <C-B>   <Left>
inoremap <expr> <C-D>   col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-D>   getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
inoremap <expr> <C-E>   col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
inoremap <expr> <C-F>   col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F>   getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

" Simulate Insert key for MacOS, rarely use anyway
inoremap <C-F12>     <Insert>

nnoremap <leader>w   :update<cr>
" edit macro
nnoremap <leader>M   :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" Paste from existing selection (not from unnamedplus clipboard)
nnoremap <leader>p   "*p

" Fuzzy search in `pwd` directory (current project)
nnoremap <silent> <leader>.         :FZF<cr>
" Fuzzy search in curent buffer directory
nnoremap <silent> <leader>,         :Files <C-r>=expand("%:h")<cr>/<cr>
nnoremap <silent> <leader><Enter>   :Buffers<cr>
nnoremap <silent> <leader>L         :Lines<CR>
nnoremap <silent> <leader>H         :History<CR>
nnoremap <silent> <leader>`         :Marks<CR>
nnoremap <silent> <leader><space>   :Rg<cr>
xnoremap <silent> <leader><space>   "sy:Rg <C-r>s<cr>
" All files
nnoremap <silent> <leader>A         :AF<cr>
imap     <c-x><c-j>                 <plug>(fzf-complete-file-ag)
imap     <c-x><c-l>                 <plug>(fzf-complete-line)

"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')

" similar to dired-jump in emacs
nnoremap <c-x><c-j>                 :e%:h<cr>

" === vim-startify mappings
nnoremap <silent> <leader>S         :Startify<cr>

" Git Grep
nnoremap <silent> <leader>gg        :GGrep<cr>

" === convenient mappings
" visual mode pressing * or # searches for the current selection, use `//` to resume that search pattern
vnoremap <silent> * :<C-u>call lamutils#VisualSelection('', '')<cr>/<C-r>=@/<cr><cr>
vnoremap <silent> # :<C-u>call lamutils#VisualSelection('', '')<cr>?<C-r>=@/<cr><cr>

" change to directory of current file
nnoremap <leader>cd                 :cd %:p:h<cr>
" toggle maximum current window, not fully work if having multiple tabs
nnoremap <silent> <leader>zz        :call lamutils#ZoomToggle()<cr>

" maintain visual mode after shifting > and <
vnoremap < <gv
vnoremap > >gv

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" replaced for vim-unimpaired
" Quickfix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz
" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>
" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" open newline above and below
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" move lines
" nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>
" nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap <silent> <C-k> :move-2<cr>
nnoremap <silent> <C-j> :move+<cr>
xnoremap <silent> <C-k> :move-2<cr>gv
xnoremap <silent> <C-j> :move'>+<cr>gv

" Markdown headings
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

" #!! | Shebang, a good `steal`
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)
" <leader>bs | buf-search > quickfix
nnoremap <leader>bs :cex []<BAR>bufdo vimgrepadd @@g %<BAR>cw<s-left><s-left><right>

" use command `:Su<tab>` instead, w!! will cause a minor cosmetic when typing `w` in command-line
" cnoremap w!! w !sudo tee % >/dev/null
command! SudoWrite execute 'silent! write !sudo tee % >/dev/null' | edit!

" from https://github.com/Jorengarenar/dotfiles/blob/7444acdbf50affa3f38f5711ec890395f6a9e3a6/vim/vimrc#L75
" plus: some interesting mappings, cscope, lsp: ccls, pyls, java, sqls and manual statusline
command! ExecCurrentLine normal :.w !sh<CR>
command! -range=% Sort normal :<line1>,<line2>sort i<CR>
command! SortBlock :normal! vip:sort i<CR>
" simple version of vim-easyalign, support visual selection :)
command! -range -nargs=+ Align <line1>,<line2>!column -Lts'<args>' -o'<args>'

" from https://stackoverflow.com/questions/14385998/how-can-i-execute-the-current-line-as-vim-ex-commands/14386090
" NOTE: vim vanilla way for the current line only, command-line: <C-r><C-l><cr>
":[range]Execute    Execute text lines as ex commands.
"                   Handles |line-continuation|.
" The same can be achieved via "zyy@z (or yy@" through the unnamed register);
" but there, the ex command must be preceded by a colon (i.e. :ex)
command! -bar -range Execute silent <line1>,<line2>yank z | let @z = substitute(@z, '\n\s*\\', '', 'g') | @z

" [count]<Leader>el  Execute current [count] line(s) as ex commands, then
" {Visual}<Leader>el jump to the following line (to allow speedy sequential
"                   execution of multiple lines).
nnoremap <silent> <Leader>el :Execute<Bar>execute 'normal! ' . v:count1 . 'j'<CR>
xnoremap <silent> <Leader>el :Execute<Bar>execute 'normal! ' . v:count1 . 'j'<CR>

" replace all for word under cursor, yank that word for later use anyway
nnoremap <leader>r<space>           yiw:%s/\<<C-r>0\>//g<left><left>
" replace all but in visual selection
xnoremap <leader>r<space>           "sy:%s/\<<C-r>s\>//g<left><left>

" Ranger mappings, default current buffer directory
nnoremap <leader>rg                 :Ranger<cr>
nnoremap <leader>rt                 :RangerCurrentFileNewTab<cr>

" === vim-easy-align mappings
" interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" interactive EasyAlign in visual mode (e.g. vipga) and LiveEasyAlign (C-p)
xmap ga <Plug>(EasyAlign)
xmap <Leader>ga <Plug>(LiveEasyAlign)

" === vim-easymotion mappings
map <silent>s                       <plug>(easymotion-overwin-f2)

" === grepper mappings
nnoremap <leader>gr                 :Grepper -tool git<cr>
" support much more gs + motion, use grepper because of this
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

" === CtrlSF mappings, interactively replace-all in one buffer
nmap     <leader>sf <Plug>CtrlSFPrompt
vmap     <leader>sf <Plug>CtrlSFVwordPath
vmap     <leader>sF <Plug>CtrlSFVwordExec
nmap     <leader>sn <Plug>CtrlSFCwordPath
nmap     <leader>sp <Plug>CtrlSFPwordPath
nnoremap <leader>so :CtrlSFOpen<cr>
nnoremap <leader>st :CtrlSFToggle<cr>

" === Undotree mappings
nnoremap U :UndotreeToggle<CR>

" === ultisnips mappings, type less for more
nnoremap <leader>us :Snippets<cr>

" === vim-signify mappings
nnoremap <silent><leader>hd :SignifyHunkDiff<cr>
nnoremap <silent><leader>hu :SignifyHunkUndo<cr>

" === vim-dispatch mappings - to add async for fugitive
nnoremap <leader>gps :Dispatch! :Gpush<cr>
" vim-dispatch does not support async git pull
nnoremap <leader>gpl :Gpull<cr>

" === DEBUG with TermDebug
" packadd termdebug
" let g:termdebug_wide=1
" noremap <silent> <leader>td :Termdebug<cr>
" noremap <silent> <leader>ts :Step<cr>
" noremap <silent> <leader>to :Over<cr>

" === My custom mapping end here }}}1

" vim:sts=2:sw=2:et:fdm=marker
