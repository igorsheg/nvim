local M = {
  "stevearc/dressing.nvim",
  lazy = false,
}

function M.config()
  local setup_options = {
    input = {
      enabled = true,
      default_prompt = "Input:",
      prompt_align = "center",
      title_pos = "left",
      insert_only = true,
      start_in_insert = true,
      border = "rounded",
      relative = "cursor",
      prefer_width = 40,
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },
      win_options = {
        winblend = 0,
        wrap = false,
        list = true,
        listchars = "precedes:…,extends:…",
        sidescrolloff = 0,
      },
    },
    select = {
      enabled = true,
      backend = { "telescope", "nui", "builtin" },
      trim_prompt = true,
      nui = {
        position = { row = 2, col = 0 },
        relative = "cursor",
        border = { style = "rounded", text = { top_align = "right" } },
        buf_options = { swapfile = false, filetype = "DressingSelect" },
        max_width = 80,
        max_height = 40,
      },
      telescope = require("telescope.themes").get_ivy {
        layout_config = { height = 0.2 },
      },
      builtin = {
        override = "NW",
        border = "rounded",
        relative = "cursor",
        win_options = {
          winblend = 10,
          cursorline = true,
          cursorlineopt = "both",
        },
        max_width = { 140, 0.8 },
        min_width = { 40, 0.2 },
        max_height = 0.9,
        min_height = { 10, 0.2 },
        mappings = {
          ["<Esc>"] = "Close",
          ["q"] = "Close",
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
        },
      },
    },
  }

  require("dressing").setup(setup_options)
end

return M
