local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local utils = require "user.utils"
local Path = require "plenary.path"

local M = {}

M.open_url = function()
  local json_path = Path:new(vim.fn.expand "~/workspace/dotfiles/wixlinks.json")
  local json_content = json_path:read()
  local urls = vim.json.decode(json_content)

  -- Detect OS
  local os_name = vim.loop.os_uname().sysname
  local open_command
  if os_name == "Linux" then
    open_command = "xdg-open"
  elseif os_name == "Darwin" then
    open_command = "open"
  else
    print "Unsupported OS for this script"
    return
  end

  pickers
    .new({}, {
      prompt_title = "Open URL",
      finder = finders.new_table {
        results = urls,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
            url = entry.url,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          -- Use the URL from the selected entry
          vim.fn.system(open_command .. ' "' .. selection.url .. '"')
        end)
        return true
      end,
    })
    :find()
end

vim.api.nvim_create_user_command("OpenBookmarks", M.open_url, {})
utils.map("n", "<leader>ab", ":OpenBookmarks<CR>")
