local M = {
  "j-hui/fidget.nvim",
  lazy = false,
}

function M.config()
  local fidget = require "fidget"
  fidget.setup {
    progress = {
      display = {
        done_icon = "",
        done_ttl = 2,
      },
    },
    notification = {
      window = {
        x_padding = 3,
        y_padding = 1,
      },
      override_vim_notify = true,
    },
  }
end

return M
