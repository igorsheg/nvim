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
    require "user.plugins.devicons",
    require "user.plugins.colorscheme",
    require "user.plugins.ai",
    require "user.plugins.surround",
    require "user.plugins.conform",
    require "user.plugins.blink",
    require "user.plugins.lsp",
    require "user.plugins.mason",
    require "user.plugins.neotree",
    require "user.plugins.tmux",
    require "user.plugins.treesitter",
    require "user.plugins.auto-pairs",
    require "user.plugins.gitsings",
    require "user.plugins.hipatterns",
    require "user.plugins.lualine",
    require "user.plugins.schemastore",
    require "user.plugins.comment",
    require "user.plugins.grapple",
    require "user.plugins.fidget",
    require "user.plugins.ufo",
    require "user.plugins.mini-jump",
    require "user.plugins.snacks",
    require "user.plugins.neotree",
    require "user.plugins.lsp-signature",
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
