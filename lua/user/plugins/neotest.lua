return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "haydenmeade/neotest-jest",
    "nvim-neotest/neotest-plenary",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-jest" {
          jestCommand = "jest --watch ",
        },
        require "neotest-plenary",
      },
    }
  end,
}
