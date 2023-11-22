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
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

require("lazy").setup({
	spec = {
		require("user.core.resources.all"),
		require("user.plugins.trouble"),
		require("user.plugins.cmp"),
		require("user.plugins.copilot"),
		require("user.plugins.fzf"),
		require("user.plugins.telescope"),
		require("user.plugins.luasnip"),
		require("user.plugins.indent"),
		require("user.plugins.tmux"),
		require("user.plugins.treesitter"),
		require("user.plugins.surround"),
		require("user.plugins.devicons"),
		require("user.plugins.gitsings"),
		require("user.plugins.lualine"),
		require("user.plugins.which-key"),
		require("user.plugins.scrollbar"),
		require("user.plugins.git"),
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
