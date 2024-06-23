return {
  "dnlhc/glance.nvim",
  cmd = { "Glance" },
  config = function()
    local actions = require("glance").actions

    require("glance").setup {
      height = 20,
      border = {
        enable = true,
        top_char = "─",
        bottom_char = "─",
      },
      list = {
        position = "right", -- Position of the list window 'left'|'right'
        width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
      },
      theme = {
        enable = true, -- Will generate colors for the plugin based on your current colorscheme
        mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
      },
      mappings = {
        list = {
          ["j"] = actions.next,
          ["k"] = actions.previous,
          ["<Down>"] = actions.next,
          ["<Up>"] = actions.previous,
          ["<Tab>"] = actions.next_location,
          ["<S-Tab>"] = actions.previous_location,
          ["<C-u>"] = actions.preview_scroll_win(5),
          ["<C-d>"] = actions.preview_scroll_win(-5),
          ["v"] = actions.jump_vsplit,
          ["s"] = actions.jump_split,
          ["t"] = actions.jump_tab,
          ["<CR>"] = actions.jump,
          ["o"] = actions.jump,
          ["<D-Left>"] = actions.enter_win "preview",
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
        },
        preview = {
          ["Q"] = actions.close,
          ["<Tab>"] = actions.next_location,
          ["<S-Tab>"] = actions.previous_location,
          ["<D-Right>"] = actions.enter_win "list",
        },
      },
      hooks = {},
      folds = {
        -- fold_closed = "",
        -- fold_open = "",
        fold_closed = "·",
        fold_open = "+",
        folded = false,
      },
      indent_lines = {
        enable = true,
        icon = "│",
      },
      winbar = {
        enable = true,
      },
    }
  end,
}
