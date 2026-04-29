-- Bootstrap lazy.nvim and load plugin specs from lua/plugins/.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local result = vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }):wait()

  if result.code ~= 0 then
    error("Failed to install lazy.nvim:\n" .. (result.stderr or ""))
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },

  defaults = {
    lazy = true,
    version = false,
  },

  install = {
    missing = true,
    colorscheme = { "habamax" },
  },

  checker = {
    enabled = true,
    notify = false,
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  ui = {
    border = "rounded",
  },

  performance = {
    rtp = {
      -- Disable built-in plugins we are unlikely to use.
      -- Keep this short; add to it only when there is a reason.
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
