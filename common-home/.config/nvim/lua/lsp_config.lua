local map = function(type, key, value)
	vim.fn.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

local custom_attach = function(client)
	print("LSP started.");
	require'completion'.on_attach(client)

        -- GOTO mappings
	map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
	map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
	map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
	map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	map('n','<leader>gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
	map('n','<leader>gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
	map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	-- ACTION mappings
	map('n','<leader>ah',  '<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n','<leader>af', '<cmd>lua vim.lsp.buf.code_action()<CR>')
	map('n','<leader>ar',  '<cmd>lua vim.lsp.buf.rename()<CR>')
	-- Few language severs support these three
	map('n','<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
	map('n','<leader>ai',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	map('n','<leader>ao',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
	-- Diagnostics mapping
	map('n','<leader>ee', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
	map('n','<leader>en', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
	map('n','<leader>ep', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
end

require('lspconfig').tsserver.setup{on_attach=custom_attach}
require('lspconfig').clangd.setup{on_attach=custom_attach}
require('lspconfig').sumneko_lua.setup{on_attach=custom_attach}

-- Uncomment to execute the extension test mentioned above.
-- local function custom_codeAction_callback(_, _, action)
-- 	print(vim.inspect(action))
-- end

-- vim.lsp.callbacks['textDocument/codeAction'] = custom_codeAction_callback
