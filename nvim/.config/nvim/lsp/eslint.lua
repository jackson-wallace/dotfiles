return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { ".eslintrc", ".eslintrc.js", "package.json", ".git" },
  settings = {
    validate = "on",
    format = true,
    run = "onType",
    nodePath = "",
    experimental = {
      useFlatConfig = false,
    },
    problems = {},
    rulesCustomizations = {},
  },
}
