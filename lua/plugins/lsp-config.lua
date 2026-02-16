return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "eslint" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ============================================
      -- HABILITAR LSP SERVERS
      -- ============================================

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("eslint")

      -- Config global para todos los servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- ============================================
      -- KEYMAPS DE LSP
      -- ============================================

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

      -- ============================================
      -- CONFIGURACIÓN DE DIAGNÓSTICOS (FORMA NUEVA)
      -- ============================================

      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        float = {
          border = "rounded",
          max_width = 80,
          source = "always",
          focusable = false,
        },
      })
    end,
  },
}
