local M = {
  "stevearc/oil.nvim",
  event = "VeryLazy",
}
function M.config()
  require("oil").setup {
    default_file_explorer = true,
    columns = {
      "icon",
    },
    delete_to_trash = true,
    trash_command = "trash -F",
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 0,
      border = vim.g.border_style,
      max_height = 20,
      override = function(conf)
        conf.row = vim.o.lines
        return conf
      end,
    },
    preview = {
      border = vim.g.border_style,
    },
    progress = {
      border = vim.g.border_style,
    },
  }

  local function open_float()
    return require("oil").open_float()
  end

  -- open oil showing the parent directory of the file in the current buffer
  vim.keymap.set("n", "<leader>-", "<cmd>oil<cr>")
  vim.keymap.set("n", "-", open_float)
end

return M
