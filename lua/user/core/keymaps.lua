vim.g.mapleader = ' '

local opts = { noremap = true, silent = true }
local silent = { silent = true }
local keymap = vim.keymap.set

-- Map H and L to ^ and $
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

-- Make J and K move selected lines up and down
keymap("v", "J", [[:move '>+1<CR>gv=gv]], opts)
keymap("v", "K", [[:move '<-2<CR>gv=gv]], opts)

-- Make certain motions keep cursor in the middle
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

-- Don't leave visual mode after indenting
keymap("v", ">", ">gv^")
keymap("v", "<", "<gv^")

-- Normal Mode Mappings
keymap("n", "<leader> ", [[<Nop>]], opts)
keymap("n", "<leader>A", [[<cmd>Alpha<CR>]], opts)
keymap("n", "<leader>w", [[<cmd>w!<CR>]], opts)
keymap("n", "<leader>q", [[<cmd>q!<CR>]], opts)
keymap("n", "<leader>e", [[<cmd>NvimTreeToggle<CR>]], opts)
keymap("n", "<leader>c", [[<cmd>lua MiniBufremove.delete()<CR>]], opts)
keymap("n", "<leader>C", [[<cmd>%bdelete|edit #|normal `"<CR>]], opts)
keymap("n", "<leader>5", [[<cmd>lua require('harpoon.ui').nav_file(5)<CR>]], opts)
keymap("n", "<leader>f", [[<cmd>Telescope find_files no_ignore=false hidden=true<CR>]], opts)
keymap("n", "<leader>F", [[<cmd>Telescope grep_string search= theme=ivy only_sort_text=true<CR>]], opts)
keymap("n", "<leader>,", [[<cmd>Telescope resume<CR>]], opts)
keymap("n", "<leader>/", [[<cmd>lua require('Comment.api').toggle.linewise.current()<CR>]], opts)
keymap("n", "<leader>G", [[<cmd>Git<CR>]], opts)
keymap("n", "<leader>s", [[:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
-- keymap("n", "<leader>v", [[:vsplit <BAR> wincmd l <BAR> wincmd p <BAR> wincmd h <BAR> b# <BAR> wincmd l<CR>]], opts)
-- keymap("n", "<leader>h", [[<C-w>s]], opts)
keymap("n", "<C-j>", [[<C-w>j]], opts)
keymap("n", "<C-k>", [[<C-w>k]], opts)
keymap("n", "<C-l>", [[<C-w>l]], opts)
keymap("n", "<C-h>", [[<C-w>h]], opts)
keymap("n", "<C-Up>", [[:resize +2<CR>]], opts)
keymap("n", "<C-Down>", [[:resize -2<CR>]], opts)
keymap("n", "<C-Left>", [[:vertical resize -2<CR>]], opts)
keymap("n", "<C-Right>", [[:vertical resize +2<CR>]], opts)
keymap("n", "<C-A-k>", [[<ESC>:m .-2<CR>==]], opts)
keymap("n", "<C-A-j>", [[<ESC>:m .+1<CR>==]], opts)

keymap("n", "[q", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
keymap("n", "]q", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)

-- Visual Mode Mappings
keymap("v", "<leader>/", [[<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>]], opts)
keymap("v", "<leader><", [[<gv]], opts)
keymap("v", "<leader>>", [[>gv]], opts)
keymap("v", "<leader>p", [['"_dP']], opts)
keymap("v", "<C-A-j>", [[:m '>+1<CR>gv=gv]], opts)
keymap("v", "<C-A-k>", [[:m '<-2<CR>gv=gv]], opts)

-- Insert Mode Mappings
keymap("i", "C-h", [[<C-o>h]], opts)
keymap("i", "C-j", [[<C-o>j]], opts)
keymap("i", "C-k", [[<C-o>k]], opts)
keymap("i", "C-l", [[<C-o>l]], opts)
keymap("i", "<C-A-j>", [[<ESC>:m .+1<CR>==gi]], opts)
keymap("i", "<C-A-k>", [[<ESC>:m .-2<CR>==gi]], opts)
keymap("i", "jk", [[<ESC>]], opts)

-- No Prefix Mappings
keymap("n", "<Esc><Esc>", [[:noh<CR>]], opts)

keymap("t", "<esc>", [[<C-\><C-n>]], silent)
keymap("t", "jk", [[<C-\><C-n>]], silent)
keymap("t", "<C-h>", [[<Cmd>wincmd h<CR>]], silent)
keymap("t", "<C-j>", [[<Cmd>wincmd j<CR>]], silent)
keymap("t", "<C-k>", [[<Cmd>wincmd k<CR>]], silent)
keymap("t", "<C-l>", [[<Cmd>wincmd l<CR>]], silent)
keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], silent)

keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

keymap("x", "<leader>p", [["_dP]])
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])
keymap({ "n", "v" }, "<leader>d", [["_d]])

keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- keymap("n", "<leader>a", [[<cmd>lua require('harpoon.mark').add_file()<CR>]], opts)
-- keymap("n", "<leader>m", [[<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>]], opts)

-- Split
keymap('n', '<c-w><enter>', [[:vsplit <BAR> wincmd l <BAR> Telescope find_files no_ignore=false hidden=true<CR>]], opts)
keymap('n', '<Leader>-', ':split<CR>', opts)
keymap('n', '<Leader><BS>', ':vsplit<CR>', opts)

local function find_project_root(markers)
  local dir = vim.fn.expand('%:p:h')
  local root = dir
  local found = false

  while dir do
    for _, marker in pairs(markers) do
      if vim.fn.isdirectory(vim.fn.expand(dir .. '/' .. marker)) ~= 0 or vim.fn.filereadable(vim.fn.expand(dir .. '/' .. marker)) ~= 0 then
        root = dir
        found = true
        break
      end
    end

    if found then
      break
    end

    dir = vim.fn.fnamemodify(dir, ':h')
  end

  return root
end

local function open_in_vscode()
  -- Markers that denote the root of the project
  local root_markers = { '.git' } -- Add more markers as needed
  local project_root = find_project_root(root_markers)
  local current_file = vim.fn.expand('%:p')

  -- Open VSCode with the project root and the current file
  vim.fn.system('code --new-window ' .. project_root .. ' ' .. current_file)
end

-- Open VsCode
keymap('n', '<leader>vs', open_in_vscode, opts)
