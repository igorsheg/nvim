local M = {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
}

function M.config()
  require("typescript-tools").setup({
    settings = {
      separate_diagnostic_server = false,
      tsserver_max_memory = 8 * 1024,
    },
  })
end

return M
