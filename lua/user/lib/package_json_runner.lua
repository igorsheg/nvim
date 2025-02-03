local M = {}

-- Helper function for notifications
local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

-- Find the package.json file in parent directories
local function get_package_json_path()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    notify("Current buffer is not associated with a file.", vim.log.levels.ERROR)
    return nil
  end

  local package_json_path = vim.fn.findfile("package.json", vim.fn.fnamemodify(current_file, ":p:h") .. ";")
  if package_json_path == "" then
    notify("package.json not found in any parent directory of the current file.", vim.log.levels.ERROR)
    return nil
  end

  return package_json_path
end

-- Read and parse package.json file
local function read_package_json(package_json_path)
  local file = io.open(package_json_path, "r")
  if not file then
    notify("Failed to open " .. package_json_path, vim.log.levels.ERROR)
    return nil
  end

  local content = file:read "*a"
  file:close()

  local success, package_data = pcall(vim.json.decode, content)
  if not success or not package_data or not package_data.scripts then
    notify("No scripts found in package.json.", vim.log.levels.ERROR)
    return nil
  end

  return package_data
end

-- Custom finder for package scripts
local function scripts_finder()
  local package_json_path = get_package_json_path()
  if not package_json_path then
    return {}
  end

  local package_data = read_package_json(package_json_path)
  if not package_data then
    return {}
  end

  local items = {}
  for name, command in pairs(package_data.scripts) do
    table.insert(items, {
      text = name,
      command = command,
      package_path = package_json_path,
    })
  end

  return items
end

-- Format function for how scripts appear in the picker
local function format_script(item)
  return {
    { "󰎛 ", "Special" },
    { item.text, "Function" },
    { " → ", "Comment" },
    { item.command, "String" },
  }
end

-- Action to run the selected script
local function run_script(picker, item)
  if item then
    local root_dir = vim.fn.fnamemodify(item.package_path, ":h")
    local cmd = "yarn run " .. item.text

    picker:close()
    vim.schedule(function()
      Snacks.terminal.toggle(cmd, {
        cwd = root_dir,
        win = {
          width = math.floor(vim.o.columns * 0.4),
          position = "right",
        },
      })
    end)
  end
end

-- Configure and create the scripts picker
function M.run_script_in_repo_root()
  Snacks.picker.pick {
    finder = scripts_finder,
    format = format_script,
    prompt = "󰎛 Run Script>",
    confirm = run_script,
    layout = {
      preset = "dropdown",
    },
  }
end

-- Register the command and key mapping
vim.api.nvim_create_user_command("RunScriptInRepoRoot", M.run_script_in_repo_root, {})
vim.keymap.set("n", "<leader>k", ":RunScriptInRepoRoot<CR>")

return M
