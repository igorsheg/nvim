-- Core editor options only. Keep this file boring.

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.cmdheight = 0
opt.laststatus = 3
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.shortmess:append({ I = true, W = true, c = true, C = true })
opt.messagesopt = "wait:0,history:500,progress:c"

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.confirm = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.autoread = true

-- Diff
opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "algorithm:histogram",
  "indent-heuristic",
}

-- Responsiveness
opt.updatetime = 100
opt.timeoutlen = 300
opt.ttimeoutlen = 10

-- System integration
opt.clipboard = "unnamedplus"

-- Completion
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
