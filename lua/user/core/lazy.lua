-- Initialize and configure the path for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  print("lazy just installed, please restart neovim")
  return
end

lazy.setup({
  spec = {
    require("user.plugins.alpha"),
    require("user.plugins.oil"),
    require("user.plugins.conform"),
    require("user.plugins.primer-dark"),
    require("user.plugins.dressing"),
    require("user.plugins.navic"),
    require("user.plugins.illuminate"),
    require("user.plugins.trouble"),
    require("user.plugins.cmp"),
    require("user.plugins.copilot"),
    require("user.plugins.lspconfig"),
    require("user.plugins.nvimtree"),
    require("user.plugins.telescope"),
    require("user.plugins.luasnip"),
    require("user.plugins.indent"),
    require("user.plugins.tmux"),
    require("user.plugins.treesitter"),
    require("user.plugins.surround"),
    require("user.plugins.auto-pairs"),
    require("user.plugins.devicons"),
    require("user.plugins.gitsings"),
    require("user.plugins.lualine"),
    require("user.plugins.which-key"),
    require("user.plugins.scrollbar"),
    require("user.plugins.git"),
    require("user.plugins.bufferline"),
    require("user.plugins.schemastore"),
    require("user.plugins.ts-tools"),
    require("user.plugins.mason"),
    require("user.plugins.comment"),
    require("user.plugins.toggleterm"),
    require("user.plugins.diffview"),
    require("user.plugins.harpoon"),
    require("user.plugins.bfdelete"),
    require("user.plugins.fidget"),
  },
  install = {
    colorscheme = { "primer_dark" },
  },
  ui = {
    border = "rounded",
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      -- disable some rtp plugins
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

  { "LazyVim/LazyVim" },
})
