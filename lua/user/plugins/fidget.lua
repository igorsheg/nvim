local M = {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  lazy = false,
}

function M.config()
  require("fidget").setup {
    integration = {
      ["nvim-tree"] = {
        enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
      },
    },
  }
end

return M
