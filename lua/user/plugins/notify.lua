return {
  "echasnovski/mini.notify",
  lazy = false,
  version = false,
  config = function()
    local win_config = function()
      local has_statusline = vim.o.laststatus > 0
      local bottom_space = vim.o.cmdheight + (has_statusline and 1 or 0)
      return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - bottom_space }
    end

    vim.notify = require("mini.notify").make_notify()
    require("mini.notify").setup {
      window = { config = win_config },
      -- done by fidget
      lsp_progress = {
        enable = false,
      },
    }
  end,
}
