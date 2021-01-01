" === vim-lsp: language server
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

if executable('ccls')
  " sudo pacman -S ccls               " very good already, low memory footprint
  au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }, 'clang': {'extraArgs': ['--gcc-toolchain=/usr'] } },
      \ 'allowlist': [ 'c', 'cpp', 'objc', 'objcpp', 'cc' ],
      \ })
endif

if executable('pyls')
  " sudo pacman -S python-language-server yapf
  au User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'allowlist': ['python'],
      \ })
endif

if executable('jdtls-lam')
  " yay -S jdtls
  " caveat: `pwd` needs to set correctly at the root of java project to work properly, because
  " `jdtls` will need to generate a `workspace` directory and option `-data` not work yet. TODO: any better way?
  " Update: most language-server (gopls) needs to set `pwd` to work propertly, it seems
  au User lsp_setup call lsp#register_server({
      \ 'name': 'jdtls-lam',
      \ 'cmd': {server_info->['jdtls-lam']},
      \ 'allowlist': [ 'java' ],
      \ })
endif

if executable('gopls')
  " sudo pacman -S gopls
  au User lsp_setup call lsp#register_server({
      \ 'name': 'gopls',
      \ 'cmd': {server_info->['gopls']},
      \ 'allowlist': [ 'go' ],
      \ })
endif

if executable('bash-language-server')
  " sudo pacman -S bash-language-server
  au User lsp_setup call lsp#register_server({
      \ 'name': 'bash-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
      \ 'allowlist': ['sh'],
      \ })
endif

if executable('typescript-language-server')
  " npm install -g typescript typescript-language-server
  " \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
  au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'allowlist': ['javascript', 'javascript.jsx', 'javascriptreact', 'typescript', 'typescript.tsx'],
      \ })
endif

if executable('yaml-language-server')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'yaml-language-server',
      \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
      \ 'allowlist': ['yaml', 'yaml.ansible'],
      \ 'workspace_config': {
      \   'yaml': {
      \     'validate': v:true,
      \     'hover': v:true,
      \     'completion': v:true,
      \     'customTags': [],
      \     'schemas': {},
      \     'schemaStore': { 'enable': v:true },
      \   }
      \ }
      \})
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> <leader>li <plug>(lsp-implementation)
  nmap <buffer> <leader>lt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  " LamT: some more mappings
  nmap <buffer> <leader>ln <plug>(lsp-next-error)
  nmap <buffer> <leader>lp <plug>(lsp-previous-error)
  " auto-complete mappings
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
