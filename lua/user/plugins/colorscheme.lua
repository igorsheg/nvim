return {
  "webhooked/kanso.nvim",
  config = function()
    vim.cmd "colorscheme kanso"
    require("kanso").setup {
      background = {
        dark = "zen",
        light = "zen",
      },
    }
  end,
}
