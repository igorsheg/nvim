return {
  "ibhagwan/fzf-lua",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "aaronhallaert/advanced-git-search.nvim" },
  },
  keys = {
    {
      "<leader>fc",
      function()
        require("fzf-lua").commands()
      end,
      desc = "Search commands",
    },
    {
      "<leader>fC",
      function()
        require("fzf-lua").command_history()
      end,
      desc = "Search command history",
    },
    {
      "<leader>F",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>f",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fpd",
      function()
        local current_file_path = vim.fn.expand "%:p"
        local directory = vim.fn.fnamemodify(current_file_path, ":h")
        print(directory)

        require("fzf-lua").files {
          prompt = "< Navigation Bar >",
          cwd = directory,
        }
      end,
      desc = "Navigation bar",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").git_files()
      end,
      desc = "Find git files",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").highlights()
      end,
      desc = "Search highlights",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").registers()
      end,
      desc = "Search registers",
    },
    {
      "<leader>fM",
      function()
        require("fzf-lua").marks()
      end,
      desc = "Search marks",
    },
    {
      "<leader>fk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "Search keymaps",
    },
    {
      "<leader>ft",
      function()
        require("fzf-lua").treesitter()
      end,
      desc = "Search treesitter",
    },
    {
      "<leader>fgb",
      function()
        require("fzf-lua").git_branches()
      end,
      desc = "Search git branches",
    },
    {
      "<leader>fgc",
      function()
        require("fzf-lua").git_commits()
      end,
      desc = "Search git commits",
    },
    {
      "<leader>fgC",
      function()
        require("fzf-lua").git_bcommits()
      end,
      desc = "Search git buffer commits",
    },
    {
      "<leader>bc",
      function()
        require("fzf-lua").git_bcommits()
      end,
      desc = "Search git buffer commits",
    },
    {
      "<leader>bl",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Search buffers",
    },
    {
      "<leader>,",
      function()
        require("fzf-lua").resume()
      end,
      desc = "Resume FZF",
    },
    {
      "<leader>fgr",
      function()
        require("advanced_git_search.fzf.pickers").checkout_reflog()
      end,
      desc = "Git Search: Checkout Reflog",
    },
    {
      "<leader>fgdb",
      function()
        require("advanced_git_search.fzf.pickers").diff_branch_file()
      end,
      desc = "Git Search: Diff branch file",
    },
    {
      "<leader>fgdf",
      function()
        require("advanced_git_search.fzf.pickers").diff_commit_file()
      end,
      desc = "Git Search: Diff commit file",
    },
    {
      "<leader>fgdl",
      function()
        require("advanced_git_search.fzf.pickers").diff_commit_line()
      end,
      desc = "Git Search: Diff commit line",
    },
    {
      "<leader>fgl",
      function()
        require("advanced_git_search.fzf.pickers").search_log_content()
      end,
      desc = "Git Search: Log content",
    },
    {
      "<leader>fgL",
      function()
        require("advanced_git_search.fzf.pickers").search_log_content_file()
      end,
      desc = "Git Search: Log content file",
    },
  },
  config = function()
    local fzf_defaults = require("fzf-lua.defaults").defaults
    require("fzf-lua").setup {
      defaults = {
        -- Disable icons (speedup + it more resembles fzf in the shell).
        git_icons = false,
        file_icons = false,
      },
      keymap = {
        fzf = {
          ["CTRL-Q"] = "select-all+accept",
        },
      },
      winopts = {
        width = 0.90,
        height = 0.80,
        border = "single",
        preview = {
          -- Decrease the width of the preview window to have more available space
          -- for file names.
          horizontal = "right:50%",
        },
      },
      fzf_colors = {
        -- Use the same colors as I use in the shell version of fzf.
        ["hl"] = { "fg", "Statement" },
        ["hl+"] = { "fg", "Statement" },
      },
      grep = {
        -- 1) Make ripgrep search also in hidden files/directories when grepping.
        -- 2) Use the same colors as I have defined for grep, git grep, etc.
        rg_opts = '--hidden --colors "match:fg:0xff,0xff,0x60" --colors "match:bg:black" --colors "match:style:bold" '
          .. fzf_defaults.grep.rg_opts,
      },
      previewers = {
        builtin = {
          treesitter = {
            enable = true,
            -- Ensure that we use the same syntax-highlighters in the preview
            -- window as in regular buffers (the list of filetypes needs to
            -- be synced between fzf-lua and nvim-treesitter).
            disable = vim.g.s3rvac_disable_treesitter_highlight_for_filetypes,
          },
        },
      },
    }
    -- require("fzf-lua").register_ui_select()
    require("fzf-lua").register_ui_select(function(_, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return { winopts = { height = h, width = 0.60, row = 0.40 } }
    end)
    require("advanced_git_search.fzf").setup {}
  end,
}
