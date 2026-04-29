local M = {}

-- Shared icon vocabulary.
-- Keep icons centralized so plugins stay visually consistent.

M.style = "glyph"

M.files = {
  default = "󰈔",
  folder_closed = "󰉋",
  folder_open = "󰝰",
  folder_empty = "󰉖",
}

M.tree = {
  collapsed = "",
  expanded = "",
}

M.git = {
  added = "✚",
  deleted = "✖",
  modified = "",
  renamed = "󰁕",
  untracked = "",
  ignored = "",
  unstaged = "󰄱",
  staged = "",
  conflict = "",
}

M.git_signs = {
  add = "▎",
  change = "▎",
  delete = "",
  topdelete = "",
  changedelete = "▎",
}

M.diagnostics = {
  error = "",
  warn = "",
  info = "",
  hint = "󰌵",
}

M.status = {
  done = "✓",
}

M.kinds = {
  Text = "󰉿",
  Method = "󰊕",
  Function = "󰊕",
  Constructor = "󰒓",
  Field = "󰜢",
  Variable = "󰆦",
  Property = "󰖷",
  Class = "󱡠",
  Interface = "󱡠",
  Struct = "󱡠",
  Module = "󰅩",
  Unit = "󰪚",
  Value = "󰦨",
  Enum = "󰦨",
  EnumMember = "󰦨",
  Keyword = "󰻾",
  Constant = "󰏿",
  Snippet = "󱄽",
  Color = "󰏘",
  File = "󰈔",
  Reference = "󰬲",
  Folder = "󰉋",
  Event = "󱐋",
  Operator = "󰪚",
  TypeParameter = "󰬛",
}

return M
