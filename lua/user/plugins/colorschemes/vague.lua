return {
  "vague2k/vague.nvim",
  config = function()
    require("vague").setup({
      vim.cmd.colorscheme "vague"
    })
  end
}