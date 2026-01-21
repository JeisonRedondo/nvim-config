-- Configuración de CodeCompanion con Hugging Face (100% Gratis)
-- Usa la API de inferencia gratuita de Hugging Face

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",                    -- Opcional: para autocompletado
    "nvim-telescope/telescope.nvim",       -- Opcional: para UI mejorada
    { "stevearc/dressing.nvim", opts = {} }, -- Opcional: para mejores inputs
    "ravitemer/codecompanion-history.nvim", -- Extensión para historial de chats
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "huggingface",
        },
        inline = {
          adapter = "huggingface",
        },
        agent = {
          adapter = "huggingface",
        },
      },
      adapters = {
        http = {
          huggingface = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "huggingface",
              url = "https://router.huggingface.co/v1/chat/completions",
              env = {
                api_key = "HUGGINGFACE_API_KEY",
              },
              headers = {
                ["Content-Type"] = "application/json",
              },
              schema = {
                model = {
                  -- Modelos gratuitos disponibles:
                  default = "meta-llama/Llama-3.2-3B-Instruct",
                  choices = {
                    "meta-llama/Llama-3.2-3B-Instruct", -- Gratis y rápido
                    "mistralai/Mistral-7B-Instruct-v0.3", -- Gratis
                    "microsoft/Phi-3.5-mini-instruct", -- Gratis
                    "google/gemma-2-2b-it",     -- Gratis
                  },
                },
                temperature = {
                  default = 0.7,
                },
                max_tokens = {
                  default = 4096,
                },
              },
            })
          end,
          opts = {
            timeout_ms = 60000, -- Timeout más largo para modelos gratuitos
          },
        },
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
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              list = false,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },
          show_settings = true,
          -- Deshabilitar keymaps por defecto que interfieren
          keymaps = {
            close = {
              modes = {
                n = "q", -- Cambiar de <C-c> a 'q' para cerrar
                i = false, -- Deshabilitar <C-c> en insert mode
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
        action_palette = {
          provider = "telescope",
        },
      },
      opts = {
        log_level = "INFO",
        send_code = true,
        use_default_actions = true,
        use_default_prompt_library = true,
        -- Sistema de prompts global para que SIEMPRE responda en español
        system_prompt = [[Eres un asistente de programación experto.
IMPORTANTE: Debes responder SIEMPRE en español, sin importar el idioma de la pregunta.
Sé claro, conciso y proporciona ejemplos de código cuando sea apropiado.
Explica conceptos técnicos de manera comprensible.]],
      },
      -- Extensión de historial de chats
      extensions = {
        history = {
          enabled = true,
          opts = {
            -- Tecla para abrir el historial desde el chat buffer
            keymap = "gh",
            -- Tecla para guardar manualmente el chat actual
            save_chat_keymap = "sc",
            -- Guardar todos los chats automáticamente
            auto_save = true,
            -- Días antes de borrar chats automáticamente (0 = nunca)
            expiration_days = 0,
            -- Interfaz de selección (telescope, fzf-lua, snacks, o default)
            picker = "telescope",
            -- Keymaps personalizados del picker
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
          },
        },
      },
      prompt_library = {
        ["Explicar código"] = {
          strategy = "chat",
          description = "Explica el código seleccionado",
          opts = {
            index = 1,
            is_default = true,
            is_slash_cmd = false,
            user_prompt = true,
          },
          prompts = {
            {
              role = "system",
              content = "Eres un experto programador. Explica el código de manera clara y concisa en español.",
            },
            {
              role = "user",
              content = function(context)
                return "Por favor explica este código:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. context.selection
                    .. "\n```"
              end,
            },
          },
        },
        ["Optimizar código"] = {
          strategy = "chat",
          description = "Sugiere optimizaciones para el código",
          opts = {
            index = 2,
          },
          prompts = {
            {
              role = "system",
              content = "Eres un experto en optimización de código. Sugiere mejoras de rendimiento y mejores prácticas.",
            },
            {
              role = "user",
              content = function(context)
                return "Analiza y optimiza este código:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. context.selection
                    .. "\n```"
              end,
            },
          },
        },
        ["Corregir bugs"] = {
          strategy = "chat",
          description = "Identifica y corrige posibles bugs",
          opts = {
            index = 3,
          },
          prompts = {
            {
              role = "system",
              content = "Eres un experto en debugging. Identifica problemas potenciales y sugiere correcciones.",
            },
            {
              role = "user",
              content = function(context)
                return "Revisa este código en busca de bugs:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. context.selection
                    .. "\n```"
              end,
            },
          },
        },
        ["Generar tests"] = {
          strategy = "chat",
          description = "Genera tests unitarios para el código",
          opts = {
            index = 4,
          },
          prompts = {
            {
              role = "system",
              content = "Eres un experto en testing. Genera tests unitarios completos y bien documentados.",
            },
            {
              role = "user",
              content = function(context)
                return "Genera tests para este código:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. context.selection
                    .. "\n```"
              end,
            },
          },
        },
      },
    })

    -- Keymaps recomendados
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Chat (con opción de posición derecha)
    keymap("n", "<leader>cc", function()
      vim.cmd("CodeCompanionChat")
      -- Mover la ventana a la derecha después de abrirse
      vim.defer_fn(function()
        vim.cmd("wincmd L")
      end, 50)
    end, opts)

    keymap("v", "<leader>cc", function()
      vim.cmd("CodeCompanionChat")
      vim.defer_fn(function()
        vim.cmd("wincmd L")
      end, 50)
    end, opts)

    keymap("n", "<leader>ct", function()
      vim.cmd("CodeCompanionChat Toggle")
      vim.defer_fn(function()
        vim.cmd("wincmd L")
      end, 50)
    end, opts)

    -- Acciones inline
    keymap("n", "<leader>ce", "<cmd>CodeCompanionActions<cr>", opts)
    keymap("v", "<leader>ce", "<cmd>CodeCompanionActions<cr>", opts)

    -- Agregar código al chat
    keymap("v", "<leader>cA", "<cmd>CodeCompanionChat Add<cr>", opts)

    -- Comandos slash en el chat
    keymap("n", "<leader>c/", "<cmd>CodeCompanion /cmd<cr>", opts)

    -- Abrir historial de chats (alternativa global además de 'gh' dentro del chat)
    keymap("n", "<leader>ch", function()
      vim.cmd("CodeCompanionHistory")
      -- Mover la ventana a la derecha después de abrirse
      vim.defer_fn(function()
        -- Buscar el buffer de codecompanion y moverlo
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
          if ft == "codecompanion" then
            vim.api.nvim_set_current_win(win)
            vim.cmd("wincmd L")
            break
          end
        end
      end, 100)
    end, opts)

    -- FIX: Ctrl+C ahora funciona normalmente para salir de insert mode
    -- Usar defer_fn para asegurar que se ejecute después de que CodeCompanion configure sus keymaps
    vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
      pattern = "codecompanion",
      callback = function(ev)
        -- Mover automáticamente a la derecha cuando se abra cualquier buffer de codecompanion
        vim.defer_fn(function()
          local current_win = vim.api.nvim_get_current_win()
          local buf = vim.api.nvim_win_get_buf(current_win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

          if ft == "codecompanion" then
            vim.cmd("wincmd L")
          end
        end, 50)

        vim.defer_fn(function()
          -- Forzar el remapeo de Ctrl+C
          pcall(vim.keymap.del, "i", "<C-c>", { buffer = ev.buf })
          pcall(vim.keymap.del, "n", "<C-c>", { buffer = ev.buf })

          -- Establecer el nuevo comportamiento
          vim.keymap.set("i", "<C-c>", "<Esc>", { buffer = ev.buf, noremap = true, silent = true })
          vim.keymap.set("n", "<C-c>", "<Nop>", { buffer = ev.buf, noremap = true, silent = true })

          -- Usar 'q' o <leader>q para cerrar el chat
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, noremap = true, silent = true })
          vim.keymap.set(
            "n",
            "<leader>q",
            "<cmd>close<cr>",
            { buffer = ev.buf, noremap = true, silent = true }
          )
        end, 100) -- Esperar 100ms para que CodeCompanion termine de configurar
      end,
    })
  end,
}
