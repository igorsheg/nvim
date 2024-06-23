local M = {
  "windwp/nvim-autopairs",
  -- event = "InsertEnter",
}

M.config = function()
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if not ok then
    return
  end
  local Rule = require "nvim-autopairs.rule"

  autopairs.setup {
    -- map_char = {
    --   all = "(",
    --   tex = "{",
    -- },
    -- enable_check_bracket_line = false,
    check_ts = true,
    -- ts_config = {
    --   lua = { "string", "source" },
    --   javascript = { "string", "template_string" },
    --   java = false,
    -- },
    disable_filetype = {
      "neo-tree",
      "TelescopeResults",
      "query",
      "tsplayground",
      "lazy",
      "lsp-installer",
      "markdown",
      "mason",
      "txt",
      "dashboard",
      "alpha",
      "NvimTree",
      "undotree",
      "diff",
      "fugitive",
      "fugitiveblame",
      "Outline",
      "SidebarNvim",
      "packer",
      "lsp-installer",
      "TelescopePrompt",
      "help",
      "telescope",
      "lspinfo",
      "Trouble",
      "null-ls-info",
      "quickfix",
      "chadtree",
      "fzf",
      "NeogitStatus",
      "terminal",
      "console",
      "term://*",
      "Term://*",
      "toggleterm",
      "qf",
      "prompt",
      "noice",
      "",
    },
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
    enable_moveright = true,
    disable_in_macro = false,
    enable_afterquote = true,
    map_bs = true,
    map_c_w = false,
    disable_in_visualblock = false,
  }
  -- autopairs.add_rules {
  --   Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
  --     :use_regex(true)
  --     :set_end_pair_length(2),
  -- }
end

return M
