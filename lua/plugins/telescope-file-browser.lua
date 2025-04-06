return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").load_extension("file_browser")
    vim.keymap.set('n', '<leader>fe', function()
      require("telescope").extensions.file_browser.file_browser({
        path = "%:p:h", -- abre en el directorio del archivo actual
        select_buffer = true,
        hidden = true,
        grouped = true,
        previewer = false,
        layout_config = { height = 40 },
        initial_mode = "normal",
      })
    end, { desc = "File Browser" })
  end
}
