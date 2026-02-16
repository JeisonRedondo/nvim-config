local fn = require("config.functions")

-- Opciones comunes para los mapeos
local opts = { noremap = true, silent = true }

-- ==========================================================
-- Keymaps
-- ==========================================================

-- Limpiar resaltado (ESC en modo normal)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado de b├║squeda" })

-- Mover líneas o bloques
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Abrir Oil
vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Función para redimensionar ventanas en cualquier dirección
vim.keymap.set("n", "<A-h>", function() fn.resize_window("right", 2) end, opts)
vim.keymap.set("n", "<A-l>", function() fn.resize_window("left", 2) end, opts)
vim.keymap.set("n", "<A-j>", function() fn.resize_window("up", 2) end, opts)
vim.keymap.set("n", "<A-k>", function() fn.resize_window("down", 2) end, opts)


-- Mapeos en modo normal y visual
vim.keymap.set({ "n", "v" }, "<C-s>", function()
  fn.save_file()
end, { noremap = true, silent = true })

-- Mapeo en modo insert: sale del insert, guarda, y se queda en normal
vim.keymap.set("i", "<C-s>", function()
  vim.cmd("stopinsert")
  fn.save_file()
end, { noremap = true, silent = true })

