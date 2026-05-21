-- This file contains the configuration for the oil.nvim plugin in Neovim.

return {
	-- Plugin: oil.nvim
	-- URL: https://github.com/stevearc/oil.nvim
	-- Description: A Neovim plugin for managing and navigating directories.
	"stevearc/oil.nvim",

	opts = {
		-- Key mappings for oil.nvim actions
		watch_for_changes = true,
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
			-- This function defines what is considered a "hidden" file
			is_hidden_file = function(name, bufnr)
				local m = name:match("^%.")
				return m ~= nil
			end,
			-- This function defines what will never be shown, even when `show_hidden` is set
			is_always_hidden = function(name, bufnr)
				return false
			end,
			-- Sort file names with numbers in a more intuitive order for humans.
			-- Can be "fast", true, or false. "fast" will turn it off for large directories.
			natural_order = "fast",
			-- Sort file and directory names case insensitive
			case_insensitive = false,
			sort = {
				-- sort order can be "asc" or "desc"
				-- see :help oil-columns to see which columns are sortable
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
		keymaps = {
			["g?"] = "actions.show_help", -- Show help
			["<CR>"] = "actions.select", -- Select entry
			["<C-M-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" }, -- Open entry in vertical split
			["<C-d>"] = {
				"actions.select",
				opts = { horizontal = true },
				desc = "Open the entry in a horizontal split",
			}, -- Open entry in horizontal split
			["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" }, -- Open entry in new tab
			["<C-p>"] = "actions.preview", -- Preview entry
			["<C-q>"] = "actions.close", -- Close oil.nvim
			["<C-l>"] = "actions.refresh", -- Refresh oil.nvim
			["-"] = "actions.parent", -- Go to parent directory
			["_"] = "actions.open_cwd", -- Open current working directory
			["`"] = "actions.cd", -- Change directory
			["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" }, -- Change directory for the current tab
			["gs"] = "actions.change_sort", -- Change sorting method
			["gx"] = "actions.open_external", -- Open entry with external application
			["g."] = "actions.toggle_hidden", -- Toggle hidden files
			["g\\"] = "actions.toggle_trash", -- Toggle trash
		},
		use_default_keymaps = false, -- Do not use default key mappings
	},

	-- Optional dependencies
	dependencies = {
		-- Plugin: nvim-web-devicons
		-- URL: https://github.com/nvim-tree/nvim-web-devicons
		-- Description: A Lua fork of vim-web-devicons for Neovim.
		"nvim-tree/nvim-web-devicons",
	},
}
