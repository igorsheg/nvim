local icons = require("core.icons")

return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      {
        "<leader>gd",
        "<cmd>CodeDiff<cr>",
        desc = "Git diff",
      },
    },
    opts = {
      explorer = {
        icons = {
          folder_closed = icons.files.folder_closed,
          folder_open = icons.files.folder_open,
        },
      },
    },
  },
}
