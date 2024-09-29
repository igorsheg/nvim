return {
  "dgox16/oldworld.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("oldworld").setup {
      -- optional configuration here
    }
    vim.cmd "colorscheme oldworld"
  end,
}
