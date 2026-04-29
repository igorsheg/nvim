return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      background = { dark = "zen", light = "zen" },
      foreground = "default",
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      functionStyle = { bold = true },
    },
    config = function(_, opts)
      require("kanso").setup(opts)
      vim.cmd.colorscheme("kanso-zen")
    end,
  },
}
