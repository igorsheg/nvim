local M = {}
local utils = require "user.utils"

-- Function to get the monorepo root
local function get_monorepo_root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()
  return result:gsub("%s+$", "")
end

-- Function to check if a command exists
local function command_exists(cmd)
  local handle = io.popen("command -v " .. cmd .. " 2>/dev/null")
  if not handle then return false end
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end

-- Function to read and parse JSON file
local function parse_json_file(file_path)
  local file = io.open(file_path, "r")
  if not file then return nil end
  local content = file:read("*all")
  file:close()

  local json = vim.fn.json_decode(content)
  return json
end

local function find_packages(monorepo_root)
  if not command_exists("rg") then
    print("rg (ripgrep) is required. Please install it and try again.")
    return {}
  end

  local package_json = parse_json_file(monorepo_root .. "/package.json")
  if not package_json or not package_json.workspaces then
    print("Unable to parse package.json or workspaces not defined.")
    return {}
  end

  local results = {}
  for _, workspace in ipairs(package_json.workspaces) do
    workspace = workspace:gsub("^%./", ""):gsub("/%*$", "")
    local abs_path = monorepo_root .. "/" .. workspace
    local cmd = string.format("rg --files -g 'package.json' %s | xargs -n1 dirname", vim.fn.shellescape(abs_path))
    local handle = io.popen(cmd)
    if handle then
      for line in handle:lines() do
        local relative_path = line:sub(#monorepo_root + 2) -- +2 to account for the trailing slash
        if not results[relative_path] then
          results[relative_path] = true
        end
      end
      handle:close()
    end
  end

  local package_dirs = {}
  for dir, _ in pairs(results) do
    table.insert(package_dirs, dir)
  end
  table.sort(package_dirs)
  return package_dirs
end

function M.select_package()
  local monorepo_root = get_monorepo_root()
  if not monorepo_root then
    print("Not in a Git repository.")
    return
  end

  local package_dirs = find_packages(monorepo_root)

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Select Package",
    finder = finders.new_table {
      results = package_dirs
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local relative_path = selection[1]
          local target_dir = vim.fn.fnamemodify(monorepo_root .. "/" .. relative_path, ":p")

          -- Ensure the path is correct
          if vim.fn.isdirectory(target_dir) == 0 then
            print("Error: Directory does not exist: " .. target_dir)
            return
          end

          vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
          print("Changed directory to " .. target_dir)
        end
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command("OpenWorkspaces", M.select_package, {})
utils.map("n", "<leader>ap", ":OpenWorkspaces<CR>")
