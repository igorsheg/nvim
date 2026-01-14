local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

local function get_comment_nodes(bufnr)
  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    notify("No Treesitter parser available for this buffer", vim.log.levels.ERROR)
    return {}
  end

  local trees = parser:parse()
  local root = trees[1]:root()
  local comment_nodes = {}

  local function traverse(node)
    if node:type() == "comment" or node:type() == "line_comment" or node:type() == "block_comment" then
      table.insert(comment_nodes, node)
    end

    for child in node:iter_children() do
      traverse(child)
    end
  end

  traverse(root)
  return comment_nodes
end

local function node_to_range(node)
  local start_row, start_col, end_row, end_col = node:range()
  return { start_row = start_row, start_col = start_col, end_row = end_row, end_col = end_col }
end

function M.remove_comments_from_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local filetype = vim.bo[bufnr].filetype
  if filetype == "" then
    notify("Cannot determine filetype for buffer", vim.log.levels.ERROR)
    return
  end

  local has_parser = pcall(vim.treesitter.get_parser, bufnr)
  if not has_parser then
    notify("No Treesitter parser available for filetype: " .. filetype, vim.log.levels.ERROR)
    return
  end

  local comment_nodes = get_comment_nodes(bufnr)

  if #comment_nodes == 0 then
    notify("No comments found in buffer", vim.log.levels.INFO)
    return
  end

  local ranges = {}
  for _, node in ipairs(comment_nodes) do
    table.insert(ranges, node_to_range(node))
  end

  table.sort(ranges, function(a, b)
    return a.start_row > b.start_row
  end)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local removed_count = 0

  for _, range in ipairs(ranges) do
    if range.start_row == range.end_row then
      local line = lines[range.start_row + 1]
      if line then
        local before = string.sub(line, 1, range.start_col)
        local after = string.sub(line, range.end_col + 1)
        local new_line = before .. after

        new_line = new_line:match "^%s*$" and "" or new_line

        if new_line == "" and range.start_row + 1 <= #lines then
          table.remove(lines, range.start_row + 1)
        else
          lines[range.start_row + 1] = new_line
        end
        removed_count = removed_count + 1
      end
    else
      for row = range.end_row, range.start_row, -1 do
        if row == range.start_row then
          local line = lines[row + 1]
          if line then
            lines[row + 1] = string.sub(line, 1, range.start_col)
          end
        elseif row == range.end_row then
          local line = lines[row + 1]
          if line then
            lines[row + 1] = string.sub(line, range.end_col + 1)
          end
        else
          table.remove(lines, row + 1)
        end
      end

      for row = range.end_row, range.start_row, -1 do
        if lines[row + 1] and lines[row + 1]:match "^%s*$" then
          table.remove(lines, row + 1)
        end
      end
      removed_count = removed_count + 1
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  notify(string.format("Removed %d comment%s", removed_count, removed_count == 1 and "" or "s"), vim.log.levels.INFO)
end

function M.remove_comments_visual()
  local start_row = vim.fn.line "'<" - 1
  local end_row = vim.fn.line "'>" - 1
  local bufnr = vim.api.nvim_get_current_buf()

  local filetype = vim.bo[bufnr].filetype
  if filetype == "" then
    notify("Cannot determine filetype for buffer", vim.log.levels.ERROR)
    return
  end

  local has_parser = pcall(vim.treesitter.get_parser, bufnr)
  if not has_parser then
    notify("No Treesitter parser available for filetype: " .. filetype, vim.log.levels.ERROR)
    return
  end

  local comment_nodes = get_comment_nodes(bufnr)
  local filtered_nodes = {}

  for _, node in ipairs(comment_nodes) do
    local node_start_row, _, node_end_row, _ = node:range()
    if node_start_row >= start_row and node_end_row <= end_row then
      table.insert(filtered_nodes, node)
    end
  end

  if #filtered_nodes == 0 then
    notify("No comments found in selection", vim.log.levels.INFO)
    return
  end

  local ranges = {}
  for _, node in ipairs(filtered_nodes) do
    table.insert(ranges, node_to_range(node))
  end

  table.sort(ranges, function(a, b)
    return a.start_row > b.start_row
  end)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local removed_count = 0

  for _, range in ipairs(ranges) do
    if range.start_row == range.end_row then
      local line = lines[range.start_row + 1]
      if line then
        local before = string.sub(line, 1, range.start_col)
        local after = string.sub(line, range.end_col + 1)
        local new_line = before .. after

        new_line = new_line:match "^%s*$" and "" or new_line

        if new_line == "" and range.start_row + 1 <= #lines then
          table.remove(lines, range.start_row + 1)
        else
          lines[range.start_row + 1] = new_line
        end
        removed_count = removed_count + 1
      end
    else
      for row = range.end_row, range.start_row, -1 do
        if row == range.start_row then
          local line = lines[row + 1]
          if line then
            lines[row + 1] = string.sub(line, 1, range.start_col)
          end
        elseif row == range.end_row then
          local line = lines[row + 1]
          if line then
            lines[row + 1] = string.sub(line, range.end_col + 1)
          end
        else
          table.remove(lines, row + 1)
        end
      end

      for row = range.end_row, range.start_row, -1 do
        if lines[row + 1] and lines[row + 1]:match "^%s*$" then
          table.remove(lines, row + 1)
        end
      end
      removed_count = removed_count + 1
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  notify(
    string.format("Removed %d comment%s from selection", removed_count, removed_count == 1 and "" or "s"),
    vim.log.levels.INFO
  )
end

function M.setup()
  vim.api.nvim_create_user_command("RemoveComments", function(opts)
    if opts.range > 0 then
      M.remove_comments_visual()
    else
      M.remove_comments_from_buffer()
    end
  end, {
    range = true,
    desc = "Remove comments from buffer or selection using Treesitter",
  })
end

return M
