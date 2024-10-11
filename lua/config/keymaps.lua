-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- save file
local map = LazyVim.safe_keymap_set
map({ "i", "x", "n", "s" }, ",,", "<cmd>w<cr><esc>", { desc = "Save File" })

local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    -- Otras configuraciones
  },
  -- Otras opciones de configuración
})
