-- lazy.nvim
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    format = {
      -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
      -- view: (default is cmdline view)
      -- opts: any options passed to the view
      -- icon_hl_group: optional hl_group for the icon
      -- title: set to anything or empty string to hide
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
      -- lua = false, -- to disable a format, set to `false`
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim", -- Necesario para la interfaz
    "rcarriga/nvim-notify", -- Opcional para notificaciones (si lo quieres usar)
  },
    config = function(_, opts)
    -- Configuración de Noice para los popups de la línea de comandos
    require("noice").setup({
      cmdline = {
        format = {
          search_down = {
            view = "cmdline", -- Usar la vista cmdline para búsqueda descendente
          },
          search_up = {
            view = "cmdline", -- Usar la vista cmdline para búsqueda ascendente
          },
        },
      },
      views = {
        -- Configuración del popup de cmdline
        cmdline_popup = {
          position = {
            row = 5,         -- Establecer la fila donde aparece el popup
            col = "50%",     -- Centrado horizontalmente
          },
          size = {
            width = 60,      -- Ancho del popup
            height = "auto", -- Altura automática
          },
        },
        -- Configuración del popup de los menús
        popupmenu = {
          relative = "editor",  -- Relacionado con el editor
          position = {
            row = 8,            -- Establecer la fila donde aparece el popup
            col = "50%",        -- Centrado horizontalmente
          },
          size = {
            width = 60,         -- Ancho del popup
            height = 10,        -- Altura del popup
          },
          border = {
            style = "rounded",  -- Borde redondeado
            padding = { 0, 1 }, -- Relleno del borde
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
    })

    -- Optional cleanup for lazyfiletype (solo si es necesario)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])  -- Limpiar mensajes si el tipo de archivo es 'lazy'
    end
  end,
}

