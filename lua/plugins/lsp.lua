-- ============================================================================
-- ARCHIVO 1: ~/.config/nvim/lua/plugins/lsp.lua
-- ============================================================================
-- Configuraci├│n DEFINITIVA de LSP basada en nvim-lspconfig oficial
-- Compatible con Neovim 0.11+ y mejores pr├ícticas 2024-2025
-- AUTO-IMPORTS REALES para TypeScript/JavaScript/React

return {
	-- Mason: Instalador de LSP servers
	{
		"williamboman/mason.nvim",
		lazy = false,
		priority = 100,
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "Ô£ô",
						package_pending = "Ô×£",
						package_uninstalled = "Ô£ù",
					},
				},
			})
		end,
	},

	-- Mason-LSPConfig: Puente entre Mason y nvim-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		priority = 99,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls", -- TypeScript/JavaScript
					"eslint", -- Linter/Formatter
					"html", -- HTML
					"cssls", -- CSS/SCSS
					"tailwindcss", -- Tailwind CSS
					"lua_ls", -- Lua
					"jsonls", -- JSON
				},
				-- IMPORTANTE: En Neovim 0.11+, automatic_enable reemplaza automatic_setup
				-- Esto permite que vim.lsp.enable() funcione correctamente
				automatic_enable = true,
			})
		end,
	},

	-- nvim-lspconfig: Configuraciones oficiales de LSP
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 98,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Para capabilities de autocompletado
			"b0o/schemastore.nvim", -- Para JSON schemas
		},

		config = function()
			-- ================================================
			-- CAPABILITIES (para que LSP funcione con nvim-cmp)
			-- ================================================
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ================================================
			-- CONFIGURACI├ôN: LUA (para configuraci├│n de Neovim)
			-- ================================================
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
						format = { enable = false }, -- Usar stylua externo
					},
				},
			})

			-- ================================================
			-- CONFIGURACI├ôN: TYPESCRIPT/JAVASCRIPT (LA CLAVE)
			-- ================================================
			-- Basado en la configuraci├│n oficial de nvim-lspconfig
			-- y typescript-language-server documentation
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,

				-- CRITICAL: init_options es REQUERIDO para auto-imports
				init_options = {
					hostInfo = "neovim",
					preferences = {
						-- ESTAS son las opciones que hacen funcionar auto-import
						includeCompletionsForModuleExports = true,
						includeCompletionsWithInsertText = true,
						includePackageJsonAutoImports = "auto",
						importModuleSpecifierPreference = "relative",
						jsxAttributeCompletionStyle = "auto",
						quotePreference = "double",
					},
				},

				-- Settings adicionales (opcional pero recomendado)
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
						suggest = {
							includeCompletionsForModuleExports = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
						suggest = {
							includeCompletionsForModuleExports = true,
						},
					},
				},
			})

			-- ================================================
			-- CONFIGURACI├ôN: HTML
			-- ================================================
			vim.lsp.config("html", {
				capabilities = capabilities,
				filetypes = { "html", "htmldjango" },
			})

			-- ================================================
			-- CONFIGURACI├ôN: CSS/SCSS/Less
			-- ================================================
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				settings = {
					css = {
						validate = true,
						lint = { unknownAtRules = "ignore" },
					},
					scss = { validate = true },
					less = { validate = true },
				},
			})

			-- ================================================
			-- CONFIGURACI├ôN: ESLINT (Linter + Formatter)
			-- ================================================
			-- Guarda el on_attach base (antes de sobreescribirlo)
			local base_eslint_on_attach = vim.lsp.config.eslint and vim.lsp.config.eslint.on_attach or nil

			vim.lsp.config("eslint", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Esto crea el comando buffer-local :LspEslintFixAll
					if base_eslint_on_attach then
						base_eslint_on_attach(client, bufnr)
					end

					-- Fix al guardar
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "LspEslintFixAll",
					})
				end,
				settings = {
					workingDirectories = { mode = "auto" },
				},
			})
			-- ================================================
			-- CONFIGURACI├ôN: JSON
			-- ================================================
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- ================================================
			-- CONFIGURACI├ôN: TAILWIND CSS
			-- ================================================
			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
								{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
							},
						},
					},
				},
			})

			-- ================================================
			-- HABILITAR TODOS LOS SERVIDORES (IMPORTANTE)
			-- ================================================
			-- En Neovim 0.11+, vim.lsp.enable() reemplaza setup()
			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",
				"eslint",
				"jsonls",
				"tailwindcss",
			})

			-- ================================================
			-- FORMATEO AUTOM├üTICO AL GUARDAR
			-- ================================================
			local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_group,
				pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua", "*.json", "*.html", "*.css" },
				callback = function()
					vim.lsp.buf.format({
						async = false,
						timeout_ms = 2000,
						-- No usar ts_ls para formatear (usa eslint/prettier)
						filter = function(client)
							return client.name ~= "ts_ls"
						end,
					})
				end,
			})

			-- ================================================
			-- KEYMAPS DE LSP (con LspAttach)
			-- ================================================
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					-- Navegaci├│n
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

					-- Documentaci├│n
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

					-- Acciones b├ísicas
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- ================================================
					-- IMPORTS (source actions)
					-- ================================================
					-- Organizar imports (quitar no usados + ordenar)
					vim.keymap.set("n", "<leader>co", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.organizeImports" }, diagnostics = {} },
							apply = true,
						})
					end, { buffer = ev.buf, silent = true, desc = "Organizar imports" })

					-- Remover imports no usados
					vim.keymap.set("n", "<leader>cr", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.removeUnused" }, diagnostics = {} },
							apply = true,
						})
					end, { buffer = ev.buf, silent = true, desc = "Remover no usados" })

					-- Fix all (organizar + fixAll)
					vim.keymap.set("n", "<leader>cf", function()
						vim.lsp.buf.code_action({
							context = { only = { "source" }, diagnostics = {} },
							apply = true,
						})
					end, { buffer = ev.buf, silent = true, desc = "Fix all (source)" })

					-- Diagn├│sticos
					vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, opts)
				end,
			})

			-- ================================================
			-- CONFIGURACI├ôN DE DIAGN├ôSTICOS
			-- ================================================
			vim.diagnostic.config({
				virtual_text = {
					prefix = "ÔùÅ",
					source = "if_many",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "Ô£ÿ",
						[vim.diagnostic.severity.WARN] = "Ôû▓",
						[vim.diagnostic.severity.HINT] = "ÔÜæ",
						[vim.diagnostic.severity.INFO] = "┬╗",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			-- ================================================
			-- UI: Bordes redondeados
			-- ================================================
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end,
	},
}
