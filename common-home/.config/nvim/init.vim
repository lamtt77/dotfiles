if exists('g:vscode')
  " TODO VSCode extension, add later if used
else
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
  " global map leader should come first (before plugins)
  let mapleader="\<space>"
  filetype plugin indent on

  set autoindent
  set smarttab
  set shiftround
  set softtabstop=2 shiftwidth=2 expandtab
  set ignorecase smartcase
  set infercase           " smarter keyword completion
  set nowrap
  set incsearch
  set textwidth=78

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

  " TODO is the following still needed in nvim?
  " if has('unnamedplus')
  "   " indepedently use of `+` for clipboard and `*` for autoslect
  "   set clipboard^=unnamedplus
  " else
  "   set clipboard^=unnamed
  " endif
  " }}}1

  " === PLUGINs initialization {{{1
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    echo "Installing Vim-Plug..."
    echo ""
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let g:not_finish_vimplug = "yes"
    autocmd VimEnter * PlugInstall
  endif

  call plug#begin('~/.config/nvim/autoload/plugged')
  Plug 'sainnhe/gruvbox-material'

  Plug 'lervag/vimtex'              | let g:vimtex_compiler_progname = 'nvr'
  Plug 'voldikss/vim-floaterm'

  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  call plug#end()
  " }}} === PLUGIN initialization end here

  " === Plugins specific settings, commands and autocmds {{{1
  " === THEMEs and COLORs
  lua require("lsp_config")

  set background                    =dark
  let g:gruvbox_material_palette    ='mix'
  let g:gruvbox_material_background ='medium'
  silent! colorscheme gruvbox-material

  " === vim-floaterm
  command! NNN FloatermNew nnn
  command! LF FloatermNew lf
  command! RangerNvim FloatermNew ranger
  " }}}1

  " === All my custom and `steal` mappings start here {{{1
  " use `noremap` for almost everything, but `map` for `Plug` command, do NOT comment at the end of map

  nnoremap Y              y$

  " maintain visual mode after shifting > and <
  vnoremap < <gv
  vnoremap > >gv

  " Use <C-L> to clear the highlighting of :set hlsearch.
  if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
  endif

  " vim-floaterm mappings
  nnoremap <leader>tr                 :RangerNvim<cr>
  nnoremap <leader>tl                 :LF<cr>
  " nnn is fastest with shortest hotkeys
  nnoremap <leader>tn                 :NNN<cr>
  " === My custom mapping end here }}}1
endif

" vim: sts=2 sw=2 et:foldmethod=marker
