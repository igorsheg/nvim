return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  config = function()
    local toggleterm  = require "toggleterm"
    local Terminal    = require('toggleterm.terminal').Terminal
    local scratchTerm = Terminal:new { display_name = "scratchTerm", hidden = true, direction = "vertical" }

    local function toggleScratchTerm()
      scratchTerm:toggle(80)
    end

    vim.keymap.set("n", "<C-\\>", toggleScratchTerm)
    vim.keymap.set("t", "<C-\\>", toggleScratchTerm)
    vim.keymap.set("v", "<C-\\>", toggleScratchTerm)

    vim.keymap.set("n", "<C-l>", scratchTerm.clear)
    vim.keymap.set("t", "<C-l>", scratchTerm.clear)

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
