return {
  "echasnovski/mini.files",
  version = "*",
  event = "VeryLazy",
  opts = {
    delay = {
      highlight = 0,
    },
  },
  config = function()
    require("mini.files").setup {}

    vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>")
  end,
}
