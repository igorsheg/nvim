return {
  {
    "dmtrKovalenko/fff.nvim",
    lazy = false, -- fff lazy-initializes itself
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      layout = {
        anchor = "bottom",
        width = 1,
        height = 0.4,
        prompt_position = "bottom",
        preview_position = "top",
        preview_size = 0.55,
      },
      keymaps = {
        close = { "<Esc>", "<C-c>" },
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<C-k>", "<C-p>" },
        move_down = { "<C-j>", "<C-n>" },
        preview_scroll_up = "<C-h>",
        preview_scroll_down = "<C-l>",
        toggle_debug = "<F2>",
        cycle_grep_modes = "<S-Tab>",
        cycle_previous_query = "<C-Up>",
        toggle_select = "<Tab>",
        send_to_quickfix = "<C-q>",
        focus_list = "<leader>l",
        focus_preview = "<leader>p",
      },
    },
    keys = {
      {
        "<leader>f",
        function()
          require("fff").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>F",
        function()
          require("fff").live_grep()
        end,
        desc = "Grep files",
      },
      {
        "<leader>*",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cword>") })
        end,
        desc = "Grep word",
      },
    },
  },
}
