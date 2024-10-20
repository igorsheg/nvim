return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup {
      chunk = {
        enable = true,
        duration = 100,
        delay = 50,
        chars = {
          vertical_line = "┊",
          left_arrow = "─",
          horizontal_line = "─",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = "─",
        },
        style = "#6c6874",
      },
    }
  end,
}
