-- ============================================================================
-- ARCHIVO: ~/.config/nvim/lua/plugins/lsp.lua
-- ============================================================================
-- Neovim 0.11+ (vim.lsp.config + vim.lsp.enable)
-- - Auto-imports y source actions correctas para TS/JS
-- - ESLint fix-on-save usando LspEslintFixAll (Nvim 0.11+)
-- - Keymaps LSP sin conflictos con <leader>f (files/find)
-- ============================================================================

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
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
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
				-- Neovim 0.11+
				automatic_enable = true,
			})
		end,
	},

	-- nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 98,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ------------------------------------------------
			-- LUA
			-- ------------------------------------------------
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
						format = { enable = false },
					},
				},
			})

			-- ------------------------------------------------
			-- TS/JS (ts_ls)
			-- ------------------------------------------------
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				init_options = {
					hostInfo = "neovim",
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsWithInsertText = true,
						includePackageJsonAutoImports = "auto",
						importModuleSpecifierPreference = "relative",
						jsxAttributeCompletionStyle = "auto",
						quotePreference = "double",
					},
				},
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

			-- ------------------------------------------------
			-- HTML
			-- ------------------------------------------------
			vim.lsp.config("html", {
				capabilities = capabilities,
				filetypes = { "html", "htmldjango" },
			})

			-- ------------------------------------------------
			-- CSS
			-- ------------------------------------------------
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

			-- ------------------------------------------------
			-- ESLint (fix-on-save correcto en Nvim 0.11+)
			-- ------------------------------------------------
			local base_eslint_on_attach = vim.lsp.config.eslint and vim.lsp.config.eslint.on_attach or nil

			vim.lsp.config("eslint", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Mantener el on_attach base de lspconfig (crea el comando LspEslintFixAll)
					if base_eslint_on_attach then
						base_eslint_on_attach(client, bufnr)

						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "LspEslintFixAll",
						})
					end

					-- Fix al guardar (usa el comando buffer-local creado por lspconfig)
				end,
				settings = {
					workingDirectories = { mode = "auto" },
				},
			})

			-- ------------------------------------------------
			-- JSON
			-- ------------------------------------------------
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- ------------------------------------------------
			-- Tailwind
			-- ------------------------------------------------
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

			-- ------------------------------------------------
			-- HABILITAR SERVIDORES
			-- ------------------------------------------------
			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",
				"eslint",
				"jsonls",
				"tailwindcss",
			})

			-- ------------------------------------------------
			-- FORMAT ON SAVE (sin ts_ls)
			-- ------------------------------------------------
			local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_group,
				pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua", "*.json", "*.html", "*.css" },
				callback = function()
					vim.lsp.buf.format({
						async = false,
						timeout_ms = 2000,
						filter = function(c)
							return c.name ~= "ts_ls"
						end,
					})
				end,
			})

			-- ------------------------------------------------
			-- KEYMAPS (LspAttach)
			-- ------------------------------------------------
			local function source_action(kinds)
				vim.lsp.buf.code_action({
					context = { only = kinds, diagnostics = {} },
					apply = true,
				})
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					-- Navegación
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

					-- Docs
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					-- Formateo manual: lo movemos a <leader>cF para no romper <leader>f (files)
					vim.keymap.set("n", "<leader>cF", function()
						vim.lsp.buf.format({ async = true })
					end, { buffer = ev.buf, silent = true, desc = "Format (LSP)" })

					-- -------------------------
					-- TS/JS source actions (kinds correctos)
					-- -------------------------
					vim.keymap.set("n", "<leader>cM", function()
						source_action({ "source.addMissingImports.ts", "source.addMissingImports" })
					end, { buffer = ev.buf, silent = true, desc = "Añadir imports faltantes" })

					vim.keymap.set("n", "<leader>co", function()
						source_action({ "source.organizeImports.ts", "source.organizeImports" })
					end, { buffer = ev.buf, silent = true, desc = "Organizar imports" })

					vim.keymap.set("n", "<leader>cr", function()
						source_action({ "source.removeUnusedImports.ts", "source.removeUnusedImports" })
					end, { buffer = ev.buf, silent = true, desc = "Eliminar imports no usados" })

					vim.keymap.set("n", "<leader>cf", function()
						source_action({ "source.fixAll.ts", "source.fixAll" })
					end, { buffer = ev.buf, silent = true, desc = "Fix all (TS)" })

					-- Diagnósticos
					vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, opts)
				end,
			})

			-- ------------------------------------------------
			-- Diagnósticos UI
			-- ------------------------------------------------
			vim.diagnostic.config({
				virtual_text = { prefix = "●", source = "if_many" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
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

			-- Bordes redondeados en hovers/signature/etc.
			local orig = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, o, ...)
				o = o or {}
				o.border = o.border or "rounded"
				return orig(contents, syntax, o, ...)
			end
		end,
	},
}
