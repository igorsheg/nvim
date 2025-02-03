local Path = require "plenary.path"

---@class Bookmark
---@field name string
---@field url string

local M = {}

-- Detect OS and get appropriate open command
local function get_open_command()
  local os_name = vim.loop.os_uname().sysname
  if os_name == "Linux" then
    return "xdg-open"
  elseif os_name == "Darwin" then
    return "open"
  end
  error "Unsupported OS for this script"
end

-- Load bookmarks from JSON file
local function load_bookmarks()
  local json_path = Path:new(vim.fn.expand "~/workspace/dotfiles/wixlinks.json")
  local json_content = json_path:read()
  return vim.json.decode(json_content)
end

-- Custom finder for bookmarks
local function bookmarks_finder()
  ---@type Bookmark[]
  local bookmarks = load_bookmarks()
  local items = {}

  for _, bookmark in ipairs(bookmarks) do
    table.insert(items, {
      text = bookmark.name,
      url = bookmark.url,
    })
  end

  return items
end

-- Format function for how bookmarks appear in the picker
local function format_bookmark(item)
  return {
    { item.text, "Title" },
    { " - ", "Comment" },
    { item.url, "String" },
  }
end

-- Action to open the URL
local function open_url(picker, item)
  if item then
    local open_command = get_open_command()
    vim.fn.system(open_command .. ' "' .. item.url .. '"')
    picker:close()
  end
end

-- Configure and create the bookmarks picker
M.open_bookmarks = function()
  Snacks.picker.pick {
    finder = bookmarks_finder,
    format = format_bookmark,
    prompt = "󰃀 Wix Bookmarks ",
    confirm = open_url,
    layout = {
      preset = "ivy",
    },
  }
end

-- Set up the command and keymap
vim.api.nvim_create_user_command("OpenBookmarks", M.open_bookmarks, {})

vim.keymap.set("n", "<leader>ab", ":OpenBookmarks<CR>")

return M
