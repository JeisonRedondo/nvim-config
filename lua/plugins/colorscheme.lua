return {
  {
    "samharju/synthweave.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("synthweave")
      -- transparent version
      -- vim.cmd.colorscheme("synthweave-transparent")
    end,
  },
  {
    "maxmx03/fluoromachine.nvim",
    config = function()
      local fm = require("fluoromachine")
      fm.setup({
        glow = true,
        theme = "retrowave",
        colors = function(_, color)
          local darken = color.darken
          local lighten = color.lighten
          local blend = color.blend
          local shade = color.shade
          local tint = color.tint
          return {
            bg = "#190920",
            bgdark = darken("#190920", 20),
            cyan = "#49eaff",
            red = "#ff1e34",
            yellow = "#ffe756",
            orange = "#f38e21",
            pink = "#ffadff",
            purple = "#9544f7",
          }
        end,
      })
      vim.cmd.colorscheme("fluoromachine")
    end,
  },
}
