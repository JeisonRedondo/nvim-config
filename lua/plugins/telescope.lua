return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      -- Keymap para buscar archivos en nuestra ubicacion actual
      vim.keymap.set('n','<leader>e', builtin.find_files, {})
      -- Keymap para buscar palabras en nuestros archivos
      vim.keymap.set('n','<leader>fg', builtin.live_grep, {})
    end
}
