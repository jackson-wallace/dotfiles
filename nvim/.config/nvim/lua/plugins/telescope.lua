return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("v", "<leader>fg", function()
        local old_reg = vim.fn.getreg("v")
        vim.cmd('noautocmd normal! "vy')
        local text = vim.fn.getreg("v")
        vim.fn.setreg("v", old_reg)
        builtin.live_grep({ default_text = text })
      end, {})
      vim.keymap.set("n", "<leader>fh", function()
        builtin.find_files({ hidden = true })
      end, {})

      -- LSP keybinds
      vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
      vim.keymap.set("n", "gi", builtin.lsp_implementations, {})
      vim.keymap.set("n", "gr", builtin.lsp_references, {})
      vim.keymap.set("n", "gt", builtin.lsp_type_definitions, {})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
