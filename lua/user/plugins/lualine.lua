local M = {
  "nvim-lualine/lualine.nvim",
}

function M.config()
  local icons = require "user.utils.icons"
  local diff = {
    "diff",
    colored = true,
    symbols = {
      added = icons.git.LineAdded,
      modified = icons.git.LineModified,
      removed = icons.git.LineRemoved,
    },
  }

  require("lualine").setup {
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      theme = {
        normal = {
          a = { bg = "None", gui = "bold" },
          b = { bg = "None", gui = "bold" },
          c = { bg = "None", gui = "bold" },
          x = { bg = "None", gui = "bold" },
          y = { bg = "None", gui = "bold" },
          z = { bg = "None", gui = "bold" },
        },
        insert = {
          a = { bg = "None", gui = "bold" },
          b = { bg = "None", gui = "bold" },
          c = { bg = "None", gui = "bold" },
          x = { bg = "None", gui = "bold" },
          y = { bg = "None", gui = "bold" },
          z = { bg = "None", gui = "bold" },
        },
        visual = {
          a = { bg = "None", gui = "bold" },
          b = { bg = "None", gui = "bold" },
          c = { bg = "None", gui = "bold" },
          x = { bg = "None", gui = "bold" },
          y = { bg = "None", gui = "bold" },
          z = { bg = "None", gui = "bold" },
        },
        replace = {
          a = { bg = "None", gui = "bold" },
          b = { bg = "None", gui = "bold" },
          c = { bg = "None", gui = "bold" },
          x = { bg = "None", gui = "bold" },
          y = { bg = "None", gui = "bold" },
          z = { bg = "None", gui = "bold" },
        },
        command = {
          a = { bg = "None", gui = "bold" },
          b = { bg = "None", gui = "bold" },
          c = { bg = "None", gui = "bold" },
          x = { bg = "None", gui = "bold" },
          y = { bg = "None", gui = "bold" },
          z = { bg = "None", gui = "bold" },
        },
        inactive = {
          a = { bg = "None", gui = "bold" },
          b = { bg = "None", gui = "bold" },
          c = { bg = "None", gui = "bold" },
          x = { bg = "None", gui = "bold" },
          y = { bg = "None", gui = "bold" },
          z = { bg = "None", gui = "bold" },
        },
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { diff, "navic", },
      lualine_x = { "diagnostics" },
      lualine_y = { "filetype" },
      lualine_z = { "progress" },
    },
    extensions = { "quickfix", "lazy", "man", "fugitive", "neo-tree", "toggleterm" },
  }
end

return M
