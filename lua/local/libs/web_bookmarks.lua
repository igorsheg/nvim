local M = {}

local bookmarks_path = vim.fn.expand("~/workspace/dotfiles/wixlinks.json")
local ns = vim.api.nvim_create_namespace("web_bookmarks")

local state = {
  open = false,
  items = {},
  filtered = {},
  cursor = 1,
  query = "",
  list_buf = nil,
  input_buf = nil,
  list_win = nil,
  input_win = nil,
}

local function open_url(url)
  local cmd = vim.uv.os_uname().sysname == "Darwin" and "open" or "xdg-open"
  vim.system({ cmd, url }, { detach = true })
end

local function load_bookmarks()
  local fd = assert(io.open(bookmarks_path, "r"))
  local content = fd:read("*a")
  fd:close()
  return vim.json.decode(content)
end

local function close()
  vim.cmd.stopinsert()

  for _, win in ipairs({ state.input_win, state.list_win }) do
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  state.open = false
end

local function score(item, query)
  if query == "" then
    return true
  end

  local haystack = (item.name .. " " .. item.url):lower()
  for word in query:lower():gmatch("%S+") do
    if not haystack:find(word, 1, true) then
      return false
    end
  end

  return true
end

local function filter()
  state.filtered = {}

  for _, item in ipairs(state.items) do
    if score(item, state.query) then
      table.insert(state.filtered, item)
    end
  end

  state.cursor = math.min(state.cursor, math.max(#state.filtered, 1))
end

local function render()
  if not state.list_buf or not vim.api.nvim_buf_is_valid(state.list_buf) then
    return
  end

  local lines = {}
  local width = vim.api.nvim_win_get_width(state.list_win)

  for i, item in ipairs(state.filtered) do
    local prefix = i == state.cursor and "› " or "  "
    local line = prefix .. item.name .. "  " .. item.url
    table.insert(lines, vim.fn.strcharpart(line, 0, width - 1))
  end

  if #lines == 0 then
    lines = { "  No bookmarks found" }
  end

  vim.bo[state.list_buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.list_buf, 0, -1, false, lines)
  vim.bo[state.list_buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(state.list_buf, -1, 0, -1)
  for i, item in ipairs(state.filtered) do
    local row = i - 1
    local name_start = 2
    local name_end = name_start + #item.name
    if name_start < #lines[i] then
      vim.api.nvim_buf_set_extmark(state.list_buf, ns, row, name_start, {
        end_col = math.min(name_end, #lines[i]),
        hl_group = "Title",
      })
    end

    if name_end + 2 < #lines[i] then
      vim.api.nvim_buf_set_extmark(state.list_buf, ns, row, name_end + 2, {
        end_col = #lines[i],
        hl_group = "Comment",
      })
    end
  end
end

local function refresh()
  state.query = vim.api.nvim_buf_get_lines(state.input_buf, 0, 1, false)[1] or ""
  filter()
  render()
end

local function move(delta)
  if #state.filtered == 0 then
    return
  end

  state.cursor = ((state.cursor - 1 + delta) % #state.filtered) + 1
  render()
end

local function select()
  local item = state.filtered[state.cursor]
  if not item then
    return
  end

  close()
  open_url(item.url)
end

function M.open()
  if state.open then
    close()
    return
  end

  local ok, bookmarks = pcall(load_bookmarks)
  if not ok then
    vim.notify("Failed to load bookmarks: " .. bookmarks, vim.log.levels.ERROR)
    return
  end

  state.open = true
  state.items = bookmarks
  state.filtered = bookmarks
  state.cursor = 1
  state.query = ""

  local columns = vim.o.columns
  local lines = vim.o.lines
  local width = columns
  local height = math.floor(lines * 0.4)
  local row = lines - height - 3

  state.list_buf = vim.api.nvim_create_buf(false, true)
  state.input_buf = vim.api.nvim_create_buf(false, true)

  state.list_win = vim.api.nvim_open_win(state.list_buf, false, {
    relative = "editor",
    row = row,
    col = 0,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Bookmarks ",
    title_pos = "center",
  })

  state.input_win = vim.api.nvim_open_win(state.input_buf, true, {
    relative = "editor",
    row = row + height + 1,
    col = 0,
    width = width,
    height = 1,
    style = "minimal",
    border = "rounded",
    title = " Search ",
    title_pos = "left",
  })

  vim.api.nvim_buf_set_lines(state.input_buf, 0, -1, false, { "" })
  vim.bo[state.list_buf].bufhidden = "wipe"
  vim.bo[state.input_buf].bufhidden = "wipe"

  local opts = { buffer = state.input_buf, silent = true }
  vim.keymap.set({ "i", "n" }, "<Esc>", close, opts)
  vim.keymap.set({ "i", "n" }, "<C-c>", close, opts)
  vim.keymap.set({ "i", "n" }, "<CR>", select, opts)
  vim.keymap.set({ "i", "n" }, "<C-j>", function() move(1) end, opts)
  vim.keymap.set({ "i", "n" }, "<C-k>", function() move(-1) end, opts)

  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = state.input_buf,
    callback = refresh,
  })

  vim.cmd.startinsert()
  render()
end

return M
