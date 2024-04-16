 " ...general settings

set noshowmode
set laststatus=2
set termguicolors
set number

call plug#begin('~/.config/nvim/plugged')
" Este es un colorscheme
Plug 'connorholyday/vim-snazzy'

" Instalaciones para telescope
Plug 'nvim-lua/plenary.nvim' " Telescope necesita de plenary para funcionar
Plug 'nvim-telescope/telescope.nvim' " El Telescope Principal
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' } " Un plugin opcional recomendado por los Docs de Telescope

" Lightline => Este plugin maneja la barra de estado de la parte de abajo de
" nvim
Plug 'itchyny/lightline.vim'


" vim-fugitive
Plug 'tpope/vim-fugitive'

" gitsigns
Plug 'lewis6991/gitsigns.nvim'

" Inicio de los plugins necesarios para el LSP
" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}

" Plugin para los buffers: Scope
Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
" Plug 'ryanoasis/vim-devicons' Icons without colours
" Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
" Plug 'willothy/nvim-cokeline'

" Plugin de neo-tree
Plug 'nvim-tree/nvim-tree.lua'

Plug 'tiagovla/scope.nvim'

call plug#end()

" declarando el tema de colores
colorscheme snazzy

" Aca le estoy mostrando a nvim que existe la configuración para telescope
lua require ('drakúnom')

" ################## KeyMaps 

" LeaderKey
let mapleader=" "

nnoremap <leader>- <Esc> 


" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Toggle de NvimTree
nnoremap <leader>e :NvimTreeToggle<CR>


if !has('gui_running')
  set t_Co=256
endif


