return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  config = function()
    local toggleterm = require "toggleterm"

    toggleterm.setup {
      auto_scroll = true,
      start_in_insert = true,
      close_on_exit = true,
      direction = "vertical",
      persist_mode = true,
      shading_factor = 2,
      float_opts = {
        border = "single",
        winblend = 1,
      },
      size = function()
        return vim.o.columns * 0.5
      end,
    }
  end,
}
