local fn = require("config.functions")

-- Opciones comunes para los mapeos
local opts = { noremap = true, silent = true }

-- ==========================================================
-- Keymaps
-- ==========================================================
--

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "kj", "<Esc>", { noremap = true, silent = true })

-- Limpiar resaltado (ESC en modo normal)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado de b├║squeda" })

-- Mover líneas o bloques
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Abrir Oil
vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- ============================================
-- WINDOW MANAGEMENT + FILE PICKER
-- ============================================
-- Replica de tu sistema <leader>w de Telescope
-- Ahora usando Snacks.picker en vez de Telescope

vim.keymap.set("n", "<leader>w", function()
	local key = vim.fn.getcharstr()

	local actions = {
		-- SPLITS CON PICKER
		["-"] = function()
			vim.cmd("split")
			vim.cmd("wincmd j")
			return true -- Abrir picker
		end,

		["/"] = function()
			vim.cmd("vsplit")
			vim.cmd("wincmd l")
			return true -- Abrir picker
		end,

		-- NAVEGACIÓN DE BUFFERS
		["n"] = function()
			vim.cmd("bnext")
			return false -- NO abrir picker
		end,

		["p"] = function()
			vim.cmd("bprevious")
			return false -- NO abrir picker
		end,

		-- NAVEGACIÓN DE VENTANAS
		["h"] = function()
			vim.cmd("wincmd h")
			return false
		end,

		["l"] = function()
			vim.cmd("wincmd l")
			return false
		end,

		["k"] = function()
			vim.cmd("wincmd k")
			return false
		end,

		["j"] = function()
			vim.cmd("wincmd j")
			return false
		end,

		-- NUEVA TAB CON PICKER
		["t"] = function()
			vim.cmd("tabnew")
			return true -- Abrir picker
		end,

		-- SIGUIENTE TAB (sin picker)
		["T"] = function()
			vim.cmd("tabnext")
			return false
		end,

		-- CERRAR VENTANA ACTUAL
		["x"] = function()
			vim.cmd("close")
			return false
		end,

		-- CERRAR BUFFER ACTUAL
		["d"] = function()
			vim.cmd("bdelete")
			return false
		end,

		-- MAXIMIZAR VENTANA ACTUAL
		["m"] = function()
			vim.cmd("only")
			return false
		end,

		-- IGUALAR TAMAÑO DE VENTANAS
		["="] = function()
			vim.cmd("wincmd =")
			return false
		end,
	}

	local action = actions[key]
	if not action then
		vim.notify("Tecla no reconocida: " .. key, vim.log.levels.WARN)
		return
	end

	local open_picker = action()

	if open_picker then
		vim.schedule(function()
			-- Usar Snacks picker en vez de Telescope
			require("snacks").picker.files()
		end)
	end
end, { silent = true, desc = "Window + Buffer manager" })

-- Función para redimensionar ventanas en cualquier dirección
vim.keymap.set("n", "<A-h>", function()
	fn.resize_window("right", 2)
end, opts)
vim.keymap.set("n", "<A-l>", function()
	fn.resize_window("left", 2)
end, opts)
vim.keymap.set("n", "<A-j>", function()
	fn.resize_window("up", 2)
end, opts)
vim.keymap.set("n", "<A-k>", function()
	fn.resize_window("down", 2)
end, opts)

-- Mapeos en modo normal y visual
vim.keymap.set({ "n", "v" }, "<C-s>", function()
	fn.save_file()
end, { noremap = true, silent = true })

-- Mapeo en modo insert: sale del insert, guarda, y se queda en normal
vim.keymap.set("i", "<C-s>", function()
	vim.cmd("stopinsert")
	fn.save_file()
end, { noremap = true, silent = true })

-- ============================================
-- CHAT DE IA
-- ============================================

-- Abrir chat de IA
vim.keymap.set("n", "<leader>ai", "<cmd>CodeCompanionChat<cr>", {
	desc = "AI Chat",
})

vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanionChat<cr>", {
	desc = "AI Chat con selección",
})

-- Toggle chat (abrir/cerrar)
vim.keymap.set("n", "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", {
	desc = "Toggle AI Chat",
})

-- ============================================
-- ACCIONES DE IA
-- ============================================

-- Menú de acciones (explicar, optimizar, bugs, etc.)
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", {
	desc = "AI Actions",
})

-- Agregar código seleccionado al chat
vim.keymap.set("v", "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", {
	desc = "Agregar a AI Chat",
})

-- ============================================
-- ATAJOS RÁPIDOS
-- ============================================

-- Abrir chat inline (en el mismo buffer)
vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanion<cr>", {
	desc = "AI Inline",
})

-- ============================================
-- CAMBIAR MODELO
-- ============================================

vim.keymap.set("n", "<leader>am", function()
	vim.ui.select({ "ollama", "huggingface", "perplexity" }, {
		prompt = "Selecciona adaptador de IA:",
		format_item = function(item)
			local descriptions = {
				ollama = "Ollama (Local - Gratis)",
				huggingface = "HuggingFace (Cloud - Gratis)",
				perplexity = "Perplexity (Cloud - Búsqueda Web)",
			}
			return descriptions[item] or item
		end,
	}, function(choice)
		if choice then
			require("codecompanion").setup({
				strategies = {
					chat = { adapter = choice },
					inline = { adapter = choice },
					agent = { adapter = choice },
				},
			})
			vim.notify("Modelo cambiado a: " .. choice, vim.log.levels.INFO)
		end
	end)
end, {
	desc = "Cambiar modelo de IA",
})

-- ============================================
-- PROMPTS ESPECÍFICOS
-- ============================================

-- Explicar código seleccionado
vim.keymap.set("v", "<leader>ae", function()
	vim.cmd("'<,'>CodeCompanionChat Explicar código")
end, {
	desc = "Explicar código",
})

-- Encontrar bugs
vim.keymap.set("v", "<leader>ab", function()
	vim.cmd("'<,'>CodeCompanionChat Encontrar bugs")
end, {
	desc = "Buscar bugs",
})

-- Optimizar código
vim.keymap.set("v", "<leader>ao", function()
	vim.cmd("'<,'>CodeCompanionChat Optimizar")
end, {
	desc = "Optimizar código",
})

-- Agregar comentarios
vim.keymap.set("v", "<leader>ad", function()
	vim.cmd("'<,'>CodeCompanionChat Agregar comentarios")
end, {
	desc = "Documentar código",
})

-- ============================================
-- GESTIÓN DE CHAT
-- ============================================

-- Limpiar historial de chat
vim.keymap.set("n", "<leader>ax", "<cmd>CodeCompanionChat Clear<cr>", {
	desc = "Limpiar chat",
})

-- Reabrir último chat
vim.keymap.set("n", "<leader>al", "<cmd>CodeCompanionChat Toggle<cr>", {
	desc = "Último chat",
})
