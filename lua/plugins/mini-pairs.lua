-- ============================================
-- MINI.PAIRS
-- Autocompletado de parentesis, corchetes y comillas.
-- Usamos el modulo "pairs" del mono-repo mini.nvim,
-- que ya tenemos instalado como dependencia de render-markdown.
-- ============================================

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.pairs").setup({
      -- Mapea automaticamente el cierre de pares al escribir el de apertura
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      },
    })
  end,
}
