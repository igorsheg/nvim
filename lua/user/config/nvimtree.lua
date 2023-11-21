require("nvim-tree").setup({
  -- disable_netrw = true,
  hijack_cursor = true,
  view = { width = {} },
  renderer = {
    full_name = true,
    highlight_git = true,
    indent_markers = {
      enable = true,
      inline_arrows = false,
    },
    icons = {
      show = { folder_arrow = false },
      symlink_arrow = " 󰁔 ",
      glyphs = {
        bookmark = "󰆤",
        modified = "",
        folder = {
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "M",
          staged = "A",
          unmerged = "UM",
          renamed = "R",
          untracked = "U",
          deleted = "D",
          ignored = "I",
        },
      },
    },
    special_files = {},
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },

  filters = {
    custom = { "^.git$" },
    exclude = { ".gitignore" },
  },
  modified = { enable = true },
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = { "help" },
  },
})

vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")
