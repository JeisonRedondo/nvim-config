-- ============================================
-- WHICH-KEY - Menú visual de keymaps
-- ============================================
-- Muestra un popup con los comandos disponibles
-- cuando presionas <leader>

return {
	"folke/which-key.nvim",
	event = "VeryLazy",

	opts = {
		-- Configuración básica
		preset = "modern",
		delay = 300, -- Tiempo de espera en ms (300 = 0.3 segundos)

		-- Configuración de la ventana
		win = {
			border = "rounded",
			padding = { 1, 2 },
			title = true,
			title_pos = "center",
			zindex = 1000,
		},

		-- Layout
		layout = {
			width = { min = 20, max = 50 },
			spacing = 3,
			align = "left",
		},

		-- Triggers automáticos
		triggers = {
			{ "<leader>", mode = { "n", "v" } },
			{ "<C-w>", mode = "n" },
			{ "g", mode = { "n", "v" } },
			{ "z", mode = { "n", "v" } },
			{ "[", mode = "n" },
			{ "]", mode = "n" },
		},
	},

	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- ============================================
		-- GRUPOS DE COMANDOS (Organización visual)
		-- ============================================
		wk.add({
			-- AI / CodeCompanion
			{ "<leader>a", group = "AI" },
			{ "<leader>ai", desc = "Chat IA" },
			{ "<leader>at", desc = "Toggle Chat" },
			{ "<leader>aa", desc = "Acciones IA" },
			{ "<leader>ae", desc = "Explicar código" },
			{ "<leader>ab", desc = "Buscar bugs" },
			{ "<leader>ao", desc = "Optimizar" },
			{ "<leader>ad", desc = "Documentar" },
			{ "<leader>am", desc = "Cambiar modelo" },
			{ "<leader>ax", desc = "Limpiar chat" },
			{ "<leader>ac", desc = "Chat inline" },
			{ "<leader>aA", desc = "Agregar a chat" },

			-- Buffers
			{ "<leader>b", group = "Buffers" },
			{ "<leader>bd", desc = "Cerrar buffer" },

			-- Code / LSP
			{ "<leader>c", group = "Code" },
			{ "<leader>ca", desc = "Code actions" },
			{ "<leader>cR", desc = "Rename file" },
			{ "<leader>cw", desc = "Limpiar whitespace" },

			-- Debug
			{ "<leader>d", group = "Debug" },
			{ "<leader>db", desc = "Toggle breakpoint" },
			{ "<leader>dc", desc = "Continue" },
			{ "<leader>di", desc = "Step into" },
			{ "<leader>do", desc = "Step over" },
			{ "<leader>dO", desc = "Step out" },
			{ "<leader>dt", desc = "Toggle UI" },
			{ "<leader>dr", desc = "REPL" },
			{ "<leader>dl", desc = "Run last" },

			-- Files / Find
			{ "<leader>f", group = "Find" },
			{ "<leader>ff", desc = "Find files" },
			{ "<leader>fg", desc = "Live grep" },
			{ "<leader>fb", desc = "Buffers" },
			{ "<leader>fh", desc = "Help" },
			{ "<leader>fr", desc = "Recent files" },
			{ "<leader>fn", desc = "Nuevo archivo" },
			{ "<leader>fp", desc = "Copiar path" },
			{ "<leader>fP", desc = "Copiar path relativo" },

			-- Git
			{ "<leader>g", group = "Git" },
			{ "<leader>gg", desc = "LazyGit" },
			{ "<leader>gc", desc = "Commits" },
			{ "<leader>gs", desc = "Status" },
			{ "<leader>gb", desc = "Blame line" },
			{ "<leader>gf", desc = "File history" },
			{ "<leader>gl", desc = "Log" },

			-- Quickfix
			{ "<leader>q", group = "Quickfix" },
			{ "<leader>qo", desc = "Abrir quickfix" },
			{ "<leader>qc", desc = "Cerrar quickfix" },

			-- Rename (LSP)
			{ "<leader>r", group = "Rename" },
			{ "<leader>rn", desc = "Rename symbol" },

			-- Search
			{ "<leader>s", group = "Search" },
			{ "<leader>sr", desc = "Reemplazar palabra" },
			{ "<leader>sw", desc = "Buscar palabra" },
			{ "<leader>sh", desc = "Split horizontal" },
			{ "<leader>sv", desc = "Split vertical" },
			{ "<leader>sx", desc = "Cerrar split" },

			-- Terminal
			{ "<leader>t", group = "Terminal" },
			{ "<leader>th", desc = "Terminal horizontal" },
			{ "<leader>tv", desc = "Terminal vertical" },

			-- UI Toggles
			{ "<leader>u", group = "UI" },
			{ "<leader>ur", desc = "Toggle números relativos" },
			{ "<leader>uw", desc = "Toggle word wrap" },
			{ "<leader>ud", desc = "Toggle diagnósticos" },
			{ "<leader>us", desc = "Toggle spell check" },
			{ "<leader>un", desc = "Notificaciones" },

			-- Window management
			{ "<leader>w", group = "Window" },
			-- Los sub-comandos se muestran dinámicamente

			-- Otros
			{ "<leader>-", desc = "Oil (explorador)" },
			{ "<leader>R", desc = "Recargar config" },
		})
	end,
}
