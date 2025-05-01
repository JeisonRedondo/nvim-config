return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      -- Keymap para buscar archivos en nuestra ubicacion actual
      vim.keymap.set('n','<leader>ff', builtin.find_files, {})
      -- Keymap para buscar palabras en nuestros archivos
      vim.keymap.set('n','<leader>fg', builtin.live_grep, {})
      --  Keymap par aver los buffers abiertos
      vim.keymap.set('n','<leader>fb', builtin.buffers, {})
      -- Keymaps para identificar palabras en los tags 
      vim.keymap.set('n','<leader>fh', builtin.help_tags, {})
      -- Keymaps para ver el git status de git, donde ah cambiado el proyecto.
      vim.keymap.set('n','<leader>fs', builtin.git_status, {})

      -- División horizontal + mover foco + abrir find_files
      vim.keymap.set('n', '<C-w>h', function()
        vim.cmd('split')
        vim.cmd('wincmd j')
        vim.schedule(builtin.find_files)
      end, { noremap = true, silent = true })
      -- División vertical + mover foco + abrir find_files
      vim.keymap.set('n', '<C-w>v', function()
        vim.cmd('vsplit')
        vim.cmd('wincmd l')
        vim.schedule(builtin.find_files)
      end, { noremap = true, silent = true })

    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup ({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  },
}
