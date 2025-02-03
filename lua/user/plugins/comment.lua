return {
  "echasnovski/mini.comment",
  lazy = false,
  version = false,
  config = function()
    local comment = require "mini.comment"
    comment.setup {
      mappings = {
        comment = "<leader>/",
        comment_line = "<leader>/",
        comment_visual = "<leader>/",
      },
    }
  end,
}
