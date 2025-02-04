return {
  "saghen/blink.cmp",
  version = "v0.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  opts = {
    keymap = {
      preset = "default",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-p>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      accept = {
        create_undo_point = true,
        auto_brackets = {
          enabled = true,
          kind_resolution = {
            enabled = true,
            blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
          },
          semantic_token_resolution = {
            enabled = true,
            timeout_ms = 200,
          },
        },
      },
      documentation = {
        auto_show_delay_ms = 0,
        auto_show = true,
        window = { border = "single" },
      },
      trigger = {
        show_on_insert_on_trigger_character = true,
        -- these are annoying
        show_on_x_blocked_trigger_characters = { "'", '"', "(", "[", "{" },
      },
      menu = {
        border = "single",
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
    },
    signature = {
      enabled = true,
      window = { border = "single" },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      cmdline = {},
    },
  },
  opts_extend = { "sources.default" },
}
