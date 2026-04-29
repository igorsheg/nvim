local M = {}

local function git(args, cwd)
  local result = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  return vim.trim(result.stdout or "")
end

local function github_base(remote)
  local host, path = remote:match("^git@([^:]+):(.+)$")
  if not host then
    host, path = remote:match("^https://([^/]+)/(.+)$")
  end

  if not host or not path then
    return nil
  end

  path = path:gsub("%.git$", "")
  return "https://" .. host .. "/" .. path
end

local function line_range()
  local mode = vim.fn.mode()
  if mode:match("[vV]") then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    return start_line, end_line
  end

  local line = vim.fn.line(".")
  return line, line
end

local function current_url(ref)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil, "No file"
  end

  local cwd = vim.fs.dirname(file)
  local root = git({ "rev-parse", "--show-toplevel" }, cwd)
  if not root then
    return nil, "Not in a git repository"
  end

  local remote = git({ "remote", "get-url", "origin" }, root)
  if not remote then
    return nil, "No origin remote"
  end

  local base = github_base(remote)
  if not base then
    return nil, "Unsupported git remote: " .. remote
  end

  local rel = git({ "ls-files", "--full-name", file }, root)
  if not rel or rel == "" then
    return nil, "File is not tracked by git"
  end

  local start_line, end_line = line_range()
  local fragment = "#L" .. start_line
  if end_line ~= start_line then
    fragment = fragment .. "-L" .. end_line
  end

  return table.concat({ base, "blob", ref, rel }, "/") .. fragment
end

function M.open()
  local file = vim.api.nvim_buf_get_name(0)
  local cwd = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  local ref = git({ "branch", "--show-current" }, cwd) or git({ "rev-parse", "HEAD" }, cwd)
  if not ref or ref == "" then
    vim.notify("Could not resolve git ref", vim.log.levels.WARN)
    return
  end

  local url, err = current_url(ref)
  if not url then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  vim.ui.open(url)
end

function M.copy_permalink()
  local file = vim.api.nvim_buf_get_name(0)
  local cwd = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  local ref = git({ "rev-parse", "HEAD" }, cwd)
  if not ref or ref == "" then
    vim.notify("Could not resolve git commit", vim.log.levels.WARN)
    return
  end

  local url, err = current_url(ref)
  if not url then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", url)
  vim.notify("Copied GitHub permalink")
end

return M
