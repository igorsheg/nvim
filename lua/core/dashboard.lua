local M = {}

local logo = {
  "░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓██████████████▓▒░  ",
  "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░░▒▓█▓▒░  ░▒▓██▓▒░  ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ",
}

local function should_open()
  if vim.fn.argc() > 0 then
    return false
  end

  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype ~= "" then
    return false
  end

  if vim.api.nvim_buf_get_name(buf) ~= "" then
    return false
  end

  return true
end

function M.open()
  if not should_open() then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "dashboard"

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.cursorline = false
  vim.wo.foldcolumn = "0"
  vim.wo.list = false

  local lines = {}
  local height = vim.api.nvim_win_get_height(0)
  local width = vim.api.nvim_win_get_width(0)
  local top = math.max(math.floor((height - #logo) / 2), 0)

  for _ = 1, top do
    table.insert(lines, "")
  end

  for _, line in ipairs(logo) do
    local left = math.max(math.floor((width - vim.fn.strdisplaywidth(line)) / 2), 0)
    table.insert(lines, string.rep(" ", left) .. line)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

function M.setup()
  local group = vim.api.nvim_create_augroup("user_dashboard", { clear = true })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = M.open,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      if vim.bo.filetype == "dashboard" then
        return
      end

      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.wo.signcolumn = "yes"
      vim.wo.cursorline = true
      vim.wo.foldcolumn = "0"
      vim.wo.list = vim.o.list
    end,
  })
end

return M
