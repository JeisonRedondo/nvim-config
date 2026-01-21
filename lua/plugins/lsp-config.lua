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
      ensure_installed = { "lua_ls", "ts_ls", "html", "eslint" }, -- quitamos denols
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })

      -- TypeScript / React (Node.js, Vite, etc.)
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),
      })

      -- HTML
      vim.lsp.config("html", {
        capabilities = capabilities,
      })

      -- ESLint
      vim.lsp.config("eslint", {
        capabilities = capabilities,
      })

      -- Keymaps
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        float = {
          border = "rounded",
          max_width = 80,
          source = "always",
          focusable = false,
          header = "",
          prefix = "",
        },
      })
    end,
  },
}

