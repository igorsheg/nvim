local o, opt, bo, wo, fn = vim.o, vim.opt, vim.bo, vim.wo, vim.fn

-- Disabling certain `formatoptions` upon entering a buffer window
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

-- Setting up buffer-local options and mappings for specific file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    "fzf",
    "Jaq",
    "qf",
    "git",
    "help",
    "oil",
    "Oil",
    "man",
    "lspinfo",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "",
  },
  callback = function()
    vim.cmd [[
       nnoremap <silent> <buffer> q :close<CR>
       set nobuflisted
     ]]
  end,
})

-- Open :help in vertical split instead of horizontal
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    bo.bufhidden = "unload"
    vim.cmd.wincmd "L"
    vim.cmd "vertical resize 81"
  end,
})

-- Automatically exiting the command-line window when it's entered
vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd "quit"
  end,
})

-- Equalizing window sizes when the Vim window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- Checking for changes in the file when entering a buffer window
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd "checktime"
  end,
})

-- Highlighting yanked text briefly
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
  end,
})

-- Enabling `wrap` and `spell` options for specific file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Restoring the cursor position when reopening a file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd 'silent! normal! g`"zv'
  end,
})

-- Start git commits at start of line, and insert mode if message is empty
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    wo.spell = true
    if fn.getline(1) == "" then
      vim.cmd "startinsert!"
    end
  end,
})
