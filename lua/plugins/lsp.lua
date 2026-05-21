-- ============================================
-- LSP CONFIG - Con formateo integrado
-- ============================================
-- SIN none-ls - El LSP hace todo el formateo
-- Optimizado para JS/TS/Web Development

return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ============================================
			-- CONFIGURACIÓN POR SERVIDOR
			-- ============================================

			-- LUA (para Neovim)
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- TYPESCRIPT/JAVASCRIPT
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
						},
					},
				},
			})

			-- HTML
			vim.lsp.config("html", {
				capabilities = capabilities,
				filetypes = { "html", "htmldjango" },
			})

			-- CSS
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				settings = {
					css = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					scss = {
						validate = true,
					},
					less = {
						validate = true,
					},
				},
			})

			-- ESLINT
			-- Desde la documentación de nvim-lspconfig para eslint
			local base_on_attach = vim.lsp.config.eslint.on_attach
			vim.lsp.config("eslint", {
				on_attach = function(client, bufnr)
					if base_on_attach then
						base_on_attach(client, bufnr)
					end
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "LspEslintFixAll", -- Este es el comando que falla
					})
				end,
			})
			-- JSON
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- TailwindCSS (opcional)
			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
			})

			-- ============================================
			-- HABILITAR TODOS LOS SERVIDORES
			-- ============================================
			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",
				"eslint",
				"jsonls",
			})

			-- ============================================
			-- FORMATEO AUTOMÁTICO AL GUARDAR
			-- ============================================
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua", "*.json" },
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})

			-- ============================================
			-- KEYMAPS DE LSP
			-- ============================================
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					-- Navegación
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

					-- Documentación
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

					-- Acciones
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- Diagnósticos
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
				end,
			})

			-- ============================================
			-- CONFIGURACIÓN DE DIAGNÓSTICOS
			-- ============================================
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					source = "if_many",
				},
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

			-- ============================================
			-- BORDES REDONDEADOS PARA VENTANAS FLOTANTES
			-- ============================================
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end,
	},
}
