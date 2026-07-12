local fn = require("config.functions")

-- OPCIONES COMUNES PARA LOS MAPEOS
local function map(mode, lhs, rhs, desc, extra)
	local options = vim.tbl_extend("force", { noremap = true, silent = true, desc = desc }, extra or {})
	vim.keymap.set(mode, lhs, rhs, options)
end

-- KEYMAPS
map("i", "jk", "<Esc>", "Salir modo Inserción")
map("i", "kj", "<Esc>", "Salir modo Inserción")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Limpiar resaltado de busqueda")
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Mover lineas hacia abajo")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Mover lineas hacia arriba")
map("n", "<leader>-", "<CMD>Oil<CR>", "Abrir Oil")

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
			local ok, snacks = pcall(require, "snacks")
			if ok then
				snacks.picker.files()
			else
				vim.notify("Snacks no está instalado", vim.log.levels.WARN)
			end
		end)
	end
end, { silent = true, desc = "Window + Buffer manager" })
