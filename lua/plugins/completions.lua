-- ~/.config/nvim/lua/plugins/cmp.lua
-- Autocompletado con nvim-cmp

return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer", -- ← AGREGADO
	},
	{
		"hrsh7th/cmp-path", -- ← AGREGADO (PATHS)
	},
	{
		"hrsh7th/cmp-cmdline", -- ← AGREGADO (comandos)
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{
						name = "path", -- ← PATHS
						priority = 500,
						option = {
							trailing_slash = true,
						},
					},
				}, {
					{
						name = "buffer",
						priority = 250,
						keyword_length = 3, -- Solo autocompletar después de 3 chars
					},
				}),

				-- Formato con iconos (opcional pero bonito)
				formatting = {
					format = function(entry, vim_item)
						local icons = {
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
						}
						vim_item.menu = icons[entry.source.name]
						return vim_item
					end,
				},
			})

			-- Autocompletado en comandos (IMPORTANTE PARA PATHS)
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" }, -- Paths primero en comandos
				}, {
					{ name = "cmdline" },
				}),
			})

			-- Autocompletado en búsqueda
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
		end,
	},
}
