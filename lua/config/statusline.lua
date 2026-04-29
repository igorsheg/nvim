-- Plain native statusline. No plugin, no sections, no mode noise.

local M = {}

function M.statusline()
  if vim.bo.filetype == "neo-tree" then
    return " "
  end

  return " %f%m%r%=%y %l:%c %p%% "
end

vim.o.statusline = "%!v:lua.require'config.statusline'.statusline()"

return M
