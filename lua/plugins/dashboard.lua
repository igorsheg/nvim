return {
  {
    "user/dashboard.nvim",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 900,
    config = function()
      require("core.dashboard").setup()
    end,
  },
}
