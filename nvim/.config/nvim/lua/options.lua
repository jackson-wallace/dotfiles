vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber")
vim.cmd("set number")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "c", "cpp", "h", "hpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local options = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>q", ':q<CR>', options)
vim.keymap.set("n", "<leader>w", ':w<CR>', options)

vim.keymap.set("n", "<C-u>", "<C-u>zz", options)
vim.keymap.set("n", "<C-d>", "<C-d>zz", options)

-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', options)

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", '"+p', options)

vim.keymap.set("n", "<leader>e", ":Oil<CR>", options)

vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolloff = 10
vim.opt.ignorecase = true
vim.opt.undofile = true

vim.o.termguicolors = true
vim.o.winborder = "rounded"
