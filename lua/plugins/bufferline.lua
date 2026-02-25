return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local ok, bufferline = pcall(require, "bufferline")
		if not ok then
			return
		end

		vim.opt.termguicolors = true

		bufferline.setup({
			options = {
				mode = "tabs",
				themable = true,

				buffer_close_icon = "󰅖",
				modified_icon = "● ",
				close_icon = " ",

				enname_formatter = function(tab)
					local tabpages = vim.api.nvim_list_tabpages()
					local tabpage = tabpages[tab.ordinal] -- ordinal es seguro
					if not tabpage then
						return "Tab " .. tab.ordinal
					end

					local wins = vim.api.nvim_tabpage_list_wins(tabpage)
					local buffers = {}

					for _, win in ipairs(wins) do
						local buf = vim.api.nvim_win_get_buf(win)

						-- Opción: ignorar buffers efímeros de Snacks
						local ft = vim.bo[buf].filetype
						if ft ~= "snacks_picker" and ft ~= "snacks_terminal" then
							buffers[buf] = true
						end
					end

					local count = 0
					for _ in pairs(buffers) do
						count = count + 1
					end

					-- Nombre del buffer activo de la ventana principal
					local active_buf = vim.api.nvim_win_get_buf(wins[1])
					local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(active_buf), ":t")
					name = name ~= "" and name or ("Tab " .. tab.ordinal)

					return string.format("%s (%d)", name, count)
				end,
			},
		})
	end,
}
