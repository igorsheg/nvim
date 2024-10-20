local M = {}

function M.load_colorschemes()
  local colorschemes = {}
  local colorscheme_dir = vim.fn.stdpath "config" .. "/lua/user/plugins/colorschemes"

  for _, file in ipairs(vim.fn.readdir(colorscheme_dir, [[v:val =~ '\.lua$']])) do
    local scheme = require("user.plugins.colorschemes." .. file:gsub("%.lua$", ""))
    table.insert(colorschemes, scheme)
  end

  return colorschemes
end

return M
