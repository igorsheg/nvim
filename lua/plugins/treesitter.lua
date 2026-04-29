local languages = {
  "bash",
  "go",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "rust",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "zig",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        pattern = languages,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
