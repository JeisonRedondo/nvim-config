
local M = {}

M.save_file = function ()
  vim.cmd("write")
  vim.notify("Archivo guardado",vim.log.levels.INFO, {title = "Guardar"})
end

M.resize_window = function (direction,amount)
  local cmd_map = {
    up = "resize -" .. amount,
    down = "resize +" .. amount,
    left = "vertical resize -" .. amount,
    right = "vertical resize +" .. amount,
  }

  local cmd = cmd_map[direction]
  if cmd then
    vim.cmd(cmd)
  else
    vim.notify("Dirección inválida: usa up/down/left/right", vim.log.levels.WARN)
  end
end

return M
