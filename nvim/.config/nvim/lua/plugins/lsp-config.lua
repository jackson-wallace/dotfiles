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
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "eslint",
          "cssls",
          "html",
          "jsonls",
          "gopls",
          "pyright",
          "clangd",
          "rust_analyzer",
          "bashls",
        },
        automatic_enable = false,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local servers = {
        "lua_ls",
        "ts_ls",
        "eslint",
        "cssls",
        "html",
        "jsonls",
        "gopls",
        "pyright",
        "clangd",
        "rust_analyzer",
        "bashls",
      }

      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          capabilities = capabilities,
        })
      end

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

      vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      vim.diagnostic.config({
        signs = false,
        virtual_text = false,
        float = { border = "rounded" },
      })

      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
      end, opts)

      vim.api.nvim_create_user_command("Diagnostics", function()
        local diagnostics = vim.diagnostic.get(0)
        for _, d in ipairs(diagnostics) do
          print(
            string.format(
              "[%s] %s:%d:%d: %s",
              d.severity,
              vim.fn.bufname(d.bufnr),
              d.lnum + 1,
              d.col + 1,
              d.message
            )
          )
        end
      end, {})
    end,
  },
}
