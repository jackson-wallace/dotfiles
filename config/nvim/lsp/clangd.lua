return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
  root_markers = { ".clangd", "compile_commands.json", ".git" },
  on_attach = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
}
