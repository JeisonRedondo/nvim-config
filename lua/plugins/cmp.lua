-- ============================================================================
-- ARCHIVO 2: ~/.config/nvim/lua/plugins/cmp.lua
-- ============================================================================
-- Configuración de nvim-cmp con soporte completo para auto-imports

return {
	-- Dependencies first
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},

	-- nvim-cmp main plugin
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Cargar snippets de friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- ================================================
			-- CONFIGURACIÓN PRINCIPAL DE CMP
			-- ================================================
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					-- Scroll docs
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Trigger completion
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),

					-- Confirm
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true, -- Auto-select first item
					}),

					-- Tab/S-Tab para navegación y snippets
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				-- ================================================
				-- SOURCES (orden importa para prioridad)
				-- ================================================
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
						priority = 1000,
						-- CRÍTICO: No filtrar nada, dejar que LSP muestre todo
						entry_filter = function(entry, ctx)
							return true
						end,
					},
					{ name = "luasnip", priority = 750 },
					{
						name = "path",
						priority = 500,
						option = { trailing_slash = true },
					},
				}, {
					{
						name = "buffer",
						priority = 250,
						keyword_length = 3,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
				}),

				-- ================================================
				-- FORMATTING (iconos y labels)
				-- ================================================
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						-- Iconos por kind
						local kind_icons = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏆",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "",
						}

						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

						-- Source name
						local source_names = {
							nvim_lsp = "[LSP]",
							luasnip = "[Snip]",
							buffer = "[Buf]",
							path = "[Path]",
						}
						vim_item.menu = source_names[entry.source.name] or ""

						return vim_item
					end,
				},

				-- ================================================
				-- EXPERIMENTAL: Ghost text
				-- ================================================
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
			})

			-- ================================================
			-- CMP PARA COMANDOS (paths incluidos)
			-- ================================================
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			-- ================================================
			-- CMP PARA BÚSQUEDA
			-- ================================================
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- ================================================
			-- HIGHLIGHT PARA GHOST TEXT
			-- ================================================
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		end,
	},
}
