local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
}

function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "lua",
      "markdown",
      "markdown_inline",
      "bash",
      "vimdoc",
      "typescript",
      "tsx",
      "embedded_template",
      "scss",
    },
    highlight = { enable = true },
    indent = { enable = true },
    -- autotag = {
    --   enable = true,
    -- },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
      },
    },
  }
end

return M
