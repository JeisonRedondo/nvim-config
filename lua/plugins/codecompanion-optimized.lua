-- ============================================
-- CODECOMPANION - IA Local + Cloud
-- ============================================
-- Soporta:
-- - Ollama (local, gratis)
-- - HuggingFace (cloud, gratis)
-- - Perplexity (búsqueda web)
-- 
-- Modelos recomendados:
-- - qwen2.5-coder:7b (mejor para código)
-- - deepseek-r1:7b (razonamiento)
-- - llama3.2:3b (ligero)

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
      -- Estrategia por defecto: Ollama local
      strategies = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
        agent = { adapter = "ollama" },
      },
      
      adapters = {
        -- OLLAMA LOCAL (GRATIS, PRIVADO)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "ollama",
            schema = {
              model = {
                default = "qwen2.5-coder:7b",
                choices = {
                  "qwen2.5-coder:7b",    -- Mejor para código
                  "deepseek-r1:7b",      -- Razonamiento avanzado
                  "llama3.2:3b",         -- Rápido y ligero
                  "codellama:7b",        -- Alternativa para código
                },
              },
              num_ctx = {
                default = 32768, -- Contexto largo
              },
              temperature = {
                default = 0.3, -- Más determinista para código
              },
            },
          })
        end,
        
        -- HUGGINGFACE (CLOUD GRATIS)
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
              temperature = {
                default = 0.7,
              },
              max_tokens = {
                default = 4096,
              },
            },
          })
        end,
        
        -- PERPLEXITY (Búsqueda Web - 7 días gratis)
        perplexity = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "perplexity",
            url = "https://api.perplexity.ai/chat/completions",
            env = {
              api_key = "PERPLEXITY_API_KEY",
            },
            schema = {
              model = {
                default = "llama-3.1-sonar-small-128k-online",
                choices = {
                  "llama-3.1-sonar-small-128k-online",  -- Con búsqueda web
                  "llama-3.1-sonar-large-128k-online",
                },
              },
            },
          })
        end,
      },
      
      -- Configuración de visualización
      display = {
        diff = {
          provider = "mini_diff",
        },
        chat = {
          window = {
            layout = "vertical",
            width = 0.45,
            height = 0.9,
            relative = "editor",
            border = "rounded",
          },
          show_settings = true,
        },
      },
      
      -- Prompts del sistema
      opts = {
        log_level = "ERROR", -- Solo errores
        send_code = true,
        use_default_actions = true,
        system_prompt = [[Eres un asistente experto en programación.
SIEMPRE responde en español.
Especialízate en JavaScript, TypeScript y desarrollo web.
Sé claro, conciso y proporciona ejemplos prácticos.]],
      },
      
      -- Biblioteca de prompts personalizados
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
                return "Explica este código paso a paso:\n\n```" 
                  .. context.filetype .. "\n" 
                  .. context.selection .. "\n```"
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
              content = "Eres un experto en debugging. Identifica errores y sugiere correcciones.",
            },
            {
              role = "user",
              content = function(context)
                return "Revisa este código en busca de bugs:\n\n```"
                  .. context.filetype .. "\n"
                  .. context.selection .. "\n```"
              end,
            },
          },
        },
        
        ["Optimizar"] = {
          strategy = "inline",
          description = "Optimiza el código seleccionado",
          prompts = {
            {
              role = "system",
              content = "Optimiza el código manteniendo la funcionalidad. Solo devuelve el código optimizado.",
            },
            {
              role = "user",
              content = function(context)
                return "Optimiza:\n\n```" 
                  .. context.filetype .. "\n" 
                  .. context.selection .. "\n```"
              end,
            },
          },
        },
      },
    })
    
    -- ============================================
    -- KEYMAPS
    -- ============================================
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    
    -- Chat principal
    keymap("n", "<leader>cc", "<cmd>CodeCompanionChat<cr>", opts)
    keymap("v", "<leader>cc", "<cmd>CodeCompanionChat<cr>", opts)
    keymap("n", "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", opts)
    
    -- Acciones rápidas
    keymap({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", opts)
    
    -- Agregar código al chat
    keymap("v", "<leader>cA", "<cmd>CodeCompanionChat Add<cr>", opts)
    
    -- Cambiar modelo (útil para cambiar entre local/cloud)
    keymap("n", "<leader>cm", function()
      vim.ui.select(
        { "ollama", "huggingface", "perplexity" },
        { prompt = "Selecciona adaptador:" },
        function(choice)
          if choice then
            vim.notify("Cambiado a: " .. choice, vim.log.levels.INFO)
            -- Actualizar estrategia
            require("codecompanion").setup({
              strategies = {
                chat = { adapter = choice },
                inline = { adapter = choice },
              },
            })
          end
        end
      )
    end, opts)
    
    -- ============================================
    -- AUTOCOMMANDS
    -- ============================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "codecompanion",
      callback = function(ev)
        -- Mover ventana a la derecha
        vim.defer_fn(function()
          vim.cmd("wincmd L")
        end, 50)
        
        -- Keymaps del buffer
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
        vim.keymap.set("i", "<C-s>", "<cmd>CodeCompanionChat Submit<cr>", { buffer = ev.buf, silent = true })
      end,
    })
  end,
}
