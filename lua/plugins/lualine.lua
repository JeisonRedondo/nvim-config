return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim"  },
  config = function()
    -- ============================================
    -- MODO: Solo Primera Letra
    -- ============================================
    local function mode_short()
      local mode_map = {
        n = "N",
        i = "I",
        v = "V",
        V = "VL",
        [""] = "VB",
        c = "C",
        s = "S",
        S = "SL",
        [""] = "SB",
        R = "R",
        t = "T",
      }
      local mode = vim.api.nvim_get_mode().mode
      return mode_map[mode] or mode
    end
    
    -- ============================================
    -- FILENAME: Con Icono y Path Personalizado
    -- ============================================
    local function filename_custom()
      local filename = vim.fn.expand("%:t")
      local parent = vim.fn.expand("%:h:t")
      local icon = require("nvim-web-devicons").get_icon(filename, vim.fn.expand("%:e"), { default = true })
      
      if parent == "." or parent == "" then
        return (icon and icon .. " " or "") .. filename
      else
        return (icon and icon .. " " or "") .. parent .. "/" .. filename
      end
    end
    
    -- ============================================
    -- MODIFICADO: Indicador más elegante
    -- ============================================
    local function modified_indicator()
      if vim.bo.modified then
        return "●"
      elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return ""
      end
      return ""
    end
    
    -- ============================================
    -- SETUP DE LUALINE
    -- ============================================
    require("lualine").setup({
      options = {
        theme = "catppuccin-mocha",
        section_separators = { left = "", right = "" },
        globalstatus = false,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "neo-tree", "Trouble" },
        },
      },
      
      sections = {
        -- IZQUIERDA
        lualine_a = {
          {
            mode_short,
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",  -- ← Icono de rama
            padding = { left = 1, right = 1 },
          },
          {
            "diff",
            colored = true,
            symbols = {
              added = "+",     -- ← Símbolo para líneas añadidas
              modified = "~",  -- ← Símbolo para líneas modificadas
              removed = "-",   -- ← Símbolo para líneas eliminadas
            },
          },
        },
        lualine_c = {
          {
            filename_custom,
            color = { gui = "bold" },
          },
          {
            modified_indicator,
            color = { fg = "#f38ba8" },
          },
        },
        
        -- DERECHA
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            sections = { "error", "warn" },
            symbols = {
              error = " ",  -- ← Icono de error
              warn = " ",   -- ← Icono de warning
            },
            colored = true,
            update_in_insert = false,
            always_visible = false,
          },
        },
        lualine_y = {
          {
            "progress",
            padding = { left = 1, right = 1 },
          },
        },
        lualine_z = {
          {
            "location",
            padding = { left = 1, right = 1 },
          },
        },
      },
      
      inactive_sections = {
        lualine_c = {
          {
            filename_custom,
            color = { gui = "italic" },
          },
        },
        lualine_x = { "location" },
      },
    })
  end,
}
