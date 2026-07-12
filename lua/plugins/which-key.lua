-- ============================================================================
-- ARCHIVO: ~/.config/nvim/lua/plugins/which-key.lua
-- ============================================================================
-- Which-Key v3
-- CORREGIDO: sin conflicto <leader>f (files/find) vs format
-- ============================================================================

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500,
    icons = {
      mappings = true,
      keys = {},
    },
    spec = {
      -- ------------------------------------------------
      -- CODE (LSP)
      -- ------------------------------------------------
      { "<leader>c",  group = "code" },
      { "<leader>ca", desc = "Code action (LSP)" },
      { "<leader>cM", desc = "Añadir imports faltantes (TS)" },
      { "<leader>co", desc = "Organizar imports (TS)" },
      { "<leader>cr", desc = "Eliminar imports no usados (TS)" },
      { "<leader>cf", desc = "Fix all (TS)" },
      { "<leader>cF", desc = "Format (LSP)" },
      { "<leader>cd", desc = "Diagnóstico flotante" },
      { "<leader>cq", desc = "Quickfix list" },

      -- Navegación LSP
      { "gd",         desc = "Go to definition" },
      { "gD",         desc = "Go to declaration" },
      { "gi",         desc = "Go to implementation" },
      { "gr",         desc = "Go to references" },
      { "gt",         desc = "Go to type definition" },
      { "K",          desc = "Hover documentation" },
      { "<C-k>",      desc = "Signature help" },

      -- Diagnósticos
      { "[d",         desc = "Previous diagnostic" },
      { "]d",         desc = "Next diagnostic" },

      -- ------------------------------------------------
      -- FILE/FIND (Snacks)
      -- ------------------------------------------------
      { "<leader>f",  group = "file/find" },
      { "<leader>ff", desc = "Find files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fb", desc = "Buffers" },
      { "<leader>fr", desc = "Recent files" },
      { "<leader>fh", desc = "Help tags" },

      -- ------------------------------------------------
      -- WINDOW / BUFFER
      -- ------------------------------------------------
      { "<leader>w",  group = "window" },
      { "<leader>wt", group = "create a tags" },
      { "<leader>b",  group = "buffer" },
      { "<leader>bd", desc = "Delete buffer" },

      -- ------------------------------------------------
      -- GIT (Snacks/Lazygit)
      -- ------------------------------------------------
      { "<leader>g",  group = "git" },
      { "<leader>gg", desc = "Lazygit" },
      { "<leader>gs", desc = "Git status" },
      { "<leader>gc", desc = "Git commits" },
      { "<leader>gb", desc = "Git blame line" },
      { "<leader>gf", desc = "File history (lazygit)" },
      { "<leader>gl", desc = "Git log (lazygit)" },

      -- ------------------------------------------------
      -- NOTIFICATIONS
      -- ------------------------------------------------
      { "<leader>u",  group = "ui" },
      { "<leader>un", desc = "Notification history" },

      -- ------------------------------------------------
      -- AI (CodeCompanion)
      -- ------------------------------------------------
      { "<leader>a",  group = "ai" },
      { "<leader>ai", desc = "AI Chat" },
      { "<leader>at", desc = "Toggle AI Chat" },
      { "<leader>aa", desc = "AI Actions" },
      { "<leader>aA", desc = "Añadir selección al chat" },
      { "<leader>am", desc = "Cambiar adaptador (AI)" },

      -- Help
      { "<leader>?",  desc = "Buffer Local Keymaps" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
