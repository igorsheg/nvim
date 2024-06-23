local M = {}
local utils = require "user.utils"

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

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

local function search_in_wix_private(query)
  local search_query = query:gsub("%s", "+") -- Replace spaces with plus signs for URL encoding
  local url = "https://github.com/search?q=org%3Awix-private%20" .. search_query .. "&type=code"
  -- Use an external utility to open the URL in the default web browser
  -- Adjust the command below depending on your OS:
  -- For Linux, use 'xdg-open'; for MacOS, use 'open'; for Windows, use 'start'
  local success, err = vim.fn.jobstart({ open_command, url }, { detach = true })
  if not success then
    notify("Failed to open browser: " .. err, vim.log.levels.ERROR)
  end
end

function M.github_search()
  vim.ui.input({ prompt = "Search github at repo:wix-private: " }, function(input)
    if not input then
      notify("No input provided!", vim.log.levels.ERROR)
      return
    end
    search_in_wix_private(input)
  end)
end

-- Register the command and key mappings
vim.api.nvim_create_user_command("GitHubSearchWixPrivate", M.github_search, {})
utils.map("n", "<leader>ar", ":GitHubSearchWixPrivate<CR>")

return M
