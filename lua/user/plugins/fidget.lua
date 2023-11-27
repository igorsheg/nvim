local M = {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  lazy = false,
}

function M.config()
  require("fidget").setup({})
end

return M
