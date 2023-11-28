local M = {
  "robitx/gp.nvim",
  event = "VeryLazy",
  lazy = false,
}

function M.config()
  require("gp").setup {}
end

return M
