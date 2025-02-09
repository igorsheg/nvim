vim.g.mapleader = " "
local opts = { noremap = true, silent = true }
local silent = { silent = true }
local keymap = vim.keymap.set

-- Command abbreviations for fixing common typos
vim.cmd [[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev WQ1 wq!
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]]

-- General Normal Mode Mappings
keymap("n", "<space>", "<nop>")
keymap("n", "H", "<cmd>foldclose<CR>", opts)
keymap("n", "<leader> ", [[<Nop>]], opts)
keymap("n", "<leader>w", [[<cmd>w!<CR>]], opts)
keymap("n", "<leader>q", [[<cmd>q!<CR>]], opts)
keymap("n", "<CR>", "viw", { noremap = true, silent = true, desc = "Select inner word" })

-- Moving and Resizing Windows
keymap("n", "<C-j>", [[<C-w>j]], opts)
keymap("n", "<C-k>", [[<C-w>k]], opts)
keymap("n", "<C-l>", [[<C-w>l]], opts)
keymap("n", "<C-h>", [[<C-w>h]], opts)
keymap("n", "<C-Up>", [[:resize +2<CR>]], opts)
keymap("n", "<C-Down>", [[:resize -2<CR>]], opts)
keymap("n", "<C-Left>", [[:vertical resize -2<CR>]], opts)
keymap("n", "<C-Right>", [[:vertical resize +2<CR>]], opts)

-- Center buffer while navigating
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "{", "{zz")
keymap("n", "}", "}zz")
keymap("n", "N", "Nzz")
keymap("n", "n", "nzz")
keymap("n", "G", "Gzz")
keymap("n", "gg", "ggzz")
keymap("n", "<C-i>", "<C-i>zz")
keymap("n", "<C-o>", "<C-o>zz")
keymap("n", "%", "%zz")
keymap("n", "*", "*zz")
keymap("n", "#", "#zz")

-- Visual Mode Mappings
keymap("v", "J", [[:move '>+1<CR>gv=gv]], opts)
keymap("v", "K", [[:move '<-2<CR>gv=gv]], opts)
keymap("v", ">", ">gv^")
keymap("v", "<", "<gv^")

-- Terminal Mode Mappings
keymap("t", "<esc>", [[<C-\><C-n>]], silent)
keymap("t", "jk", [[<C-\><C-n>]], silent)
keymap("t", "<C-h>", [[<Cmd>wincmd h<CR>]], silent)
keymap("t", "<C-j>", [[<Cmd>wincmd j<CR>]], silent)
keymap("t", "<C-k>", [[<Cmd>wincmd k<CR>]], silent)
keymap("t", "<C-l>", [[<Cmd>wincmd l<CR>]], silent)
keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], silent)

-- Utilities
-- keymap("n", "<leader>vs", utils.open_in_vscode, opts)
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")
keymap("n", "<Esc><Esc>", [[:noh<CR>]], opts)

-- Movement with enhanced search and undo points in Insert mode
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Clipboard integration
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])
keymap({ "n", "v" }, "<leader>d", [["_d]])
