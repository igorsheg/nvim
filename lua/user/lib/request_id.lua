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

-- Fetch logs for request ID
local function fetch_logs(request_id)
  local url = string.format("https://www.wix.com/_serverless/logs-support/request-id/%s", request_id)

  local curl_cmd = string.format('curl -s "%s"', url)
  local handle = io.popen(curl_cmd)
  if not handle then
    vim.notify("Failed to execute curl command", vim.log.levels.ERROR)
    return nil
  end

  local result = handle:read "*a"
  handle:close()

  if result == "" then
    vim.notify("No data received for request ID: " .. request_id, vim.log.levels.ERROR)
    return nil
  end

  local success, data = pcall(vim.json.decode, result)
  if not success then
    vim.notify("Failed to parse response for request ID: " .. request_id, vim.log.levels.ERROR)
    return nil
  end

  return data
end

-- Create finder for log URLs
local function logs_finder(request_id)
  local logs_data = fetch_logs(request_id)

  if not logs_data then
    return {}
  end

  local items = {}
  local labels = {
    newrelic = "🔴 New Relic",
    grafana = "📊 Grafana",
    app_analytics = "📈 App Analytics",
    redash = "🔍 Redash",
    kibana_logstash = "📋 Kibana Logstash",
    kibana_identity = "🔐 Kibana Identity",
  }

  local order = { "newrelic", "grafana", "app_analytics", "redash", "kibana_logstash", "kibana_identity" }

  for _, key in ipairs(order) do
    if logs_data[key] then
      table.insert(items, {
        text = labels[key] or key,
        url = logs_data[key],
      })
    end
  end

  return items
end

-- Format function for how log URLs appear in the picker
local function format_log_url(item)
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

-- Main function to open logs picker
M.open_logs = function(opts)
  opts = opts or {}
  local request_id = opts.args or vim.fn.input "Request ID: "

  if request_id == "" then
    vim.notify("No request ID provided", vim.log.levels.WARN)
    return
  end

  request_id = request_id:match "^%s*(.-)%s*$"

  Snacks.picker.pick {
    finder = function()
      return logs_finder(request_id)
    end,
    format = format_log_url, -- Changed from "file" to custom format
    preview = "none", -- Added: disable preview since these are URLs
    prompt = "🔍 Request ID Logs: " .. request_id .. " ",
    confirm = open_url,
    layout = {
      preset = "ivy",
    },
  }
end

vim.api.nvim_create_user_command("RequestId", function(opts)
  M.open_logs(opts)
end, {
  nargs = "?",
  desc = "Open logs for a Wix request ID",
})

return M
