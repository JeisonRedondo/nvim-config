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
      -- Keymaps para 
     vim.keymap.set('n','<leader>fh', builtin.help_tags, {})
     
     vim.keymap.set('n','<leader>fs', builtin.git_status, {})

      


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
