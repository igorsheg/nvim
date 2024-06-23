local M = {}
local utils = require "user.utils"

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

local function get_package_json_path()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    notify("Current buffer is not associated with a file.", vim.log.levels.ERROR)
    return
  end

  local package_json_path = vim.fn.findfile("package.json", vim.fn.fnamemodify(current_file, ":p:h") .. ";")
  if package_json_path == "" then
    notify("package.json not found in any parent directory of the current file.", vim.log.levels.ERROR)
    return
  end
  return package_json_path
end

local function read_package_json(package_json_path)
  local file = io.open(package_json_path, "r")
  if not file then
    notify("Failed to open " .. package_json_path, vim.log.levels.ERROR)
    return
  end
  local content = file:read "*a"
  file:close()
  return content
end

local function parse_package_scripts(package_json)
  local package_data = vim.json.decode(package_json)
  if not package_data or not package_data.scripts then
    notify("No scripts found in package.json.", vim.log.levels.ERROR)
    return
  end

  local script_keys = {}
  for k in pairs(package_data.scripts) do
    table.insert(script_keys, k)
  end
  return script_keys
end

function M.run_script_in_repo_root()
  local package_json_path = get_package_json_path()
  if not package_json_path then
    return
  end

  local package_json = read_package_json(package_json_path)
  if not package_json then
    return
  end

  local script_keys = parse_package_scripts(package_json)
  if not script_keys then
    return
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Run Script",
      finder = require("telescope.finders").new_table { results = script_keys },
      sorter = require("telescope.config").values.generic_sorter {},
      attach_mappings = function(_, map)
        map("i", "<CR>", function(bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(bufnr)
          local root_dir = vim.fn.fnamemodify(package_json_path, ":h")

          local cmd = "yarn run " .. selection[1]
          local width = vim.o.columns * 0.4
          vim.cmd(string.format("TermExec size=%s cmd='%s' dir=%s", width, cmd, root_dir))
          vim.cmd "startinsert"
        end)
        return true
      end,
    })
    :find()
end

-- Register the command and key mapping
vim.api.nvim_create_user_command("RunScriptInRepoRoot", M.run_script_in_repo_root, {})
utils.map("n", "<leader>k", ":RunScriptInRepoRoot<CR>")
