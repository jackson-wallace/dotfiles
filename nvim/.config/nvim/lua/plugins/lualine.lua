return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "vague",
      },
    })
    require("lualine").get_config()
  end,
}
