return {
	"saghen/blink.cmp",
	version = "1.*", -- rama estable, evita los cambios de v2 en desarrollo
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		keymap = { preset = "default" }, -- <C-y> acepta, <C-n>/<C-p> navega, <C-space> abre docs

		appearance = {
			nerd_font_variant = "mono", -- coincide con tu JetBrainsMono Nerd Font
		},

		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
			menu = { border = "rounded" },
		},

		signature = { enabled = true, window = { border = "rounded" } },

		sources = {
			-- Orden = prioridad de aparición en el menú
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}

