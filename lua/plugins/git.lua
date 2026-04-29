local icons = require("core.icons")

return {
  {
    "igorsheg/gitlink.nvim",
    dir = vim.fn.stdpath("config"),
    keys = {
      {
        "<leader>go",
        function()
          require("core.gitlink").open()
        end,
        mode = { "n", "x" },
        desc = "Open in GitHub",
      },
      {
        "<leader>gl",
        function()
          require("core.gitlink").copy_permalink()
        end,
        mode = { "n", "x" },
        desc = "Copy GitHub permalink",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = icons.git_signs.add },
        change = { text = icons.git_signs.change },
        delete = { text = icons.git_signs.delete },
        topdelete = { text = icons.git_signs.topdelete },
        changedelete = { text = icons.git_signs.changedelete },
      },
      on_attach = function(bufnr)
        local map = require("core.keymap").map
        local gitsigns = require("gitsigns")

        local function git_map(lhs, rhs, desc)
          map("n", lhs, rhs, desc, { buffer = bufnr })
        end

        git_map("]g", function()
          gitsigns.nav_hunk("next")
        end, "Next git hunk")

        git_map("[g", function()
          gitsigns.nav_hunk("prev")
        end, "Previous git hunk")

        git_map("<leader>gp", gitsigns.preview_hunk, "Preview git hunk")
        git_map("<leader>gb", gitsigns.blame_line, "Blame line")
      end,
    },
  },
}
