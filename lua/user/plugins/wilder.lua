local config = function()
  require("wilder").setup {
    modes = { ":", "/", "?" },
    next_key = "<Tab>",
    prev_key = "<S-Tab>",
    accept_key = "<Down>",
    reject_key = "<Up>",
    use_vim_remote_plugin = false,
    num_workers = 4,
  }

  vim.cmd [[
  cmap <expr> <C-j> wilder#in_context() ? wilder#next() : "\<C-j>"
  cmap <expr> <C-k> wilder#in_context() ? wilder#previous() : "\<C-k>"
  cmap <expr> <C-n> wilder#in_context() ? wilder#next() : "\<C-n>"
  cmap <expr> <C-p> wilder#in_context() ? wilder#previous() : "\<C-p>"
]]
  local wilder = require "wilder"
  wilder.set_option(
    "renderer",
    wilder.popupmenu_renderer {
      -- highlighter applies highlighting to the candidates
      highlighter = wilder.basic_highlighter(),
    }
  )
end

return {
  "gelguy/wilder.nvim",
  config = config,
  event = "CmdlineEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- {
    "romgrk/fzy-lua-native",
    -- 	build = "make",
    -- },
  },
}
