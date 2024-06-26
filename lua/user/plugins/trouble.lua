-------------
-- Trouble --
-------------
return {
  "folke/trouble.nvim",
  lazy = false,
  keys = {
    { "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", mode = "n" },
    { "<leader>lw", "<cmd>Trouble diagnostics toggle<CR>", mode = "n" },
    {
      "<leader>lq",
      "<cmd>Trouble qflist toggle<CR>",
      desc = "Quickfix List (Trouble)",
    },
  },
  config = function()
    require("trouble").setup {
      auto_preview = false,
      use_diagnostic_signs = true,
      auto_jump = true,
      auto_close = true,
      focus = true,
      action_keys = {
        close = { "q", "<Esc>", "<C-q>", "<C-c>" },
        refresh = "R",
        jump = { "<Space>" },
        open_split = { "<c-s>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = { "<CR>" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = { "gl" },
        preview = "p",
        close_folds = { "h", "zM", "zm" },
        open_folds = { "l", "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
        cancel = nil,
      },
    }
  end,
}
