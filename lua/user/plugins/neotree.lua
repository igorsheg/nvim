local opts = {
  sources = {
    "filesystem",
  },
  add_blank_line_at_top = false,
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  hide_root_node = true,
  retain_hidden_root_indent = true,
  popup_border_style = "rounded",
  source_selector = {
    winbar = true,
    statusline = false,
  },
  window = {
    position = "left",
    mapping_options = {
      noremap = true,
      nowait = true,
    },
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        "node_modules",
      },
    },
    follow_current_file = {
      enabled = true,
    },
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      with_expanders = nil,
      expander_collapsed = "",
      expander_expanded = "",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      default = "",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
    },
    git_status = {
      symbols = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = "◌",
      },
    },
  },
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  opts = opts,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  cmd = "Neotree",
  keys = {
    {
      "<leader>e",
      ":Neotree toggle<CR>",
      desc = "Toggle Neotree",
    },
    {
      "<leader>E",
      ":Neotree toggle position=current<CR>",
      desc = "Toggle Neotree",
    },
  },
}
