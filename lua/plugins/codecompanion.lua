-- ============================================
-- CODECOMPANION - SOLUCIÓN DEFINITIVA
-- ============================================
-- Detecta el buffer por NOMBRE, no por filetype
-- Porque el filetype es "lua", no "codecompanion"

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
		{ "stevearc/dressing.nvim", opts = {} },
	},

	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = { adapter = "ollama" },
				inline = { adapter = "ollama" },
				agent = { adapter = "ollama" },
			},

			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "ollama",
						schema = {
							model = {
								default = "qwen2.5-coder:7b",
								choices = {
									"qwen2.5-coder:7b",
									"deepseek-r1:7b",
									"llama3.2:3b",
									"codellama:7b",
								},
							},
							num_ctx = { default = 32768 },
							temperature = { default = 0.3 },
						},
					})
				end,

				huggingface = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						name = "huggingface",
						url = "https://api-inference.huggingface.co/models/meta-llama/Llama-3.2-3B-Instruct/v1/chat/completions",
						env = {
							api_key = "HUGGINGFACE_API_KEY",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						schema = {
							model = {
								default = "meta-llama/Llama-3.2-3B-Instruct",
							},
							temperature = { default = 0.7 },
							max_tokens = { default = 4096 },
						},
					})
				end,
			},

			display = {
				diff = {
					provider = "mini_diff",
				},
				chat = {
					window = {
						layout = "vertical",
						width = 0.45,
						height = 0.8,
						relative = "editor",
					},
					show_settings = true,
					keymaps = {
						close = {
							modes = {
								n = "q",
								i = false,
							},
						},
						send = {
							modes = {
								n = "<CR>",
								i = "<C-s>",
							},
						},
					},
				},
			},

			opts = {
				log_level = "ERROR",
				send_code = true,
				use_default_actions = true,
				system_prompt = [[Eres un asistente experto en programación.
SIEMPRE responde en español.
Especialízate en JavaScript, TypeScript y desarrollo web.
Sé claro, conciso y proporciona ejemplos prácticos.]],
			},

			prompt_library = {
				["Explicar código"] = {
					strategy = "chat",
					description = "Explica el código seleccionado",
					prompts = {
						{
							role = "system",
							content = "Explica código de forma clara para alguien aprendiendo programación.",
						},
						{
							role = "user",
							content = function(context)
								return "Explica este código:\n\n```"
									.. context.filetype
									.. "\n"
									.. context.selection
									.. "\n```"
							end,
						},
					},
				},
				["Encontrar bugs"] = {
					strategy = "chat",
					description = "Revisa el código en busca de errores",
					prompts = {
						{
							role = "system",
							content = "Eres un experto en debugging.",
						},
						{
							role = "user",
							content = function(context)
								return "Revisa bugs:\n\n```" .. context.filetype .. "\n" .. context.selection .. "\n```"
							end,
						},
					},
				},
			},
		})

		-- ============================================
		-- SOLUCIÓN: Detectar por NOMBRE de buffer
		-- ============================================
		-- Como el filetype es "lua", detectamos por nombre

		local function is_codecompanion_buffer(buf)
			local bufname = vim.api.nvim_buf_get_name(buf)
			-- Los buffers de CodeCompanion tienen "codecompanion" en el nombre
			return bufname:match("codecompanion") ~= nil or bufname:match("CodeCompanion") ~= nil
		end

		local function setup_codecompanion_keymaps(buf)
			-- Verificar que sea realmente un buffer de CodeCompanion
			if not is_codecompanion_buffer(buf) then
				return
			end

			-- ENTER: Enviar mensaje
			pcall(vim.keymap.del, "n", "<CR>", { buffer = buf })
			vim.keymap.set("n", "<CR>", function()
				pcall(vim.cmd, "CodeCompanionChat Submit")
			end, {
				buffer = buf,
				noremap = true,
				silent = true,
				desc = "Enviar mensaje",
			})
		end

		-- ============================================
		-- AUTOCMD: Detectar CUALQUIER buffer nuevo
		-- ============================================
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = "*",
			callback = function(ev)
				local buf = ev.buf

				-- Verificar si es buffer de CodeCompanion
				if is_codecompanion_buffer(buf) then
					-- Mover a la derecha
					vim.defer_fn(function()
						vim.cmd("wincmd L")
					end, 50)

					-- Aplicar keymaps
					vim.defer_fn(function()
						setup_codecompanion_keymaps(buf)
					end, 100)

					-- Reaplicar keymaps (por si CodeCompanion los sobrescribe)
					vim.defer_fn(function()
						setup_codecompanion_keymaps(buf)
					end, 250)
				end
			end,
		})

		-- ============================================
		-- REFORZAR: Cuando entras a insert y sales
		-- ============================================
		vim.api.nvim_create_autocmd("InsertLeave", {
			pattern = "*",
			callback = function(ev)
				if is_codecompanion_buffer(ev.buf) then
					vim.schedule(function()
						setup_codecompanion_keymaps(ev.buf)
					end)
				end
			end,
		})
	end,
}
