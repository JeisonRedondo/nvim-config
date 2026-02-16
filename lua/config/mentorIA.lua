-- ~/.config/nvim/lua/mentor.lua
-- Sistema de Mentoría con IA - Versión Optimizada

local M = {}

-- Función mejorada para limpiar la salida del modelo
local function clean_output(text)
  -- 1. PRIMERO: Eliminar TODO el bloque de "Thinking" de manera robusta
  -- Buscar desde "Thinking" o "Okay" hasta "done thinking"
  text = text:gsub("Thinking%.%.%..-done thinking%.", "")
  text = text:gsub("Okay,.-done thinking%.", "")
  text = text:gsub("Thinking.-done thinking", "")
  
  -- 2. Eliminar secuencias ANSI completas
  text = text:gsub("\27%[[%d;]*m", "")         -- Colores
  text = text:gsub("\27%[[%d;]*[A-Za-z]", "")  -- Control
  text = text:gsub("\27%].-\007", "")          -- OSC
  text = text:gsub("%[%?[%d]+[hl]", "")        -- Cursor
  
  -- 3. Eliminar caracteres de control (pero MANTENER saltos de línea)
  text = text:gsub("[\1-\8\11\12\14-\31\127]", "")
  
  -- 4. Convertir secuencias de espacios/tabs raros
  text = text:gsub("[\194\160]+", " ")  -- Non-breaking space a espacio normal
  
  -- 5. Procesar línea por línea
  local lines = vim.split(text, "\n")
  local cleaned = {}
  local in_thinking = false
  
  for i, line in ipairs(lines) do
    -- Detectar bloques de thinking que quedaron
    local lower = line:lower()
    if lower:match("thinking") or lower:match("^okay,") then
      in_thinking = true
    end
    if lower:match("done thinking") then
      in_thinking = false
      goto continue
    end
    if in_thinking then
      goto continue
    end
    
    -- Limpiar la línea
    line = line:gsub("^%s+", "")  -- Espacios al inicio
    line = line:gsub("%s+$", "")  -- Espacios al final
    
    -- Saltar líneas que son solo basura
    if line:match("^[%[%]%?%d]+$") then
      goto continue
    end
    
    -- Saltar líneas con solo símbolos raros
    if line:match("^[─│┌┐└┘├┤┬┴┼█▓▒░►◄▲▼]+$") then
      goto continue
    end
    
    -- SOLO agregar líneas que tengan contenido alfabético
    if line ~= "" and line:match("[a-zA-ZáéíóúñÁÉÍÓÚÑ]") then
      table.insert(cleaned, line)
    end
    
    ::continue::
  end
  
  -- 6. Post-procesamiento: unir líneas rotas
  local final = {}
  local current_line = ""
  
  for _, line in ipairs(cleaned) do
    -- Si la línea anterior termina sin puntuación y esta no empieza con mayúscula/símbolo
    -- probablemente es continuación
    if current_line ~= "" and 
       not current_line:match("[%.!?:]$") and 
       not line:match("^[A-ZÁÉÍÓÚÑ#%*%-]") then
      current_line = current_line .. " " .. line
    else
      if current_line ~= "" then
        table.insert(final, current_line)
      end
      current_line = line
    end
  end
  
  -- Agregar la última línea
  if current_line ~= "" then
    table.insert(final, current_line)
  end
  
  return final
end

-- Función para abrir ventana flotante mejorada
local function open_float(lines, title)
  if #lines == 0 then
    vim.notify("No hay contenido para mostrar", vim.log.levels.WARN)
    return
  end
  
  -- Crear buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- Configurar buffer
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'markdown'
  vim.bo[buf].modifiable = false
  vim.bo[buf].swapfile = false
  
  -- Calcular dimensiones (80% de la pantalla)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- Opciones de ventana
  local win_opts = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = title or " 🤖 Mentor IA ",
    title_pos = "center",
  }
  
  -- Abrir ventana
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  
  -- Configurar ventana
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].cursorline = true
  
  -- Keymaps para cerrar la ventana
  local close_keys = { 'q', '<ESC>', '<C-c>' }
  for _, key in ipairs(close_keys) do
    vim.keymap.set('n', key, '<cmd>close<CR>', { 
      buffer = buf, 
      silent = true,
      nowait = true 
    })
  end
  
  -- Keymap para copiar todo al portapapeles
  vim.keymap.set('n', 'yy', function()
    local all_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.fn.setreg('+', table.concat(all_lines, '\n'))
    vim.notify("Contenido copiado al portapapeles", vim.log.levels.INFO)
  end, { buffer = buf, silent = true })
end

-- Función principal para ejecutar el mentor
local function run_mentor(extra_prompt, title)
  -- Archivos de contexto del mentor
  local files = {
    "mentor/rules.md",
    "mentor/role.md",
    "mentor/project.md",
    "mentor/tasks.md",
    "mentor/progress.md",
  }
  
  -- Leer contenido de archivos
  local content = {}
  local missing_files = {}
  
  for _, file in ipairs(files) do
    local path = vim.fn.expand(file)
    
    if vim.fn.filereadable(path) == 1 then
      local lines = vim.fn.readfile(path)
      table.insert(content, "=== " .. file .. " ===\n" .. table.concat(lines, "\n"))
    else
      table.insert(missing_files, file)
    end
  end
  
  -- Verificar archivos faltantes
  if #missing_files > 0 then
    local msg = "Archivos no encontrados:\n" .. table.concat(missing_files, "\n")
    vim.notify(msg, vim.log.levels.WARN)
  end
  
  if #content == 0 then
    vim.notify("No se encontró ningún archivo de mentor", vim.log.levels.ERROR)
    return
  end
  
  -- Agregar prompt extra si existe
  if extra_prompt then
    table.insert(content, "\n=== INSTRUCCIÓN ACTUAL ===\n" .. extra_prompt)
  end
  
  -- Construir prompt completo
  local prompt = table.concat(content, "\n\n")
  
  -- Mostrar indicador de carga
  vim.notify("🤔 Consultando al mentor...", vim.log.levels.INFO)
  
  -- Guardar el prompt en un archivo temporal
  local temp_prompt = vim.fn.tempname()
  local temp_output = vim.fn.tempname()
  
  -- Escribir prompt
  local f = io.open(temp_prompt, "w")
  f:write(prompt)
  f:close()
  
  -- Ejecutar ollama redirigiendo la salida a archivo
  local cmd = string.format(
    'cat %s | ollama run deepseek-r1:7b > %s 2>&1',
    vim.fn.shellescape(temp_prompt),
    vim.fn.shellescape(temp_output)
  )
  
  vim.fn.system(cmd)
  
  -- Leer el resultado
  local raw = ""
  local output_file = io.open(temp_output, "r")
  if output_file then
    raw = output_file:read("*all")
    output_file:close()
  end
  
  -- Limpiar archivos temporales
  vim.fn.delete(temp_prompt)
  vim.fn.delete(temp_output)
  
  -- Verificar errores de ejecución
  if vim.v.shell_error ~= 0 then
    vim.notify("❌ Error ejecutando ollama:\n" .. raw, vim.log.levels.ERROR)
    return
  end
  
  -- Limpiar salida
  local cleaned = clean_output(raw)
  
  -- Verificar que haya contenido
  if #cleaned == 0 then
    vim.notify("⚠️  No se obtuvo respuesta válida del modelo", vim.log.levels.WARN)
    -- Mostrar salida raw para debug
    vim.notify("Salida cruda: " .. raw:sub(1, 200), vim.log.levels.DEBUG)
    return
  end
  
  -- Mostrar resultado
  open_float(cleaned, title)
end

-- Setup: Crear comandos y keymaps
function M.setup(opts)
  opts = opts or {}
  
  -- Configuración opcional
  local config = {
    model = opts.model or "deepseek-r1:7b",
    leader = opts.leader or "<leader>m",
  }
  
  -- Comando: Siguiente tarea
  vim.api.nvim_create_user_command("MentorNext", function()
    run_mentor([[
TAREA:
Identifica la siguiente tarea activa según el progreso actual.
Explícala de forma conceptual, no con código.
Define criterios claros de éxito.
Haz preguntas que guíen al aprendiz a pensar.
]], " 📋 Siguiente Tarea ")
  end, { desc = "Mentor: Siguiente tarea" })
  
  -- Comando: Pista conceptual
  vim.api.nvim_create_user_command("MentorHint", function()
    run_mentor([[
PISTA:
Da una pista conceptual sobre la tarea actual.
No sugieras implementación directa.
No menciones estructuras de código específicas.
Haz que el aprendiz piense en el "por qué" antes del "cómo".
Usa analogías del mundo real si ayuda.
]], " 💡 Pista Conceptual ")
  end, { desc = "Mentor: Pista conceptual" })
  
  -- Comando: Revisión de enfoque
  vim.api.nvim_create_user_command("MentorReview", function()
    run_mentor([[
REVISIÓN:
Evalúa el enfoque del aprendiz desde un punto de vista arquitectónico.
Analiza las decisiones conceptuales tomadas.
Señala posibles riesgos o anti-patrones comunes.
NO propongas soluciones directas, haz preguntas que guíen.
Simula una code review profesional real.
]], " 🔍 Revisión Técnica ")
  end, { desc = "Mentor: Revisión de código" })
  
  -- Comando: Explicar concepto
  vim.api.nvim_create_user_command("MentorExplain", function(cmd_opts)
    local concept = cmd_opts.args
    
    if concept == "" then
      vim.ui.input({ prompt = "¿Qué concepto quieres que explique? " }, function(input)
        if input and input ~= "" then
          run_mentor(
            'EXPLICACIÓN:\nExplica el concepto: "' .. input .. '"\n' ..
            'En el contexto del proyecto actual.\n' ..
            'Usa analogías y ejemplos claros.\n' ..
            'Relaciona con las tareas que el aprendiz está realizando.',
            " 📚 Explicación: " .. input .. " "
          )
        end
      end)
    else
      run_mentor(
        'EXPLICACIÓN:\nExplica el concepto: "' .. concept .. '"\n' ..
        'En el contexto del proyecto actual.\n' ..
        'Usa analogías y ejemplos claros.\n' ..
        'Relaciona con las tareas que el aprendiz está realizando.',
        " 📚 Explicación: " .. concept .. " "
      )
    end
  end, { 
    nargs = "?",
    desc = "Mentor: Explicar concepto"
  })
  
  -- Comando: Estado del proyecto
  vim.api.nvim_create_user_command("MentorStatus", function()
    run_mentor([[
STATUS:
Resume el estado actual del proyecto.
Lista tareas completadas y pendientes.
Identifica el siguiente hito importante.
Evalúa el progreso general del aprendiz.
Da feedback constructivo sobre el avance.
]], " 📊 Estado del Proyecto ")
  end, { desc = "Mentor: Estado del proyecto" })
  
  -- Comando: Pregunta libre
  vim.api.nvim_create_user_command("MentorAsk", function(cmd_opts)
    local question = cmd_opts.args
    
    if question == "" then
      vim.ui.input({ prompt = "¿Qué quieres preguntar? " }, function(input)
        if input and input ~= "" then
          run_mentor(
            'PREGUNTA DEL APRENDIZ:\n' .. input .. '\n\n' ..
            'Responde de forma educativa, sin dar código directo.\n' ..
            'Guía con preguntas si es apropiado.',
            " ❓ Pregunta "
          )
        end
      end)
    else
      run_mentor(
        'PREGUNTA DEL APRENDIZ:\n' .. question .. '\n\n' ..
        'Responde de forma educativa, sin dar código directo.\n' ..
        'Guía con preguntas si es apropiado.',
        " ❓ Pregunta "
      )
    end
  end, {
    nargs = "?",
    desc = "Mentor: Hacer una pregunta"
  })
  
  -- Comando: Ver salida cruda (para debug)
  vim.api.nvim_create_user_command("MentorDebug", function()
    local files = {
      "mentor/rules.md",
      "mentor/role.md", 
      "mentor/project.md",
      "mentor/tasks.md",
      "mentor/progress.md",
    }
    
    local content = {}
    for _, file in ipairs(files) do
      if vim.fn.filereadable(file) == 1 then
        local lines = vim.fn.readfile(file)
        table.insert(content, table.concat(lines, "\n"))
      end
    end
    
    local prompt = table.concat(content, "\n\n") .. "\n\nTAREA: Resume el estado actual."
    
    vim.notify("🤔 Ejecutando en modo debug...", vim.log.levels.INFO)
    
    local cmd = string.format(
      'LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ollama run deepseek-r1:7b %s',
      vim.fn.shellescape(prompt)
    )
    
    local raw = vim.fn.system(cmd)
    
    -- Mostrar salida sin limpiar
    local lines = vim.split(raw, "\n")
    open_float(lines, " 🐛 DEBUG - Salida Cruda ")
  end, { desc = "Mentor: Ver salida cruda (debug)" })
  
  -- Keymaps opcionales
  if opts.keymaps ~= false then
    local prefix = config.leader
    
    vim.keymap.set('n', prefix .. 'n', '<cmd>MentorNext<CR>', { desc = "Mentor: Siguiente tarea" })
    vim.keymap.set('n', prefix .. 'h', '<cmd>MentorHint<CR>', { desc = "Mentor: Pista" })
    vim.keymap.set('n', prefix .. 'r', '<cmd>MentorReview<CR>', { desc = "Mentor: Revisión" })
    vim.keymap.set('n', prefix .. 's', '<cmd>MentorStatus<CR>', { desc = "Mentor: Estado" })
    vim.keymap.set('n', prefix .. 'e', '<cmd>MentorExplain<CR>', { desc = "Mentor: Explicar" })
    vim.keymap.set('n', prefix .. 'a', '<cmd>MentorAsk<CR>', { desc = "Mentor: Preguntar" })
  end
  
  -- Mensaje de confirmación
  vim.notify("✅ Sistema de Mentoría IA cargado", vim.log.levels.INFO)
end

return M
