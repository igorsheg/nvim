return {
  "aserowy/tmux.nvim",
  event = "VeryLazy",
  config = function()
    local tmux = require "tmux"
    tmux.setup {
      copy_sync = {
        enable = false,
      },
    }
  end,
}
