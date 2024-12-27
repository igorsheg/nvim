return {
  "saghen/blink.cmp",
  event = "BufReadPre",
  version = "v0.*", -- REQUIRED release tag to download pre-built binaries

  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    sources = {
      providers = {
        { "blink.cmp.sources.lsp", name = "LSP" },
        {
          "blink.cmp.sources.snippets",
          name = "Snippets",
          score_offset = -1,
          -- keyword_length = 1, -- not supported yet
        },
        {
          "blink.cmp.sources.path",
          name = "Path",
          score_offset = 3,
          opts = { get_cwd = vim.uv.cwd },
        },
        {
          "blink.cmp.sources.buffer",
          name = "Buffer",
          keyword_length = 3,
          fallback_for = { "Path" }, -- PENDING https://github.com/Saghen/blink.cmp/issues/122
        },
      },
    },
    trigger = {
      completion = {
        keyword_range = "full", -- full|prefix
      },
    },

    keymap = {
      show = "<D-c>",
      hide = "<S-CR>",
      accept = "<CR>",
      select_next = { "<C-j>" },
      select_prev = { "<C-k>" },
      scroll_documentation_down = "<PageDown>",
      scroll_documentation_up = "<PageUp>",
    },
    signature = { enabled = true },
    accept = {
      auto_brackets = {
        -- Whether to auto-insert brackets for functions
        enabled = true,
        -- Default brackets to use for unknown languages
        default_brackets = { "(", ")" },
        -- Overrides the default blocked filetypes
        override_brackets_for_filetypes = { "rust", "elixir", "heex", "lua" },
        -- Synchronously use the kind of the item to determine if brackets should be added
        kind_resolution = {
          enabled = true,
          blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
        },
        -- Asynchronously use semantic token to determine if brackets should be added
        semantic_token_resolution = {
          enabled = true,
          blocked_filetypes = {},
          -- How long to wait for semantic tokens to return before assuming no brackets should be added
          timeout_ms = 400,
        },
      },
    },
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    nerd_font_variant = "mono",
    windows = {
      documentation = {
        min_width = 15,
        max_width = 50,
        max_height = 15,
        border = vim.g.borderStyle,
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      autocomplete = {
        min_width = 10,
        max_height = 10,
        border = vim.g.borderStyle,
        -- selection = "auto_insert", -- PENDING https://github.com/Saghen/blink.cmp/issues/117
        selection = "preselect",
        cycle = { from_top = false }, -- cycle at bottom, but not at the top
        draw = function(ctx)
          -- https://github.com/Saghen/blink.cmp/blob/819b978328b244fc124cfcd74661b2a7f4259f4f/lua/blink/cmp/windows/autocomplete.lua#L285-L349
          -- differentiate LSP snippets from user snippets and emmet snippets
          local icon, source = ctx.kind_icon, ctx.item.source
          local client = source == "LSP" and vim.lsp.get_client_by_id(ctx.item.client_id).name
          if source == "Snippets" or (client == "basics_ls" and ctx.kind == "Snippet") then
            icon = "󰩫"
          elseif source == "Buffer" or (client == "basics_ls" and ctx.kind == "Text") then
            icon = "󰦨"
          elseif client == "emmet_language_server" then
            icon = "󰯸"
          end

          -- FIX highlight for Tokyonight
          local iconHl = vim.g.colors_name:find "tokyonight" and "BlinkCmpKind" or "BlinkCmpKind" .. ctx.kind

          return {
            {
              " " .. ctx.item.label .. " ",
              fill = true,
              hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
              max_width = 45,
            },
            { icon .. ctx.icon_gap, hl_group = iconHl },
          }
        end,
      },
    },
    kind_icons = {
      Text = "",
      Method = "󰊕",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "⬟",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "󰒕",
      Color = "󰏘",
      Reference = "",
      File = "󰉋",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    },
  },
}
