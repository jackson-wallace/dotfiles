return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "eslint", "cssls", "html", "jsonls", "gopls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local servers = { "lua_ls", "ts_ls", "eslint", "cssls", "html", "jsonls", "gopls" }

			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end

			-- Disable diagnostic signs
			vim.diagnostic.config({
				signs = false,
				virtual_text = false,
			})

			-- Use this if you want it to automatically show all diagnostics on the
			-- current line in a floating window. Personally, I find this a bit
			-- distracting and prefer to manually trigger it (see below). The
			-- CursorHold event happens when after `updatetime` milliseconds. The
			-- default is 4000 which is much too long
			-- vim.cmd("autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()")
			-- vim.o.updatetime = 300

			-- Show all diagnostics on current line in floating window
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>d",
				":lua vim.diagnostic.open_float()<CR>",
				{ noremap = true, silent = true }
			)
			-- Go to next diagnostic (if there are multiple on the same line, only shows
			-- one at a time in the floating window)
			-- vim.api.nvim_set_keymap(
			-- 	"n",
			-- 	"C-n",
			-- 	":lua vim.diagnostic.goto_next()<CR>",
			-- 	{ noremap = true, silent = true }
			-- )
			-- Go to prev diagnostic (if there are multiple on the same line, only shows
			-- one at a time in the floating window)
			-- vim.api.nvim_set_keymap(
			-- 	"n",
			-- 	"C-p",
			-- 	":lua vim.diagnostic.goto_prev()<CR>",
			-- 	{ noremap = true, silent = true }
			-- )

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
