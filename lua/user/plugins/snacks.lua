return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  keys = {
    {
      "<leader>o",
      function()
        Snacks.picker.recent()
      end,
      mode = { "n" },
      desc = "Fuzzy Find Recent Files",
    },
    {
      "<leader>b",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>F",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>f",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "<space>lW",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<space>c",
      function()
        Snacks.bufdelete()
      end,
      desc = "Diagnostics",
    },
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
  },
  ---@class snacks.picker.Config
  opts = {
    picker = {
      layouts = {
        default = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.3,
            border = "top",
            title = " {source} {live}",
            title_pos = "left",
            { win = "input", height = 1, border = "bottom" },
            {
              box = "horizontal",
              { win = "list", border = "none" },
              { win = "preview", width = 0.6, border = "left" },
            },
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
    gitbrowse = {},
    dashboard = {
      sections = {
        { section = "header" },
        { title = "Recent Files", section = "recent_files", indent = 0, padding = 0 },
      },
    },
    indent = {},
    scope = {},
    words = {},
    terminal = {},
  },
}
