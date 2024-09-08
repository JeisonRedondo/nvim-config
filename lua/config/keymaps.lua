-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- save file
local map = LazyVim.safe_keymap_set
map({ "i", "x", "n", "s" }, ",,", "<cmd>w<cr><esc>", { desc = "Save File" })

