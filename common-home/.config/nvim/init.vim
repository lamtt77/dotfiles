if exists('g:vscode')
    " TODO VSCode extension, add later if used
else
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc

  if has('nvim-0.5')
    lua require("lsp_config")
  endif
endif
