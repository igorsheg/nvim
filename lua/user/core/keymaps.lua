vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local silent = { silent = true }
local keymap = vim.keymap.set

-- Normal --
-- Disable Space bar since it'll be used as the leader key
keymap("n", "<space>", "<nop>")

-- Swap between last two buffers
keymap("n", "<leader>'", "<C-^>", { desc = "Switch to last buffer" })

-- Map H and L to ^ and $
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

-- Make J and K move selected lines up and down
keymap("v", "J", [[:move '>+1<CR>gv=gv]], opts)
keymap("v", "K", [[:move '<-2<CR>gv=gv]], opts)

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

-- Don't leave visual mode after indenting
keymap("v", ">", ">gv^")
keymap("v", "<", "<gv^")

-- Normal Mode Mappings
keymap("n", "<leader> ", [[<Nop>]], opts)
-- keymap("n", "<leader>A", [[<cmd>Alpha<CR>]], opts)
keymap("n", "<leader>w", [[<cmd>w!<CR>]], opts)
keymap("n", "<leader>q", [[<cmd>q!<CR>]], opts)
keymap("n", "<leader>e", [[<cmd>Neotree toggle<CR>]], opts)
-- keymap("n", "<leader>c", [[<cmd>lua MiniBufremove.delete()<CR>]], opts)
-- keymap("n", "<leader>C", [[<cmd>%bdelete|edit #|normal `"<CR>]], opts)
keymap("n", "<leader>f", [[<cmd>Telescope find_files theme=ivy preview=false no_ignore=false<CR>]], opts)
keymap("n", "<leader>F", [[<cmd>Telescope live_grep search= theme=ivy only_sort_text=true<CR>]], opts)

keymap("v", "<leader>F", function()
  local text = vim.getVisualSelection()
  require("telescope.builtin").live_grep { default_text = text }
end, opts)

function vim.getVisualSelection()
  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg "v"
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

-- keymap("n", "<leader>.", function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
--     winblend = 10,keyma
--     previewer = false,
--   })
-- end, { desc = "[/] Fuzzily search in current buffer" })

keymap("n", "<leader>,", [[<cmd>Telescope resume<CR>]], opts)
-- keymap("n", "<leader>/", [[<cmd>lua require('Comment.api').toggle.linewise.current()<CR>]], opts)
-- keymap("n", "<leader>G", [[<cmd>Git<CR>]], opts)
-- keymap("n", "<leader>s", [[:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)

keymap("n", "<leader>s", function()
  local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end)

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

-- Goto next diagnostic of any severity
keymap("n", "]d", function()
  vim.diagnostic.goto_next {}
  vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
keymap("n", "[d", function()
  vim.diagnostic.goto_prev {}
  vim.api.nvim_feedkeys("zz", "n", false)
end)

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
keymap("n", "<c-w><enter>", [[:vsplit <BAR> wincmd l <BAR> Telescope find_files no_ignore=false hidden=true<CR>]], opts)
keymap("n", "<Leader>-", ":split<CR>", opts)
keymap("n", "<Leader><BS>", ":vsplit<CR>", opts)

local function find_project_root(markers)
  local dir = vim.fn.expand "%:p:h"
  local root = dir
  local found = false

  while dir do
    for _, marker in pairs(markers) do
      if
        vim.fn.isdirectory(vim.fn.expand(dir .. "/" .. marker)) ~= 0
        or vim.fn.filereadable(vim.fn.expand(dir .. "/" .. marker)) ~= 0
      then
        root = dir
        found = true
        break
      end
    end

    if found then
      break
    end

    dir = vim.fn.fnamemodify(dir, ":h")
  end

  return root
end

local function open_in_vscode()
  -- Markers that denote the root of the project
  local root_markers = { ".git" } -- Add more markers as needed
  local project_root = find_project_root(root_markers)
  local current_file = vim.fn.expand "%:p"

  -- Open VSCode with the project root and the current file
  vim.fn.system("code --new-window " .. project_root .. " " .. current_file)
end

-- Open VsCode
keymap("n", "<leader>vs", open_in_vscode, opts)
