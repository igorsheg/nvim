local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = {
    require "user.plugins.colorschemes.arctic",
    require "user.plugins.ai",
    require "user.plugins.mini-starter",
    require "user.plugins.incline",
    require "user.plugins.illuminate",
    require "user.plugins.trouble",
    require "user.plugins.surround",
    require "user.plugins.neogit",
    require "user.plugins.toggleterm",
    require "user.plugins.conform",
    require "user.plugins.navic",
    require "user.plugins.cmp",
    require "user.plugins.lsp",
    require "user.plugins.mason",
    require "user.plugins.rustaceanvim",
    require "user.plugins.lsp-signature",
    require "user.plugins.neotree",
    require "user.plugins.telescope",
    require "user.plugins.indent",
    require "user.plugins.tmux",
    require "user.plugins.treesitter",
    require "user.plugins.auto-pairs",
    require "user.plugins.devicons",
    require "user.plugins.gitsings",
    require "user.plugins.lualine",
    require "user.plugins.schemastore",
    require "user.plugins.comment",
    require "user.plugins.todo-comments",
    require "user.plugins.diffview",
    require "user.plugins.grapple",
    require "user.plugins.bfdelete",
    require "user.plugins.fidget",
    require "user.plugins.ufo",
    require "user.plugins.zen",
    require "user.plugins.oil",
  },
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "vimballPlugin",
        "matchit",
        "matchparen",
        "2html_plugin",
        "tarPlugin",
        "netrwPlugin",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
