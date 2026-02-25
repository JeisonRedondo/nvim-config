-- ~/.config/nvim/lua/plugins/lsp.lua
-- ============================================
-- LSP CONFIG – JS / TS / React con auto-imports reales
-- ============================================

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"ts_ls",
				"eslint",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"jsonls",
			},
			automatic_installation = true,
		},
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
		},

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ============================================
			-- LUA (Neovim)
			-- ============================================
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- ============================================
			-- TYPESCRIPT / JAVASCRIPT (AUTO-IMPORTS REAL)
			-- ============================================
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,

				init_options = {
					hostInfo = "neovim",
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsWithInsertText = true,
						includePackageJsonAutoImports = "auto",
						importModuleSpecifierPreference = "relative",
					},
				},

				settings = {
					typescript = {
						suggest = {
							includeCompletionsForModuleExports = true,
						},
						preferences = {
							importModuleSpecifier = "relative",
							jsxAttributeCompletionStyle = "auto",
							quotePreference = "double",
						},
					},
					javascript = {
						suggest = {
							includeCompletionsForModuleExports = true,
						},
						preferences = {
							importModuleSpecifier = "relative",
							jsxAttributeCompletionStyle = "auto",
							quotePreference = "double",
						},
					},
				},
			})

			-- ============================================
			-- HTML
			-- ============================================
			vim.lsp.config("html", {
				capabilities = capabilities,
			})

			-- ============================================
			-- CSS
			-- ============================================
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				settings = {
					css = { validate = true },
					scss = { validate = true },
					less = { validate = true },
				},
			})

			-- ============================================
			-- ESLINT (FIX ALL + IMPORTS)
			-- ============================================
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.code_action({
								context = { only = { "source.fixAll.eslint" } },
								apply = true,
							})
						end,
					})
				end,
			})

			-- ============================================
			-- JSON
			-- ============================================
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- ============================================
			-- TAILWIND
			-- ============================================
			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
			})

			-- ============================================
			-- HABILITAR SERVIDORES
			-- ============================================
			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",
				"eslint",
				"jsonls",
				"tailwindcss",
			})

			-- ============================================
			-- FORMATEO
			-- ============================================
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua", "*.json", "*.html", "*.css" },
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})

			-- ============================================
			-- KEYMAPS + IMPORTS
			-- ============================================
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					-- Navegación
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					-- Acciones
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					-- IMPORTS (las ÚNICAS válidas)
					vim.keymap.set("n", "<leader>oi", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.organizeImports" } },
							apply = true,
						})
					end, { buffer = ev.buf, desc = "Organizar imports" })

					vim.keymap.set("n", "<leader>fa", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.fixAll" } },
							apply = true,
						})
					end, { buffer = ev.buf, desc = "Fix all" })
				end,
			})
		end,
	},
}
