local M = {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
}

function M.config()
  require("illuminate").configure {
    min_count_to_highlight = 2,
    filetypes_denylist = {
      "mason",
      "harpoon",
      "DressingInput",
      "NeogitCommitMessage",
      "qf",
      "dirvish",
      "minifiles",
      "fugitive",
      "alpha",
      "NvimTree",
      "lazy",
      "NeogitStatus",
      "Trouble",
      "netrw",
      "lir",
      "DiffviewFiles",
      "Outline",
      "Jaq",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "TelescopePrompt",
      "neo-tree",
    },
  }
end

return M
