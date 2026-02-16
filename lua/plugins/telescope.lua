return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			-- Keymap para buscar archivos en nuestra ubicacion actual
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			-- Keymap para buscar palabras en nuestros archivos
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			--  Keymap para ver los buffers abiertos
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			-- Keymaps para identificar palabras en los tags
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			-- Keymaps para ver el git status de git, donde ah cambiado el proyecto.
			vim.keymap.set("n", "<leader>fs", builtin.git_status, {})

			vim.keymap.set("n", "<leader>w", function()
				local key = vim.fn.getcharstr()

				local actions = {
					["-"] = function()
						vim.cmd("split")
						vim.cmd("wincmd j")
						return true
					end,

					["/"] = function()
						vim.cmd("vsplit")
						vim.cmd("wincmd l")
						return true
					end,
					["n"] = function()
						vim.cmd("bnext")
						return false
					end,

					["p"] = function()
						vim.cmd("bprev")
						return false
					end,
					["h"] = function()
						vim.cmd("wincmd h")
						return false
					end,

					["l"] = function()
						vim.cmd("wincmd l")
						return false
					end,

					["k"] = function()
						vim.cmd("wincmd k")
						return false
					end,

					["j"] = function()
						vim.cmd("wincmd j")
						return false
					end,

					["t"] = function()
						vim.cmd("tabnew")
						return true
					end,

					["T"] = function()
						vim.cmd("tabnext")
						return false
					end,
				}

				local action = actions[key]
				if not action then
					return
				end

				local open_picker = action()
				if open_picker then
					vim.schedule(function()
						builtin.find_files()
					end)
				end
			end, { silent = true })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
