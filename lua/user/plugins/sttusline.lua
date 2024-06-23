return {
  "sontungexpt/sttusline",
  branch = "table_version",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = { "BufEnter" },
  config = function(_, opts)
    require("sttusline").setup {
      statusline_color = "None",
      components = {
        "mode",
        "filename",
        "git-branch",
        "git-diff",
        "%=",
        "diagnostics",
        "lsps-formatters",
      },
    }
  end,
}
