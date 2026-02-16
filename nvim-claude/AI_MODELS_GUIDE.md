# 🤖 GUÍA DE MODELOS DE IA PARA PROGRAMACIÓN

## 📊 COMPARACIÓN RÁPIDA

| Modelo | Tamaño | RAM | Velocidad | Código | Español | Mejor Para |
|--------|--------|-----|-----------|--------|---------|------------|
| **qwen2.5-coder:7b** | 4.7GB | 8GB | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | **JS/TS/Web** |
| **deepseek-r1:7b** | 4.1GB | 8GB | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Razonamiento |
| **llama3.2:3b** | 2GB | 4GB | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | Rapidez |
| **codellama:7b** | 3.8GB | 8GB | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | Python/C++ |

---

## 🏆 RECOMENDACIÓN #1: Qwen2.5-Coder (MEJOR PARA TI)

### ✅ Por qué es el mejor para aprender JS/TS:

```bash
ollama pull qwen2.5-coder:7b
```

**Ventajas:**
- ✅ **Especializado en código** - Entrenado específicamente para programación
- ✅ **Excelente con JS/TS/React** - Conoce frameworks modernos
- ✅ **Contexto largo** (32k tokens) - Puede entender archivos completos
- ✅ **Responde en español** bien
- ✅ **Rápido** en hardware moderno
- ✅ **Mejor que GPT-3.5** en tareas de código

**Desventajas:**
- ⚠️ Necesita 8GB de RAM
- ⚠️ Puede ser lento en hardware antiguo

**Ejemplo de uso:**
```javascript
// Le preguntas: "¿Qué hace este código?"
const users = await fetch('/api/users')
  .then(res => res.json())
  .catch(err => console.error(err));

// Responde:
// "Este código hace una petición HTTP GET a '/api/users',
// convierte la respuesta a JSON, y maneja errores.
// MEJORA: Considera usar async/await para mejor legibilidad..."
```

---

## 🥈 OPCIÓN #2: DeepSeek-R1 (Razonamiento)

```bash
ollama pull deepseek-r1:7b
```

**Ventajas:**
- ✅ **Razonamiento paso a paso** - Te explica el "por qué"
- ✅ **Excelente para aprendizaje** - Enseña conceptos
- ✅ **Multilingüe** - Español perfecto
- ✅ **Gratis y open source**

**Desventajas:**
- ⚠️ **MÁS LENTO** - Piensa antes de responder (tarda 2-3x más)
- ⚠️ Muestra su "thinking process" (puedes limpiarlo)
- ⚠️ A veces da respuestas muy largas

**Mejor para:**
- Entender conceptos difíciles
- Debugging complejo
- Arquitectura de software

---

## 🥉 OPCIÓN #3: Llama 3.2 (Ligero y rápido)

```bash
ollama pull llama3.2:3b
```

**Ventajas:**
- ✅ **SUPER RÁPIDO** - Responde casi instantáneamente
- ✅ **Poco RAM** (4GB suficiente)
- ✅ **Buen balance** código/conversación
- ✅ **Gratis**

**Desventajas:**
- ⚠️ Menos especializado en código
- ⚠️ A veces se confunde con código complejo
- ⚠️ Contexto más corto (8k tokens)

**Mejor para:**
- Hardware limitado
- Respuestas rápidas
- Preguntas simples

---

## 🔧 CONFIGURACIÓN RECOMENDADA PARA TI

### Setup para aprendizaje de JS/TS:

```lua
-- En codecompanion.lua, usa:
schema = {
  model = {
    default = "qwen2.5-coder:7b",
    choices = {
      "qwen2.5-coder:7b",    -- Tu modelo principal
      "deepseek-r1:7b",      -- Para conceptos complejos
      "llama3.2:3b",         -- Cuando quieras rapidez
    },
  },
  num_ctx = { default = 16384 },  -- Contexto medio
  temperature = { default = 0.3 }, -- Más determinista
}
```

### Workflow sugerido:

1. **Día a día:** `qwen2.5-coder:7b`
   - Explicar código
   - Autocompletar
   - Debugging básico

2. **Aprendizaje profundo:** `deepseek-r1:7b`
   - "¿Por qué usar async/await?"
   - "¿Cuál es la diferencia entre map y forEach?"
   - "¿Cómo funciona el event loop?"

3. **Consultas rápidas:** `llama3.2:3b`
   - "¿Cómo se escribe un loop?"
   - "Sintaxis de arrow functions"
   - "¿Qué hace Array.filter()?"

---

## 🌐 OPCIONES CLOUD (Gratis)

### HuggingFace (Gratis, limitado)

```bash
# Configurar en tu shell:
export HUGGINGFACE_API_KEY="tu_key_aqui"
```

**Modelos disponibles:**
- `meta-llama/Llama-3.2-3B-Instruct` (gratis)
- `mistralai/Mistral-7B-Instruct-v0.3` (gratis)

**Pros:**
- ✅ No usa tu RAM/CPU
- ✅ Más rápido que local (si tienes buena internet)

**Contras:**
- ⚠️ Necesita internet
- ⚠️ Límite de requests (5000/mes gratis)
- ⚠️ No privado (tus consultas se envían)

### Perplexity Sonar (Búsqueda Web)

```bash
export PERPLEXITY_API_KEY="tu_key_aqui"
```

**Casos de uso:**
- "¿Cuál es la última versión de React?"
- "¿Qué novedades trae Node.js 22?"
- "Busca ejemplos de react-query"

**Límites:**
- 7 días gratis
- Después: $20/mes

---

## 🎯 MI RECOMENDACIÓN FINAL PARA TI

### Setup Óptimo:

```bash
# 1. Instala tu modelo principal (LOCAL)
ollama pull qwen2.5-coder:7b

# 2. Ten un backup rápido (LOCAL)
ollama pull llama3.2:3b

# 3. Registra HuggingFace (CLOUD BACKUP)
# Por si Ollama falla o necesitas más velocidad
```

### Configuración en CodeCompanion:

```lua
adapters = {
  ollama = function()  -- DEFAULT
    return require("codecompanion.adapters").extend("ollama", {
      schema = {
        model = {
          default = "qwen2.5-coder:7b",  -- ⭐ Tu modelo principal
        },
      },
    })
  end,
  
  huggingface = function()  -- BACKUP
    -- Solo si Ollama está lento o caído
  end,
}
```

### Cambiar de modelo fácilmente:

En Neovim:
```vim
<leader>cm  " Cambia entre ollama/huggingface
```

O en el chat de CodeCompanion:
```
/model qwen2.5-coder:7b
/model deepseek-r1:7b
/model llama3.2:3b
```

---

## 📚 RECURSOS PARA APRENDER MÁS

### Comparar modelos tú mismo:

```bash
# Prueba cada modelo:
ollama run qwen2.5-coder:7b
# Pregunta: "Explica qué es una closure en JavaScript"

ollama run deepseek-r1:7b
# Misma pregunta

ollama run llama3.2:3b
# Misma pregunta

# Compara:
# - Velocidad de respuesta
# - Calidad de explicación
# - Ejemplos de código
```

### Benchmarks oficiales:
- https://ollama.com/library
- https://huggingface.co/spaces/lmsys/chatbot-arena-leaderboard

---

## ⚡ OPTIMIZACIÓN DE RENDIMIENTO

### Si Ollama va lento:

```bash
# 1. Usa quantización más agresiva:
ollama pull qwen2.5-coder:7b-q4_K_M  # Más rápido, menos calidad
ollama pull qwen2.5-coder:7b-q8_0    # Balance
ollama pull qwen2.5-coder:7b         # Mejor calidad, más lento

# 2. Ajusta parámetros en CodeCompanion:
num_ctx = 8192      -- Reduce contexto si es lento
temperature = 0.1   -- Más determinista = más rápido
```

### Si tienes poca RAM:

```bash
# Usa el modelo 3B:
ollama pull llama3.2:3b

# O el modelo quantizado:
ollama pull qwen2.5-coder:3b
```

---

## ❓ FAQ

**P: ¿Puedo usar varios modelos a la vez?**
R: Sí, con `<leader>cm` cambias entre ellos.

**P: ¿Cuánto espacio en disco ocupan?**
R: 
- qwen2.5-coder:7b = 4.7GB
- deepseek-r1:7b = 4.1GB
- llama3.2:3b = 2GB

**P: ¿Funcionan offline?**
R: Sí, Ollama es 100% local.

**P: ¿Cuál es REALMENTE el mejor?**
R: Para aprender JS/TS = **qwen2.5-coder:7b**

**P: ¿Y si tengo solo 4GB de RAM?**
R: Usa **llama3.2:3b**

---

**¡Empieza con qwen2.5-coder:7b y experimenta!** 🚀
