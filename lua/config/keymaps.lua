-- Core keymaps only. Plugin keymaps live with their plugin specs.

local map = require("core.keymap").map

map("n", "<leader>w", "<cmd>write<cr>", "Save file")
map("n", "<leader>q", "<cmd>quit<cr>", "Quit window")
map("n", "<esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

local function delete_buffer()
  local current = vim.api.nvim_get_current_buf()
  local listed = vim.tbl_filter(function(buf)
    return vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  if #listed > 1 then
    vim.cmd.bprevious()
  else
    vim.cmd.enew()
  end

  vim.api.nvim_buf_delete(current, {})
end

map("n", "<leader>c", delete_buffer, "Close buffer")

-- Better window/tmux pane movement.
local function move(direction, fallback)
  return function()
    local ok, tmux = pcall(require, "tmux")
    if ok then
      tmux.move_to(direction)
    else
      vim.cmd.wincmd(fallback)
    end
  end
end

map("n", "<C-h>", move("left", "h"), "Go left")
map("n", "<C-j>", move("bottom", "j"), "Go down")
map("n", "<C-k>", move("top", "k"), "Go up")
map("n", "<C-l>", move("right", "l"), "Go right")

-- Keep visual selection when indenting.
map("x", "<", "<gv", "Indent left")
map("x", ">", ">gv", "Indent right")
