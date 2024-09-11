return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        direction = "horizontal", -- Asegura que la terminal se abra horizontalmente
        size = 10, -- Ajusta el tamaño de la terminal
        open_mapping = [[<c-i>]], -- Atajo para abrir la terminal
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
      })
    end,
  },
}
