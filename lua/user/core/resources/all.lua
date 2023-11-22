return {
	-- ############# User Interface Configuration #############
	-- UI Display
	{ "LazyVim/LazyVim" },
	{
		"stevearc/dressing.nvim",
		config = function()
			require("user.config.dressing")
		end,
	},
	{
		"rockyzhang24/arctic.nvim",
		branch = "v2",
		dependencies = { "rktjmp/lush.nvim" },
	},

	-- UI enhancer
	{
		"SmiteshP/nvim-navic",
		config = function()
			require("user.config.navic")
		end,
	}, -- UI navigation
	{ "b0o/schemastore.nvim" },
	-- { "nvim-tree/nvim-web-devicons" }, -- Icon pack
	{ "MunifTanjim/nui.nvim" }, -- Icon pack
	{ "rcarriga/nvim-notify" },
	{
		"stevearc/oil.nvim",
		-- Optional dependencies
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			require("user.config.oil")
		end,
	},
	-- Statusline
	-- {
	-- 	"nvim-lualine/lualine.nvim",
	-- 	config = function()
	-- 		require("user.config.lualine")
	-- 	end,
	-- },

	-- Buffer management
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	config = function()
	-- 		require("user.config.bufferline")
	-- 	end,
	-- },
	{
		"echasnovski/mini.bufremove",
		version = false,
		opts = function()
			require("mini.bufremove").setup()
		end,
	},

	-- Start screen
	{
		"goolord/alpha-nvim",
		config = function()
			require("user.config.alpha")
		end,
	},

	-- Indentation
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	config = function()
	-- 		require("ibl").setup({
	-- 			debounce = 100,
	-- 			indent = { char = "│" },
	-- 			whitespace = { highlight = { "Whitespace", "NonText" } },
	-- 		})
	-- 	end,
	-- },

	-- ############# Tools Configuration #############

	-- TMUX integration
	-- {
	-- 	"aserowy/tmux.nvim",
	-- 	config = function()
	-- 		require("user.config.tmux")
	-- 	end,
	-- },


	-- File Management
	-- {
	-- 	"nvim-telescope/telescope.nvim",
	-- 	dependencies = {
	-- 		"nvim-telescope/telescope-fzf-native.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		build = "make",
	-- 		config = function()
	-- 			require("telescope").load_extension("fzf")
	-- 			require("user.config.navic")
	-- 			-- require("user.config.telescope")
	-- 		end,
	-- 	},
	-- },
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("user.config.harpoon")
		end,
	},

	-- ############# Syntax & Language Server Configuration #############

	-- Syntax
	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	build = ":TSUpdate",
	-- 	config = function()
	-- 		require("user.config.treesitter")
	-- 	end,
	-- },
	{
		"windwp/nvim-autopairs",
		config = function()
			require("user.config.autopairs")
		end,
	}, -- autopair brackets and parenthesis

	-- {
	-- 	"kylechui/nvim-surround",
	-- 	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("nvim-surround").setup({
	-- 			-- Configuration here, or leave empty to use defaults
	-- 		})
	-- 	end
	-- },
	-- LSP
	--
	-- LSP Base
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		},
		servers = nil,
	},
	-- {
	--   "L3MON4D3/LuaSnip",
	--   version = "v2.1.0", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	--   config = function()
	--     require("luasnip.loaders.from_vscode").lazy_load()
	--   end,
	-- },
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},                                    -- LSP, dap, debugger installer
	{ "jose-elias-alvarez/null-ls.nvim" }, -- LSP diagnostics and code actions
	{
		"dnlhc/glance.nvim",
		config = function()
			require("user.config.glance")
		end,
	}, -- LSP diagnostics and code actions

	-- Language Server
	{ "simrat39/rust-tools.nvim",       dependencies = "nvim-lspconfig", ft = "rust", event = "VeryLazy" }, -- Rust
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	-- ############# Git Integration #############

	-- Git
	-- "tpope/vim-fugitive", -- git commands on nvim
	-- {
	-- 	"lewis6991/gitsigns.nvim",
	-- 	config = function()
	-- 		require("user.config.gitsigns")
	-- 	end,
	-- }, -- git diff on the side

	-- ############# Functionalities #############
	--

	{ "folke/trouble.nvim" }, -- Error list & workspace diagnostics
	{
		"numToStr/Comment.nvim",
		config = function()
			require("user.config.comment")
		end,
	}, -- fast code comment
	{
		"RRethy/vim-illuminate",
		config = function()
			require("user.config.illuminate")
		end,
	}, -- Highlight occurrences of the word under the cursor

	-- Other plugins
	{
		"j-hui/fidget.nvim",
		branch = "legacy",
		config = function()
			require("fidget").setup()
		end,
	},
	{ "onsails/lspkind-nvim" },
	-- { "tzachar/cmp-tabnine" },
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	config = function()
	-- 		require("user.config.copilot")
	-- 	end,
	-- },
	-- { "zbirenbaum/copilot-cmp" },
	-- {
	-- 	"robitx/gp.nvim",
	-- 	config = function()
	-- 		require("gp").setup()
	-- 	end,
	-- },
	{ "dnlhc/glance.nvim" },
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("user.config.nvimtree")
		end,
	},
}
