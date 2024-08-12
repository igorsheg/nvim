return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  -- keys = {
  --   { "<leader>ghp", "<cmd>Octo pr list<CR>", desc = "Octo list prs" },
  -- },
  config = function()
    require("octo").setup()
  end,
}
