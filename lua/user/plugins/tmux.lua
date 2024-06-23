return {
  "aserowy/tmux.nvim",
  event = "VeryLazy",
  config = function()
    local tmux = require "tmux"
    local map = require("user.utils").map
    tmux.setup {
      copy_sync = {
        enable = false,
      },
      navigation = {
        cycle_navigation = false,
        enable_default_keybindings = false,
        persist_zoom = true,
      },
      resize = {
        enable_default_keybindings = false,
      },
    }
    local zoom = function()
      if vim.fn.winnr "$" > 1 then
        if vim.g.zoomed ~= nil then
          vim.cmd(vim.g.zoom_winrestcmd)
          vim.g.zoomed = 0
        else
          vim.g.zoom_winrestcmd = vim.fn.winrestcmd()
          vim.cmd "resize"
          vim.cmd "vertical resize"
          vim.g.zoomed = 1
        end
      else
        vim.cmd "!tmux resize-pane -Z"
      end
    end
    map("n", "<c-h>", tmux.move_left, "tmux focus left")
    map("n", "<c-j>", tmux.move_bottom, "tmux focus bottom")
    map("n", "<c-k>", tmux.move_top, "tmux focus top")
    map("n", "<c-l>", tmux.move_right, "tmux focus right")
    map("n", "<c-left>", tmux.resize_left, "tmux resize left")
    map("n", "<c-down>", tmux.resize_bottom, "tmux resize bottom")
    map("n", "<c-up>", tmux.resize_top, "tmux resize top")
    map("n", "<c-right>", tmux.resize_right, "tmux resize right")
    map("t", "<c-h>", tmux.move_left, "tmux focus left")
    map("t", "<c-j>", tmux.move_bottom, "tmux focus bottom")
    map("t", "<c-k>", tmux.move_top, "tmux focus top")
    map("t", "<c-l>", tmux.move_right, "tmux focus right")
    map("t", "<c-left>", tmux.resize_left, "tmux resize left")
    map("t", "<c-down>", tmux.resize_bottom, "tmux resize bottom")
    map("t", "<c-up>", tmux.resize_top, "tmux resize top")
    map("t", "<c-right>", tmux.resize_right, "tmux resize right")
    map("n", "<leader>z", zoom, "tmux zoom")
  end,
}
