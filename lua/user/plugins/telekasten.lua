local M = {
  "renerocksai/telekasten.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
}

function M.config()
  require("telekasten").setup {
    home = vim.fn.expand "~/workspace/notes",
  }
end

return M
