require("lspconfig.ui.windows").default_options.border = "single"

-- vscode theme for lualine
local colors = {
  bg = "NONE",        -- Transparent background
  fg = "#FFFFFF",     -- White foreground (text)
  white = "#FFFFFF",  -- White color for separators
  subtle = "#888888", -- Change this to any color you like
}

-- Lualine
require("lualine").setup({
  options = {
    icons_enabled = true,
    globalstatus = true,
    theme = {
      normal = {
        a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.white, bg = colors.bg },
        x = { fg = colors.white, bg = colors.bg },
        y = { fg = colors.white, bg = colors.bg },
        z = { fg = colors.white, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
        x = { fg = colors.white, bg = colors.bg },
        y = { fg = colors.white, bg = colors.bg },
        z = { fg = colors.white, bg = colors.bg },
      },
      visual = {
        a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
        x = { fg = colors.white, bg = colors.bg },
        y = { fg = colors.white, bg = colors.bg },
        z = { fg = colors.white, bg = colors.bg },
      },
      replace = {
        a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
        x = { fg = colors.white, bg = colors.bg },
        y = { fg = colors.white, bg = colors.bg },
        z = { fg = colors.white, bg = colors.bg },
      },
      command = {
        a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
        x = { fg = colors.white, bg = colors.bg },
        y = { fg = colors.white, bg = colors.bg },
        z = { fg = colors.white, bg = colors.bg },
      },
      inactive = {
        a = { fg = colors.fg, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
        x = { fg = colors.white, bg = colors.bg },
        y = { fg = colors.white, bg = colors.bg },
        z = { fg = colors.white, bg = colors.bg },
      },
    },
    component_separators = { "│", "│" },
    section_separators = { "|", "|" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "branch", icon = "" } },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {},
})
