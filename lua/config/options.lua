-- ===================================================

-- VARIABLES GLOBALES
vim.g.mapleader = " "

-- APARIENCIA
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- INDENTACI├ôN
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

-- B├ÜSQUEDA
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true -- Resaltar b├║squedas
vim.opt.incsearch = true -- Resaltar incremental

-- COMPORTAMIENTO
vim.opt.mouse = "a"
vim.opt.swapfile = false -- Ya tienes directorio configurado
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.autowrite = true -- Ya lo ten├¡as
vim.opt.undofile = true -- Historial de deshacer persistente
vim.opt.undodir = vim.fn.expand("~/.local/share/nvim/undo//")
vim.opt.autoread = true

-- SPLITS
vim.opt.splitright = true
vim.opt.splitbelow = true

-- PERFORMANCE
vim.opt.updatetime = 500
vim.opt.timeoutlen = 500

-- VISUAL
vim.opt.scrolloff = 10
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.lsp.inlay_hint.enable(true)

-- DIRECTORIO DE SWAP (ya lo tienes)
vim.opt.directory = vim.fn.expand("~/.local/share/nvim/swap//")

-- ============================================
-- CLIPBOARD WSL
-- ============================================
-- (Tu configuraci├│n actual est├í perfecta, d├®jala igual)
vim.g.clipboard = {
	name = "WslClipboard",
	copy = {
		["+"] = "/mnt/c/Windows/System32/clip.exe",
		["*"] = "/mnt/c/Windows/System32/clip.exe",
	},
	paste = {
		["+"] = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c Get-Clipboard",
		["*"] = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c Get-Clipboard",
	},
	cache_enabled = 0,
}

-- Fuerza la revisión al cambiar de buffer o enfocar la ventana
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	command = "checktime",
})
