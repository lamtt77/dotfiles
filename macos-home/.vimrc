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
syntax on
filetype plugin indent on
" Absolute Path for python3 and ruby (mainly to satisfy nvim)
let g:python3_host_prog = '/usr/local/opt/python@3.8/bin/python3'
let g:ruby_host_prog = '/usr/local/lib/ruby/gems/2.7.0/bin/neovim-ruby-host'

set nolangremap
set encoding=utf8
set ttyfast
set scrolloff=3
set synmaxcol=200       " Only highlight the first 200 columns.
" Show @@@ in the last line if it is truncated.
set display=truncate
set backspace=indent,eol,start
set hidden
" Use visual bell instead of beeping when doing something wrong
set visualbell
set lazyredraw
" Display non printable characters
" set list              " a bit dizzy if always on
set laststatus=2
set autoread

" LamT: default vim seems OK
"set splitbelow
"set splitright

set nocursorline
set guicursor=
" set relativenumber
set number
set incsearch nohlsearch
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
set autoindent
set wrap

set ignorecase smartcase
set nobackup nowritebackup
set swapfile

set directory=~/.vim/swapdir//
set undodir=~/.vim/undodir//
set viewdir=~/.vim/viewdir//
set undofile
set undolevels=3000
set undoreload=10000

" Yank and paste with the system clipboard
set clipboard=unnamed
" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

set mouse=a

" spell check comments
"set spell

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=200

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

set colorcolumn=81
highlight ColorColumn ctermbg=0 guibg=lightgrey
set nocursorcolumn
set history=200

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

set foldmethod=marker
set foldopen-=hor
set foldopen+=jump

let g:vimsyn_folding = 'f'
" }}}

" PLUG {{{1
"============================== PLUGIN start here
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
" Plug 'joshdick/onedark.vim'
Plug 'sainnhe/gruvbox-material'

" Plug 'sheerun/vim-polyglot'
"Plug 'prettier/vim-prettier', {
"  \ 'do': 'yarn install',
"  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'

" Plug 'ryanoasis/vim-devicons'

" Plug 'justinmk/vim-dirvish'       " yet to see benefit vs built-in netrw

Plug 'itchyny/lightline.vim'

" Match more stuff with % (html tag, LaTeX...)
Plug 'andymass/vim-matchup'

" Plug 'justinmk/vim-sneak' | let g:sneak#label = 1 | let g:sneak#map_netrw = 0
" Plug 'easymotion/vim-easymotion'

" easily search, substitute, abbreviate multiple version of words, coercion to camel case / snake case / dote case / title case...
" Plug 'tpope/vim-abolish'
" surrounding text objects with whatever you want (paranthesis, quotes, html tags...)
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" Plug 'preservim/nerdcommenter'
" automatically adjusts shiftwidth and expandtab intelligently based on the existing indentation"
Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-projectionist'
" " enhances the . operator to work as one would expect with a number of Vim plugins
" Plug 'tpope/vim-repeat'
" " provides a set of mappings for many operations that have natural pairings
" Plug 'tpope/vim-unimpaired'

" Plug 'airblade/vim-gitgutter'

" " provides additional text objects
" Plug 'wellle/targets.vim'
" " allows * and # searches to occur on the current visual selection
" Plug 'nelstrom/vim-visual-star-search'

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Let test if vimproc could impore VIM async call performance?
" let g:make = 'gmake'
" if exists('make')
"   let g:make = 'make'
" endif
" Plug 'Shougo/vimproc.vim', {'do': g:make}

Plug 'dense-analysis/ale'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  " Way too big memory footprint with YCM -- may cause me drop vim for vscode
  " Plug 'ycm-core/YouCompleteMe'
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'mhinz/vim-grepper'
Plug 'dyng/ctrlsf.vim'

" Dim paragraphs above and below the active paragraph.
Plug 'junegunn/limelight.vim'

" Plug 'christoomey/vim-tmux-navigator'
" Plug 'benmills/vimux'
" Plug 'benmills/vimux-golang'

Plug 'ekalinin/Dockerfile.vim'
Plug 'hashivim/vim-terraform'

Plug 'majutsushi/tagbar'

" Plug 'kana/vim-arpeggio'

Plug 'romainl/vim-qf'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'honza/vim-snippets'

"Plug 'lervag/vimtex'
"if has('nvim')
"  let g:vimtex_compiler_progname = 'nvr'
"endif

Plug 'vimwiki/vimwiki'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'mbbill/undotree'
" Plug 'ludovicchabant/vim-gutentags'

" " vim project for one specific vimrc / project + startify for startup cow
" Plug 'amiorin/vim-project' | Plug 'mhinz/vim-startify'

" Plug 'sgur/vim-editorconfig'
" Plug 'editorconfig/editorconfig-vim'

" Plug 'vim-vdebug/vdebug'

" Plug 'lifepillar/vim-cheat40'

" Initialize plugin system
call plug#end()

" Load up the match it built-in plugin which provides smart % XML/HTML matching.
" runtime macros/matchit.vim

" }}}1

" {{{1 PLUGINS SETTINGS AND THEMES HERE

" global map leader should come first
let mapleader="\<space>"

" === THEMEs and COLORs
set background=dark

" `material`: Carefully designed to have a soft contrast.
" `mix`: Color palette obtained by calculating the mean of the other two.
" `original`: The color palette used in the original gruvbox.
" let g:gruvbox_material_diagnostic_line_highlight = 1
let g:gruvbox_material_palette = 'mix'
" set contrast - available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'medium'
colorscheme gruvbox-material

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

" Enable 24-bit true colors only if your terminal supports it.
let colorterm=$COLORTERM
if colorterm =~# 'truecolor' || colorterm =~# '24bit'
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

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
let g:netrw_banner=0      " hide / unhide with Shift-I
let g:netrw_liststyle=2   " multi-columns view for files
let g:netrw_winsize=40

" === More USEFUL Plugins here

" Sourcing for Coc settings
source ~/.vim/plugged/coc-lam.vim

" Plugin vim-go settings
" let g:go_gopls_options = ['-remote=auto']
let g:go_gopls_enabled = 0

func GoDeoplete()
  :silent CocDisable

  let g:go_gopls_options = ['-remote=auto']
  let g:go_def_mapping_enabled = 1
  let g:go_gopls_enabled = 1

  set completeopt+=noselect
  call deoplete#enable()
  call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
  " close preview window after CompleteDone
  autocmd CompleteDone * silent! pclose!
endfun

func GoCoc()
  let g:go_def_mapping_enabled = 0
  call deoplete#disable()
  :CocEnable
endfun

if has('nvim')
  " autocmd FileType go :call GoDeoplete()
  autocmd FileType go,py,js,ts,cpp,cxx,h,hpp,c :call GoCoc()
else
  " autocmd FileType go :call GoYCM()
  autocmd FileType go :call GoDeoplete()
  autocmd FileType py,js,ts,cpp,cxx,h,hpp,c :call GoCoc()
endif

" customize by filetype
augroup customizefiletype
  au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
  " c
  autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab
  " for html files, 2 spaces
  autocmd Filetype html setlocal ts=2 sw=2 expandtab
augroup end

" === ALE Plugin settings
" let g:go_def_mapping_enabled = 1
" set omnifunc=ale#completion#OmniFunc
" let g:ale_completion_tsserver_autoimport = 1
" " Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" }}}1

" {{{1 KEY MAPPINGS

" tmux plugin customize
"autocmd VimEnter,VimLeave * silent !tmux set status off

" fzf plugin
let $FZF_DEFAULT_COMMAND = "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" ripgrep then ag silver search
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  let g:rg_derive_root='true'
  set grepformat=%f:%l:%c:%m,%f:%l:%m,%f
  command! -bang -nargs=* Find call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --fixed-strings --smart-case
    \ --hidden --follow --glob "!.git/*" --color "always"
    \ '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
elseif executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call functions#VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call functions#VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Fuzzy search in `pwd` directory
nnoremap <silent> <leader>, :Files<CR>
" Fuzzy search in curent buffer directory
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>

nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>ee :FZF -m<CR>
"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

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

" arpeggio (chords) plugin
" call arpeggio#load()
" Arpeggio inoremap jk <Esc>

" let g:UltiSnipsExpandTrigger="<c-s>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" Vimux plugin
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>
" Zoom the tmux runner pane
map <Leader>vz :VimuxZoomRunner<CR>

map <Leader>ra :wa<CR> :GolangTestCurrentPackage<CR>
map <Leader>rf :wa<CR> :GolangTestFocused<CR>

" .............................................................................
" mhinz/vim-grepper
let g:grepper = {}
" let g:grepper.tools = ['git', 'ag', 'rg']
let g:grepper.tools = ["rg"]
let g:grepper.jump = 1
" nnoremap <leader>G :Grepper -tool git<cr>
nnoremap <leader>gg :Grepper -tool rg<cr>
" nnoremap gs :Grepper -cword -noprompt<CR>
" this will support much more gs + motion
nmap gs <plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

" After searching for text, press this mapping to do a project wide find and
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <Leader>R
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" The same as above except it works with a visual selection.
xmap <Leader>R
  \  "sy
  \  gvgr
  \  :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

"(R)eplace all - From
"https://vi.stackexchange.com/questions/13689/how-to-find-and-replace-in-vim-without-having-to-type-the-original-word
" nnoremap <leader>r yiw:%s/\<<C-r>"\>//g<left><left>
nnoremap <leader>r yiw:%s/\<<C-r><C-w>\>//g<left><left>

" CtrlSF plugin mappings
nmap <Leader>ff <Plug>CtrlSFPrompt
vmap <Leader>ff <Plug>CtrlSFVwordPath
vmap <Leader>fe <Plug>CtrlSFVwordExec
nmap <Leader>fn <Plug>CtrlSFCwordPath
nmap <Leader>fp <Plug>CtrlSFPwordPath

" Plugin Git Gutter seting
let g:gitgutter_grep                    = 'rg'
let g:gitgutter_map_keys                = 0
let g:gitgutter_sign_added              = '▎'
let g:gitgutter_sign_modified           = '▎'
let g:gitgutter_sign_modified_removed   = '▶'
let g:gitgutter_sign_removed            = '▶'
let g:gitgutter_sign_removed_first_line = '◥'
" Comment out mapping as in conflicted with other plugins
" nmap [g <Plug>GitGutterPrevHunkzz
" nmap ]g <Plug>GitGutterNextHunkzz
" nmap <Leader>+ <Plug>GitGutterStageHunk
" nmap <Leader>- <Plug>GitGutterUndoHunk
" nmap <Leader>p <Plug>GitGutterPreviewHunk

" -----------------------------------------------------------------------------
" Basic and frequent mappings
" -----------------------------------------------------------------------------

" vim-surround delete a function shorter mapping
nmap <silent> dsf ds)db

" Write even though you did not sudo to begin with: w!!
cmap w!! w !sudo tee % >/dev/null

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>
vnoremap X "_d

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" vv to generate new vertical split
nnoremap <silent> vv <C-w>v
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 45<CR>
nnoremap <Leader>ps :Rg<SPACE>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

" simulate PageDown as M-v in emacs as Ctrl-B conflicted with tmux
nnoremap v <PageUp>       " i_CTRL-V and type M-v
" M-f and M-b scroll up and down other window; not perfect yet, should not do
" if reached top or bottom
nnoremap f <C-w>w<C-f><C-w>p
nnoremap b <C-w>w<C-b><C-w>p
nnoremap d <C-w>w<C-d><C-w>p
nnoremap u <C-w>w<C-u><C-w>p

nnoremap <F5> :UndotreeToggle<cr>

" === Some shortcut commands here

" Change to Directory of Current file
nnoremap <Leader>cd :cd %:p:h<CR>

" === TODO: call function from ~/.vim/autoload/functions.vim
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup trimwhitespace
  autocmd BufWritePre * :call TrimWhitespace()
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
