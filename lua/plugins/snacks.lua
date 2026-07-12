-- ============================================
-- SNACKS.NVIM - Reemplazo moderno de Telescope
-- ============================================
-- Funcionalidades:
-- - Búsqueda de archivos (ff)
-- - Búsqueda de texto (fg)
-- - Buffers (fb)
-- - Git files (gf)
-- - Notificaciones mejoradas
-- - Dashboard integrado
-- - Y más utilidades

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Módulos habilitados
		bigfile = { enabled = true }, -- Optimiza archivos grandes
		dashboard = { enabled = true }, -- Dashboard al inicio
		indent = { enabled = true }, -- Guías de indentación
		input = { enabled = true }, -- Inputs mejorados
		notifier = { enabled = true }, -- Notificaciones
		quickfile = { enabled = true }, -- Carga rápida de archivos
		scroll = { enabled = true }, -- Scroll suave
		statuscolumn = { enabled = true }, -- Columna de estado
		words = { enabled = true }, -- Resaltar palabra bajo cursor

		-- Configuración del Dashboard
		dashboard = {
			preset = {
				header = [[
                            /|               |\                              
                           / | ___-------___ | \                             
                          /  \/ ^ /\   /\ ^ \/  \                            
                         |   (  O-. \ / .-O  )   |                           
                      /-\/   ^-----^-V-^-----^   \/-\                        
                    /-      (~ 0O0 ~) (~ 000 ~)     -\                       
                   <        (~ OOO ~) (~ 000 ~)       >                      
                    \-      (____---===---____)     -/                       
                     \-   /\ \ \|         |/ / /\  -/                        
                     -/\-/  \ \ V         V / /  \-/\-                       
     Art by             v    \ \           / /    v                          
      Mordread                \ \ A     A / /                                
Mord...@wine-gum.demon.co.uk  \_\^-----^/_/                                 
                                \_/\___/\_/                                  
                                  \_____/
]],
			},
			sections = {
				{ section = "header" },
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
	},

	keys = {
		-- Búsqueda de archivos (reemplazo de Telescope)
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Tags",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>gc",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Commits",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},

		-- Utilidades adicionales
		{
			"<leader>un",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},

		-- Terminal flotante
		{
			"<leader>t",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
			mode = { "n", "t" },
		},
		{
			"<Esc>",
			[[<C-\><C-n>]],
			mode = "t",
			desc = "Exit terminal mode",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},

	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Crear algunas autocommands útiles
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd
			end,
		})
	end,
}
