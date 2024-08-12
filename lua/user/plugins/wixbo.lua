return {
  {
    dir = "~/workspace/dev/work/neo-bowix",
    dev = true,
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("wixbo").setup({})
    end,
  }
}
