vim.cmd("set number")
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.o.directory = "~/.local/share/nvim/swap//"

vim.o.autowrite = true

-- Opciones comunes para los mapeos
local opts = { noremap = true, silent = true }

-- Función para configurar los mapeos
local map = vim.api.nvim_set_keymap

-- Dividir ventana horizontalmente con Ctrl + w + s
map("n", "<C-w>s", ":split<CR>", opts)
vim.keymap.set('n','<leader>ws',":split<CR>", {})

-- Dividir ventana verticalmente con Ctrl + w + v
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", {})
