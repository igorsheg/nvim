return {
  "Yazeed1s/oh-lucy.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("oh-lucy").setup {
      -- optional configuration here
    }
    vim.cmd "colorscheme oh-lucy"
  end,
}
