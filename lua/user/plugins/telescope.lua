local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    { "BurntSushi/ripgrep" },
    { "natecraddock/telescope-zf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
    -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
}

function M.config()
  local telescope = require "telescope"
  local builtin = require "telescope.builtin"
  local actions = require "telescope.actions"
  local themes = require "telescope.themes"
  local sorters = require "telescope.sorters"
  local map = require("user.utils").map

  local function grep_string()
    local value = vim.fn.expand "<cword>"
    require("telescope.builtin").grep_string { search = value }
  end

  telescope.setup {
    defaults = themes.get_ivy {
      layout_config = {
        height = 0.3,
      },
      file_sorter = sorters.get_fuzzy_file,
      generic_sorter = sorters.get_generic_fuzzy_sorter,
      prompt_prefix = "   ",
      prompt_title = false,
      selection_caret = " ",
      multi_icon = "",
      path_display = { "truncate" },
      entry_prefix = " ",
      set_env = { ["COLORTERM"] = "truecolor" },
      results_title = false,
      selection_strategy = "reset",
      use_less = true,
      dynamic_preview_title = true,
      preview = false,
      winblend = 0,
      vimgrep_arguments = {
        "rg",
        "-HnS.", -- hidden, line-number, smart-case, hidden
        "--color=never",
        "--no-heading",
        "--column",
        "--trim",
        -- "--no-ignore",
        "-g=!.git",
        "-g=!node_modules",
        "-g=!.venv",
      },
      file_ignore_patterns = {
        "%.git/",
        "node_modules/",
        "%.npm/",
        "__pycache__/",
        "%[Cc]ache/",
        "%.dropbox/",
        "%.dropbox_trashed/",
        "%.local/share/Trash/",
        "%.py[c]",
        "%.sw.?",
        "~$",
        "%.tags",
        "%.gemtags",
        "%.tmp",
        "%.plist$",
        "%.pdf$",
        "%.jpg$",
        "%.JPG$",
        "%.jpeg$",
        "%.png$",
        "%.class$",
        "%.pdb$",
        "%.dll$",
      },
      mappings = {
        i = {
          ["<C-x>"] = false,
          ["<C-u>"] = false,
          ["<C-d>"] = false,
          ["<Esc>"] = actions.close,
          ["<C-c>"] = actions.close,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-/>"] = "which_key",
        },
        n = {
          ["<Esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,
          ["?"] = actions.which_key,
        },
      },
    },
    pickers = {
      buffers = { sort_mru = true },
      live_grep = { preview = true },
      grep_string = { preview = true },
      man_pages = { sections = { "2", "3" } },
      lsp_document_symbols = { path_display = { "hidden" } },
      lsp_workspace_symbols = { path_display = { "shorten" } },
      -- find_files = {
      --   find_command = { "fd", "-HIL", "-t=f", "--strip-cwd-prefix" },
      --   hidden = true,
      -- },
      colorscheme = {
        enable_preview = true,
      },
    },
    extensions = {
      ["zf-native"] = {
        file = {
          enable = true,
          highlight_results = true,
          match_filename = true,
        },
        generic = {
          enable = true,
          highlight_results = true,
          match_filename = false,
        },
      },
      -- fzf = {
      --   fuzzy = true,
      --   override_generic_sorter = true,
      --   override_file_sorter = true,
      --   case_mode = "smart_case",
      -- },
      ["ui-select"] = {
        themes.get_ivy {
          layout_config = {
            height = 0.2,
          },
        },
      },
    },
  }

  map("n", "<leader>f", function()
    return builtin.find_files { hidden = true, prompt_title = false }
  end, "Find files")
  map({ "n", "x" }, "<leader>F", grep_string, "Grep string")
  map("n", "<leader>F", "<cmd>Telescope live_grep_args<CR>", "Live grep")
  map("n", "<leader>b", builtin.buffers, "Open buffers")
  map("x", "<leader>F", grep_string)
  map("n", "<leader>,", builtin.resume, "Resume latest telescope session")

  -- telescope.load_extension "fzf"
  telescope.load_extension "zf-native"
  telescope.load_extension "ui-select"
  telescope.load_extension "live_grep_args"
end

return M
