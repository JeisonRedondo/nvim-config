return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim" },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"ts_ls", -- TypeScript / JavaScript
				"html", -- HTML
				"cssls", -- CSS
				"lua_ls", -- Lua (para tu config de Neovim)
			},
			-- Por defecto ya viene en true, pero lo dejamos explícito:
			-- llama a vim.lsp.enable() por vos apenas se instala un server.
			automatic_enable = true,
		},
	},
}
