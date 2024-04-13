print("Cargando Configuracion de Nvim Jeison")

--####################### Editor ####################################################3

--Esta opción muestra los números por línea
vim.opt.number = true

--Esta opción activa las opciones para el mouse
vim.opt.mouse = 'a'

--Esta opción al estar activa ignora las máyusculas
vim.opt.ignorecase = false

--esta opción ignora las máyusculas a menos que la bpusqueda tenga una máyuscula
vim.opt.smartcase = true

--Resalta los resultados de una búsqueda anterior
vim.opt.hlsearch = false

--Hace que el texto de las líneas largas siempre este visible
vim.opt.wrap = true

--Conserva la indentación de las líneas que sólo son visibles cuando wrap = true
vim.opt.breakindent = true

--La cantidad de carácteres que ocupa el Tab
vim.opt.tabstop = 4

--El espacio que nvim usará para indentar uan linea.Lo normal es que sea igual que tabstop
vim.opt.shiftwidth = 2

--Determina si nvim trasforma el carácter Tab en espacios
vim.opt.expandtab = false

--################### Keymaps ######################


--Guardar 
vim.keymap.set('n', '<space>w', '<cmd>write<cr>', {desc = 'Guardar'})

--Copiar al portapapeles
vim.keymap.set({'n', 'x'}, 'gy', '"+y')

--Pegar desde el portapapeles
vim.keymap.set({'n', 'x'}, 'gp', '"+p')

--Borrar texto sin alterar registro

vim.keymap.set({'n', 'x'}, 'x', '"_x')
vim.keymap.set({'n', 'x'}, 'X', '"_d')

--Seleccionar todo el texto
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<CR>')

-- Abrir el explorador de archivos
vim.keymap.set('n', '<space>e', ':NERDTreeToggle<cr>')

--#################### Lazy.nvim #############################

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  -- Pueden comentar la siguiente línea una vez que lazy.nvim esté instalado
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  {'folke/tokyonight.nvim'},
  {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {'preservim/nerdtree'},
})


-- Colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

-- ######################### plugins Conf ###############################

-- ####################### -> Lualine

require('lualine').setup({
  options = {
    icons_enabled = true,
	section_separators = '>>',
    component_separators = '|'  
  }
})

--################## -> NERDTree


