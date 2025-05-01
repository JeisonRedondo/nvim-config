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


-- Dividir ventana verticalmente con Ctrl + w + v
vim.keymap.set("n", "<C-w>v", ":vsplit<CR>", {})

-- Mover líneas o bloques
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)

-- Mover entre buffers
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', opts)
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>bd', ':bd<CR>', opts)

-- Función para redimensionar ventanas en cualquier dirección
function ResizeWindow(direction, amount)
  local cmd = ""

  if direction == "up" then
    cmd = "resize -" .. amount
  elseif direction == "down" then
    cmd = "resize +" .. amount
  elseif direction == "left" then
    cmd = "vertical resize -" .. amount
  elseif direction == "right" then
    cmd = "vertical resize +" .. amount
  else
    print("Dirección inválida: usa up/down/left/right")
    return
  end

  vim.cmd(cmd)
end

vim.keymap.set('n', '<A-l>', function() ResizeWindow("left", 2) end, opts)
vim.keymap.set('n', '<A-h>', function() ResizeWindow("right", 2) end, opts)
vim.keymap.set('n', '<A-j>', function() ResizeWindow("up", 2) end, opts)
vim.keymap.set('n', '<A-k>', function() ResizeWindow("down", 2) end, opts)

