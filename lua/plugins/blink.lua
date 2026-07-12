return {
  "saghen/blink.cmp",
  version = "1.*", -- rama estable
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    -- "enter" hace que <CR> confirme la sugerencia seleccionada,
    -- igual que tenías configurado antes con nvim-cmp.
    -- Si el menú NO está visible, <CR> sigue siendo un salto de línea normal.
    keymap = {
      preset = "enter",
      ["<CR>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.accept()
            return true -- corta la cadena, no dejamos que pase al fallback
          end
        end,
        "fallback",
      },
    },
    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      menu = { border = "rounded" },
      -- selecciona automáticamente el primer ítem (equivalente a tu
      -- select = true de nvim-cmp), así <CR> siempre tiene algo que aceptar
      list = { selection = { auto_insert = true } },
    },

    signature = { enabled = true, window = { border = "rounded" } },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
