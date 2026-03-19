return {
  "webhooked/kanso.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanso").setup({
      background = { dark = "zen", light = "zen" },
      foreground = "default",
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      functionStyle = { bold = true },
      colors = {
        palette = {},
        theme = {
          -- Zenbones-inspired: lightness hierarchy, not hue.
          -- Color is reserved for diagnostics, diff, git (untouched kanso defaults).
          -- Font style (bold/italic) is the primary differentiator.
          -- One subtle warm accent for "data" elements on the cool #090E13 bg.
          zen = {
            syn = {
              -- Tier 1: Structural anchors — near fg, italic carries meaning
              keyword    = "#BEC2C0",
              statement  = "#BEC2C0",

              -- Tier 2: Functions — bold carries meaning, slightly below fg
              fun        = "#B2B6B4",

              -- Tier 3: Identifiers — plain, natural reading level
              identifier = "#A5A9A7",
              parameter  = "#A5A9A7",
              preproc    = "#A5A9A7",

              -- Tier 4: Data/literals — subtle sand warmth (hue ~35°, sat ~8%)
              -- The only non-neutral color in syntax; complements cool bg
              string     = "#9B9690",
              number     = "#9B9690",
              constant   = "#9B9690",
              regex      = "#96918C",
              special1   = "#96918C",
              special2   = "#96918C",
              special3   = "#96918C",

              -- Tier 5: Types — structural annotation, clearly recedes
              type       = "#7F8381",

              -- Tier 6: Scaffolding — operators, punctuation fade into structure
              operator   = "#6A6E6C",
              punct      = "#626664",

              -- Tier 7: Comments — lowest priority, italic keeps them readable
              comment    = "#535755",

              -- Fades away
              deprecated = "#535755",

              -- Variables follow the code flow, no override
              variable   = "NONE",
            },
          },
        },
      },
    })
    vim.cmd.colorscheme("kanso-zen")
  end,

  -- "oskarnurm/koda.nvim",
  -- "aikhe/fleur.nvim",
}
