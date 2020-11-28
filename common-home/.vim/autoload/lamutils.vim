function! lamutils#TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

" from https://github.com/Phantas0s/.dotfiles/blob/dd7f9c85353347fdf76e4847063745bacc390460/nvim/autoload/general.vim
" For use with pressing * or # in visual mode to search for current selection
function! lamutils#VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute 'normal! vgvy'

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", '', '')

  " LamT TODO: improve me
  "if a:direction is# 'gv'
  "  call CmdLine("Rg '" . l:pattern . "' " )
  "elseif a:direction is# 'replace'
  "  call CmdLine('%s' . '/'. l:pattern . '/')
  "endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
