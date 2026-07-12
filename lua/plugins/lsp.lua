-- ============================================
-- LSP CONFIG (API nativa vim.lsp.config / vim.lsp.enable)
-- Requiere Neovim 0.11+
-- ============================================

return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		-- ============================================
		-- CAPABILITIES POR DEFECTO PARA TODOS LOS SERVERS
		-- blink.cmp le suma snippets, resolve, etc.
		-- Al configurarlo en el server "*" se aplica a todos
		-- los que registres después con vim.lsp.config().
		-- ============================================
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		-- ============================================
		-- TYPESCRIPT / JAVASCRIPT (ts_ls)
		-- ============================================
		local ts_inlay_hints = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		}

		vim.lsp.config("ts_ls", {
			settings = {
				typescript = { inlayHints = ts_inlay_hints },
				javascript = { inlayHints = ts_inlay_hints },
			},
		})

		-- ============================================
		-- HTML
		-- ============================================
		vim.lsp.config("html", {
			filetypes = { "html", "htmldjango" },
		})

		-- ============================================
		-- CSS
		-- ============================================
		vim.lsp.config("cssls", {
			settings = {
				css = { validate = true },
				scss = { validate = true },
				less = { validate = true },
			},
		})

		-- ============================================
		-- LUA (para tu propia config de Neovim)
		-- ============================================
		vim.lsp.config("lua_ls", {
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
		-- HABILITAR LOS SERVERS
		-- (mason-lspconfig ya los habilita solo al instalarlos,
		--  pero esto asegura que arranquen aunque cambies de máquina
		--  antes de que Mason termine de instalar algo)
		-- ============================================
		vim.lsp.enable({ "ts_ls", "html", "cssls", "lua_ls" })

		-- ============================================
		-- KEYMAPS: se activan solo en buffers con LSP adjunto
		-- ============================================
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				local client = vim.lsp.get_client_by_id(ev.data.client_id)

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)

				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				if client and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
					vim.keymap.set("n", "<leader>th", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
					end, opts)
				end
			end,
		})

		-- ============================================
		-- FORMATEO AUTOMÁTICO AL GUARDAR
		-- ============================================
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua", "*.json", "*.html", "*.css" },
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})

		-- ============================================
		-- DIAGNÓSTICOS
		-- ============================================
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
			float = { border = "rounded", source = "always", header = "", prefix = "" },
		})

		-- ============================================
		-- BORDES REDONDEADOS PARA VENTANAS FLOTANTES
		-- ============================================
		local orig_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, fopts, ...)
			fopts = fopts or {}
			fopts.border = fopts.border or "rounded"
			return orig_open_floating_preview(contents, syntax, fopts, ...)
		end
	end,
}
