local icons = require("core.icons")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "nvim-mini/mini.icons",
        opts = {
          style = icons.style,
        },
        config = function(_, opts)
          require("mini.icons").setup(opts)
          MiniIcons.mock_nvim_web_devicons()
        end,
      },
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree toggle reveal left<cr>",
        desc = "Explorer",
      },
    },
    opts = {
      default_component_configs = {
        indent = {
          expander_collapsed = icons.tree.collapsed,
          expander_expanded = icons.tree.expanded,
        },
        icon = {
          folder_closed = icons.files.folder_closed,
          folder_open = icons.files.folder_open,
          folder_empty = icons.files.folder_empty,
          default = icons.files.default,
        },
        git_status = {
          symbols = icons.git,
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 32,
      },
    },
  },
}
