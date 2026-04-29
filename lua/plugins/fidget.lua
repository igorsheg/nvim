local icons = require("core.icons")

return {
  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
      progress = {
        display = {
          done_icon = icons.status.done,
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
    },
  },
}
