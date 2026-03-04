return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSupdate",
  config = function()
    local config = require("nvim-treesitter.config")
    config.setup({
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
