return {
  {
    "echasnovski/mini.starter",
    event = "VimEnter",
    lazy = false,
    opts = function()
      local starter = require "mini.starter"
      return {
        items = {
          starter.sections.recent_files(5, true, true),
        },
        footer = "",
      }
    end,
  },
}
