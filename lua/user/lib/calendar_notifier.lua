local M = {}

-- Configuration
local config = {
  check_interval = 60, -- Check every 60 seconds
  warning_time = 5, -- Minutes before meeting to show notification
  cache_duration = 60, -- Cache calendar data for 1 minute
  calendar_names = {}, -- Specific calendar names to filter (empty = all calendars)
}

local cache = {
  data = nil,
  last_fetch = 0,
}

local notified_events = {} -- Track which events we've already notified about

local function notify(message, level, opts)
  opts = opts or {}
  if Snacks and Snacks.notifier then
    Snacks.notifier.notify(message, vim.tbl_extend("force", { level = level or "info" }, opts))
  else
    vim.notify(message, level or vim.log.levels.INFO)
  end
end

-- Escape string for AppleScript
local function escape_applescript(str)
  return str:gsub('"', '\\"'):gsub("\\", "\\\\")
end

-- Fetch calendar data using macOS Calendar.app via AppleScript
local function fetch_calendar()
  local now = os.time()

  -- Return cached data if still valid
  if cache.data and (now - cache.last_fetch) < config.cache_duration then
    return cache.data
  end

  -- Build AppleScript to fetch events from Calendar.app
  local calendar_filter = ""
  if #config.calendar_names > 0 then
    local cal_names = {}
    for _, name in ipairs(config.calendar_names) do
      table.insert(cal_names, '"' .. escape_applescript(name) .. '"')
    end
    calendar_filter = " whose calendar's name is in {" .. table.concat(cal_names, ", ") .. "}"
  end

  local applescript = string.format(
    [[
osascript -e '
tell application "Calendar"
  set startDate to current date
  set endDate to current date
  set time of endDate to (time of endDate) + (24 * 60 * 60)

  set eventList to {}
  set allEvents to (every event of every calendar whose start date is greater than or equal to startDate and start date is less than or equal to endDate%s)

  repeat with evt in allEvents
    set eventInfo to ""
    set eventInfo to eventInfo & (start date of evt as string) & "|"
    set eventInfo to eventInfo & (summary of evt as string) & "|"

    try
      set eventInfo to eventInfo & (location of evt as string) & "|"
    on error
      set eventInfo to eventInfo & "|"
    end try

    try
      set eventInfo to eventInfo & (uid of evt as string)
    on error
      set eventInfo to eventInfo & ""
    end try

    set end of eventList to eventInfo
  end repeat

  set AppleScript'\''s text item delimiters to linefeed
  return eventList as text
end tell
' 2>/dev/null
]],
    calendar_filter
  )

  local handle = io.popen(applescript)
  if not handle then
    return nil, "Failed to query Calendar.app"
  end

  local content = handle:read "*a"
  local success = handle:close()

  if not content or content == "" then
    -- No events is valid, return empty list
    cache.data = {}
    cache.last_fetch = now
    return {}
  end

  -- Parse output
  local events = {}
  for line in content:gmatch "[^\r\n]+" do
    local parts = {}
    for part in (line .. "|"):gmatch "([^|]*)|" do
      table.insert(parts, part)
    end

    if #parts >= 4 then
      local date_str = parts[1]
      local summary = parts[2]
      local location = parts[3]
      local uid = parts[4]

      -- Parse macOS date format: "Tuesday, November 26, 2024 at 2:30:00 PM"
      local weekday, month, day, year, hour, min, sec, ampm =
        date_str:match "(%w+), (%w+) (%d+), (%d+) at (%d+):(%d+):(%d+) (%w+)"

      if year and month and day and hour and min then
        -- Convert month name to number
        local months = {
          January = 1,
          February = 2,
          March = 3,
          April = 4,
          May = 5,
          June = 6,
          July = 7,
          August = 8,
          September = 9,
          October = 10,
          November = 11,
          December = 12,
        }

        local month_num = months[month]
        if month_num then
          local hour_num = tonumber(hour)
          if ampm == "PM" and hour_num ~= 12 then
            hour_num = hour_num + 12
          elseif ampm == "AM" and hour_num == 12 then
            hour_num = 0
          end

          local start_time = os.time {
            year = tonumber(year),
            month = month_num,
            day = tonumber(day),
            hour = hour_num,
            min = tonumber(min),
            sec = tonumber(sec),
          }

          if summary and summary ~= "" then
            table.insert(events, {
              start_time = start_time,
              summary = summary,
              location = location ~= "" and location or nil,
              uid = uid ~= "" and uid or (summary .. tostring(start_time)),
            })
          end
        end
      end
    end
  end

  -- Update cache
  cache.data = events
  cache.last_fetch = now

  return events
end

-- Format time remaining as a human-readable string
local function format_time_remaining(seconds)
  local minutes = math.floor(seconds / 60)
  if minutes < 1 then
    return "less than a minute"
  elseif minutes == 1 then
    return "1 minute"
  else
    return string.format("%d minutes", minutes)
  end
end

-- Check for upcoming meetings
local function check_upcoming_meetings()
  local events, err = fetch_calendar()
  if not events then
    if err then
      notify("Calendar error: " .. err, vim.log.levels.ERROR)
    end
    return
  end

  local now = os.time()
  local warning_seconds = config.warning_time * 60

  for _, event in ipairs(events) do
    if event.start_time and event.uid then
      local time_until = event.start_time - now

      -- Check if we should notify (within warning window but not in the past)
      if time_until > 0 and time_until <= warning_seconds then
        -- Only notify once per event
        if not notified_events[event.uid] then
          notified_events[event.uid] = true

          local time_str = format_time_remaining(time_until)
          local message = string.format("Meeting in %s: %s", time_str, event.summary)

          if event.location and event.location ~= "" then
            message = message .. string.format("\nLocation: %s", event.location)
          end

          notify(message, vim.log.levels.WARN, {
            title = " Upcoming Meeting",
            icon = "",
          })
        end
      elseif time_until < -3600 then
        -- Clean up old notifications (events that ended more than 1 hour ago)
        notified_events[event.uid] = nil
      end
    end
  end
end

-- Start the background check timer
local function start_timer()
  local timer = vim.loop.new_timer()
  if not timer then
    notify("Failed to create timer for calendar notifications", vim.log.levels.ERROR)
    return
  end

  -- Check immediately on start
  vim.defer_fn(check_upcoming_meetings, 1000)

  -- Then check every interval
  timer:start(
    config.check_interval * 1000,
    config.check_interval * 1000,
    vim.schedule_wrap(check_upcoming_meetings)
  )

  return timer
end

-- Manual check command
function M.check_now()
  notify("Checking calendar...", vim.log.levels.INFO)
  check_upcoming_meetings()
end

-- Show upcoming events
function M.show_upcoming()
  local events, err = fetch_calendar()
  if not events then
    notify("Failed to fetch calendar: " .. (err or "unknown error"), vim.log.levels.ERROR)
    return
  end

  local now = os.time()
  local upcoming = {}

  for _, event in ipairs(events) do
    if event.start_time and event.start_time > now then
      table.insert(upcoming, event)
    end
  end

  -- Sort by start time
  table.sort(upcoming, function(a, b)
    return a.start_time < b.start_time
  end)

  if #upcoming == 0 then
    notify("No upcoming meetings", vim.log.levels.INFO)
    return
  end

  -- Format and display
  local lines = { "Upcoming meetings:" }
  for i, event in ipairs(upcoming) do
    if i > 5 then
      break
    end -- Show max 5 events
    local time_str = os.date("%b %d, %H:%M", event.start_time)
    local line = string.format("  %s - %s", time_str, event.summary)
    table.insert(lines, line)
  end

  notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = " Calendar",
  })
end

-- Clear cache
function M.refresh()
  cache.data = nil
  cache.last_fetch = 0
  notified_events = {}
  notify("Calendar cache cleared", vim.log.levels.INFO)
  check_upcoming_meetings()
end

-- Setup function
function M.setup(opts)
  opts = opts or {}

  -- Merge user config
  config = vim.tbl_deep_extend("force", config, opts)

  -- Check if running on macOS
  local os_name = vim.loop.os_uname().sysname
  if os_name ~= "Darwin" then
    notify("Calendar notifier only works on macOS", vim.log.levels.ERROR)
    return
  end

  -- Create user commands
  vim.api.nvim_create_user_command("CalendarCheck", M.check_now, {
    desc = "Check for upcoming calendar events now",
  })

  vim.api.nvim_create_user_command("CalendarUpcoming", M.show_upcoming, {
    desc = "Show upcoming calendar events",
  })

  vim.api.nvim_create_user_command("CalendarRefresh", M.refresh, {
    desc = "Refresh calendar cache",
  })

  -- Start the timer
  start_timer()

  notify("Calendar notifier started (macOS Calendar.app)", vim.log.levels.INFO)
end

return M
