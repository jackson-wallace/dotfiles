local options = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>q", ":q<CR>", options)
vim.keymap.set("n", "<leader>w", ":w<CR>", options)

vim.keymap.set("n", "<C-u>", "<C-u>zz", options)
vim.keymap.set("n", "<C-d>", "<C-d>zz", options)

-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', options)

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", '"+p', options)

vim.keymap.set("n", "<leader>e", ":Oil<CR>", options)

-- LSP keybinds
vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, options)
vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
vim.keymap.set("n", "<leader>fs", vim.lsp.buf.workspace_symbol, options)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, options)
vim.keymap.set("n", "[d", vim.diagnostic.goto_next, options)
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, options)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, options)
vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, options)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
vim.keymap.set("i", "<C-h>", function()
  vim.lsp.buf.signature_help()
end, options)
