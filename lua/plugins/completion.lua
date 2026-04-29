local icons = require("core.icons")

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      appearance = {
        kind_icons = icons.kinds,
      },

      keymap = {
        preset = "default",

        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-h>"] = { "scroll_documentation_up", "fallback" },
        ["<C-l>"] = { "accept", "fallback" },
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
        },
      },

      cmdline = {
        keymap = {
          preset = "cmdline",

          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-l>"] = { "accept", "fallback" },
        },
        completion = {
          menu = {
            auto_show = true,
            border = "rounded",
          },
          ghost_text = {
            enabled = true,
          },
        },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      sources = {
        default = { "lsp", "path", "buffer" },
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
    opts_extend = { "sources.default" },
  },
}
