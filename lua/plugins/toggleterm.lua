return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-m>]],
        direction = "horizontal", -- Abre la terminal en una nueva pestaña
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
      })
    end,
  },
}
