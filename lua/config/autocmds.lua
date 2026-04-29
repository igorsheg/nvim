-- Small, useful autocmds.

local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Highlight text after yanking.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ timeout = 80 })
  end,
})

-- Return to last edit position when reopening files.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Create parent directories before writing a file.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end

    local dir = vim.fn.fnamemodify(event.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Keep splits balanced after terminal resize.
vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Close transient buffers with q.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "checkhealth",
    "help",
    "lazy",
    "man",
    "notify",
    "qf",
    "query",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

-- Reload files changed outside Neovim when focus returns.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  callback = function()
    if vim.bo.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})
