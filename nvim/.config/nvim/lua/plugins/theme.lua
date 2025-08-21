return {
  "vague2k/vague.nvim",
  config = function()
    require("vague").setup({
      transparent = true,
    })
    vim.cmd.colorscheme("vague")

    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

    vim.opt.statusline = "%t %{&modified?'+':''}"
  end,
}
