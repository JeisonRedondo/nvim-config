return {
  "NvChad/nvim-colorizer.lua",
  opts = {
    user_default_options = {
      names = true, -- también resalta nombres como "red", "blue", etc.
      rgb_fn = true, -- resalta funciones como rgb(255, 0, 0)
      hsl_fn = true, -- y hsl()
      css = true,    -- habilita soporte CSS
      mode = "background", -- o "foreground"
    },
  },
  config = function(_, opts)
    require("colorizer").setup(nil, opts)
  end,
}
