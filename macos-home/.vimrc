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

" {{{1 VIM SETTINGS
filetype plugin indent on

set nolangremap
set encoding=utf8
set ttyfast
set scrolloff=3
set synmaxcol=200       " Only highlight the first 200 columns.
" Show @@@ in the last line if it is truncated.
set display=truncate
set backspace=indent,eol,start
set hidden
set autoread
" Use visual bell instead of beeping when doing something wrong
set visualbell
set lazyredraw
" Display non printable characters
" set list              " a bit dizzy if always on
set laststatus=2

set nocursorline
set guicursor=
" set relativenumber
set number
set incsearch nohlsearch
set textwidth=79
set tabstop=8 softtabstop=4  shiftwidth=4 expandtab
set autoindent
set nowrap

set ignorecase smartcase
set nobackup nowritebackup
set swapfile

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

" System clipboard Ctrl-C or Ctrl-Shift-C will additionally go to `unnamedplus` if available
if has('unnamedplus') && ! has('nvim')
  set clipboard=unnamedplus,autoselect,exclude:cons\|linux
else
  set clipboard=unnamed
endif

set mouse=a

" spell check comments
"set spell

" default 4000ms (4s) not good for async operations
set updatetime=200

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

set colorcolumn=80
set nocursorcolumn
set history=1000

" Not needed if lightline is in-use
" set ruler		" show the cursor position all the time

set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

set foldmethod=marker
set foldopen-=hor
set foldopen+=jump
let g:vimsyn_folding = 'f'

" if executable('zsh')
"   set shell=zsh
" else
"   set shell=bash
" endif
" }}}

" PLUG {{{1
"============================== PLUGIN start here
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
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
" easily search, substitute, abbreviate multiple version of words, coercion to camel case / snake case / dote case / title case...
" Plug 'tpope/vim-abolish'
" automatically adjusts shiftwidth and expandtab intelligently based on the existing indentation"
" Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-projectionist'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'

" Plug 'easymotion/vim-easymotion'

Plug 'itchyny/lightline.vim'

"Plug 'prettier/vim-prettier', {
"  \ 'do': 'yarn install',
"  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plug 'sheerun/vim-polyglot'
" Plug 'ryanoasis/vim-devicons'

" Plug 'justinmk/vim-dirvish'       " yet to see benefit vs built-in netrw

" Match more stuff with % (html tag, LaTeX...)
" Plug 'andymass/vim-matchup'

" ranger can do many things netrw can't
Plug 'francoiscabrol/ranger.vim'    | let g:ranger_map_keys = 0

" Plug 'airblade/vim-gitgutter'

Plug 'mhinz/vim-signify'
  let g:signify_vcs_list          = ['git']
  let g:signify_skip_filetype     = { 'journal': 1 }
Plug 'mhinz/vim-grepper'

Plug 'dyng/ctrlsf.vim'

" " provides additional text objects
" Plug 'wellle/targets.vim'
" " allows * and # searches to occur on the current visual selection
" Plug 'nelstrom/vim-visual-star-search'

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Plug 'dense-analysis/ale'

" Dim paragraphs above and below the active paragraph.
Plug 'junegunn/limelight.vim'

" Plug 'christoomey/vim-tmux-navigator'
" Plug 'benmills/vimux'
" Plug 'benmills/vimux-golang'

Plug 'ekalinin/Dockerfile.vim'
Plug 'hashivim/vim-terraform'

Plug 'majutsushi/tagbar'

Plug 'romainl/vim-qf'

Plug 'michaeljsmith/vim-indent-object'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'honza/vim-snippets'

Plug 'lervag/vimtex'
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif

Plug 'vimwiki/vimwiki'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1   " performance not great with big file

Plug 'mbbill/undotree'
" Plug 'ludovicchabant/vim-gutentags'

" " vim project for one specific vimrc / project + startify for startup cow
" Plug 'amiorin/vim-project' | Plug 'mhinz/vim-startify'

" Plug 'sgur/vim-editorconfig'
Plug 'editorconfig/editorconfig-vim'

" Plug 'vim-vdebug/vdebug'

" Plug 'lifepillar/vim-cheat40'

Plug 'Lnl7/vim-nix'

" Initialize plugin system
call plug#end()

" Load up the match it built-in plugin which provides smart % XML/HTML matching.
runtime macros/matchit.vim

" }}}1

" {{{1 PLUGINS SETTINGS AND THEMES HERE

" global map leader should come first
let mapleader="\<space>"

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

" === THEMEs and COLORs
set background=dark

" let g:gruvbox_material_diagnostic_line_highlight = 1
let g:gruvbox_material_palette = 'mix'
let g:gruvbox_material_background = 'medium'
colorscheme gruvbox-material

" lightline
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox_material'

" nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
" nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
" nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>
" nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
" nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
" nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

" .............................................................................
" junegunn/limelight.vim
" .............................................................................
let g:limelight_conceal_ctermfg=244

" --- vim go (polyglot) settings.
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_types = 1
" let g:go_highlight_function_parameters = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_generate_tags = 1
" let g:go_highlight_format_strings = 1
" let g:go_highlight_variable_declarations = 1
" " let g:go_auto_sameids = 1

" .............................................................................

" My default settings for using netrw with :Lex
let g:netrw_banner          =0 " hide / unhide with Shift-I
" let g:netrw_liststyle       =3 " tree-style, still has permission denied bug if follow link
let g:netrw_liststyle       =1 " long-listing
let g:netrw_winsize         =40
let g:netrw_use_errorwindow =0

" === More USEFUL Plugins here
source ~/.vim/plugged/coc-lam.vim

" Plugin vim-go settings
" let g:go_gopls_options = ['-remote=auto']
let g:go_gopls_enabled = 0
let g:go_def_mapping_enabled = 0

" customize by filetype
augroup customizefiletype
  autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
  " c & cpp
  autocmd FileType c setlocal ts=8 sw=4 noet
  autocmd FileType cpp setlocal ts=8 sw=4 noet
  " for html files, 2 spaces
  autocmd Filetype html setlocal ts=2 sw=2 expandtab
augroup end

augroup FORMATOPTIONS
  autocmd!
  autocmd BufWinEnter * set fo-=c fo-=r fo-=o " Disable continuation of comments to the next line
  autocmd BufWinEnter * set formatoptions+=j  " Remove a comment leader when joining lines
  autocmd BufWinEnter * set formatoptions+=l  " Don't break a line after a one-letter word
  autocmd BufWinEnter * set formatoptions+=n  " Recognize numbered lists
  autocmd BufWinEnter * set formatoptions-=q  " Don't format comments
  autocmd BufWinEnter * set formatoptions-=t  " Don't autowrap text using 'textwidth'
augroup END

" === ALE Plugin settings
" let g:go_def_mapping_enabled = 1
" set omnifunc=ale#completion#OmniFunc
" let g:ale_completion_tsserver_autoimport = 1
" " Only run linters named in ale_linters settings.
" let g:ale_linters_explicit = 1

" }}}1

" {{{1 KEY MAPPINGS

" tmux plugin customize
"autocmd VimEnter,VimLeave * silent !tmux set status off

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


" visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call functions#VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call functions#VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Fuzzy search in `pwd` directory (current project)
nnoremap <silent> <leader>,         :FZF<cr>
" Fuzzy search in curent buffer directory
nnoremap <silent> <leader>.         :Files <C-r>=expand("%:h")<cr>/<cr>

nnoremap <silent> <leader><Enter>   :Buffers<cr>
nnoremap <silent> <leader>L         :Lines<CR>
nnoremap <silent> <leader>`         :Marks<CR>
nnoremap <silent> <leader><space>   :Rg<cr>
xnoremap <silent> <leader><space>   "sy:Rg <C-r>s<cr>
" All files
nnoremap <silent> <leader>af        :AF<cr>
imap     <c-x><c-j>                 <plug>(fzf-complete-file-ag)
imap     <c-x><c-l>                 <plug>(fzf-complete-line)

nnoremap <silent> <leader>ee :FZF -m<CR>
"Recovery commands from history through FZF
nmap <leader>H :History:<CR>

" vim-qf plugin
" Grep for quickfix list
" taken from https://github.com/sparkcanon/nvim/blob/master/autoload/functions.vim
command! -nargs=+ -complete=file -bar Grep  cgetexpr functions#grep(<q-args>)
" Grep for location list
command! -nargs=+ -complete=file -bar LGrep lgetexpr functions#grep(<q-args>)

" EasyAlign plugin
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Ranger mappings, default current buffer directory
nnoremap <leader>rg                 :Ranger<cr>

" Vimux plugin
map <leader>vp :VimuxPromptCommand<CR>
map <leader>vl :VimuxRunLastCommand<CR>
map <leader>vi :VimuxInspectRunner<CR>
map <leader>vz :VimuxZoomRunner<CR>

map <leader>ra :wa<CR> :GolangTestCurrentPackage<CR>
map <leader>rf :wa<CR> :GolangTestFocused<CR>

" === vim-grepper
let g:grepper = {}
let g:grepper.tools = ['git', 'rg', 'ag']
let g:grepper.jump = 1
let g:grepper.next_tool     = '<leader>gp'
let g:grepper.simple_prompt = 1
let g:grepper.quickfix      = 0
command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'

" === grepper mappings
nnoremap <leader>gp                 :Grepper -tool git<cr>
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

" replace all for word under cursor, yank that word for later use anyway
nnoremap <leader>rr                 yiw:%s/\<<C-r>0\>//g<left><left>
" replace all but in visual selection
xnoremap <leader>rr                 "sy:%s/\<<C-r>s\>//g<left><left>

" CtrlSF plugin mappings
nmap <leader>ff <Plug>CtrlSFPrompt
vmap <leader>ff <Plug>CtrlSFVwordPath
vmap <leader>fe <Plug>CtrlSFVwordExec
nmap <leader>fn <Plug>CtrlSFCwordPath
nmap <leader>fp <Plug>CtrlSFPwordPath

" Plugin Git Gutter seting
" let g:gitgutter_grep                    = 'rg'
" let g:gitgutter_map_keys                = 0
" let g:gitgutter_sign_added              = '▎'
" let g:gitgutter_sign_modified           = '▎'
" let g:gitgutter_sign_modified_removed   = '▶'
" let g:gitgutter_sign_removed            = '▶'
" let g:gitgutter_sign_removed_first_line = '◥'
" Comment out mapping as in conflicted with other plugins
" nmap [g <Plug>GitGutterPrevHunkzz
" nmap ]g <Plug>GitGutterNextHunkzz
" nmap <leader>+ <Plug>GitGutterStageHunk
" nmap <leader>- <Plug>GitGutterUndoHunk
" nmap <leader>p <Plug>GitGutterPreviewHunk

" -----------------------------------------------------------------------------
" Basic and frequent mappings
" -----------------------------------------------------------------------------

" vim-surround delete a function shorter mapping
nmap <silent> dsf ds)db

cmap W!! w !sudo tee % >/dev/null

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>
vnoremap X "_d

" maintain visual mode after shifting > and <
vmap < <gv
vmap > >gv

" replaced for vim-unimpaired
" Quickfix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz
" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>
" Tabs, only need to replace for gT, not really for gt
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

nnoremap <F5> :UndotreeToggle<cr>

" Change to Directory of Current file
nnoremap <leader>cd :cd %:p:h<CR>

augroup trimwhitespace
  autocmd BufWritePre * :call lamutils#TrimWhitespace()
augroup end

" Automatically reload .vimrc file on save
augroup myvimrc
  au!
  au BufWritePost .vimrc so ~/.vimrc
augroup END

" === DEBUG with TermDebug
packadd termdebug
let g:termdebug_wide=1
" Add mapping to load termdebug
noremap <silent> <leader>td :Termdebug<cr>
" Add mappings for :Step and :Over
noremap <silent> <leader>ts :Step<cr>
noremap <silent> <leader>to :Over<cr>
" }}}1
