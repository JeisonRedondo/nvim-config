-- ============================================
-- NVIM-DAP - Debugging para JS/TS
-- ============================================
-- CORREGIDO: Estructura de configuraciones
-- Soporta: Node.js, Chrome, Edge

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mxsdev/nvim-dap-vscode-js",
  },
  
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>dt", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
  },
  
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    -- ============================================
    -- CONFIGURACIÓN DE DAP UI
    -- ============================================
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
    })
    
    -- ============================================
    -- CONFIGURACIÓN DE VSCODE-JS-DEBUG
    -- ============================================
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
      debugger_cmd = { "js-debug-adapter" },
      adapters = { 
        "pwa-node", 
        "pwa-chrome", 
        "pwa-msedge", 
        "node-terminal", 
        "pwa-extensionHost" 
      },
    })
    
    -- ============================================
    -- CONFIGURACIONES PARA JS/TS (CORREGIDO ✅)
    -- ============================================
    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      dap.configurations[language] = {
        -- Configuración 1: Ejecutar archivo actual
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        
        -- Configuración 2: Adjuntar a proceso
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        
        -- Configuración 3: Debug con Chrome
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
        
        -- Configuración 4: Debug tests con Jest
        {
          type = "pwa-node",
          request = "launch",
          name = "Jest Tests",
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--runInBand",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
      }
    end
    
    -- ============================================
    -- LISTENERS: Auto abrir/cerrar UI
    -- ============================================
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    
    -- ============================================
    -- SIGNOS EN EL GUTTER
    -- ============================================
    vim.fn.sign_define("DapBreakpoint", { 
      text = "🔴", 
      texthl = "DapBreakpoint", 
      linehl = "", 
      numhl = "" 
    })
    vim.fn.sign_define("DapStopped", { 
      text = "▶️", 
      texthl = "DapStopped", 
      linehl = "debugPC", 
      numhl = "" 
    })
  end,
}
