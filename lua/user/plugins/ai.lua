return {
  "echasnovski/mini.ai",
  lazy = false,
  version = false,
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local ai = require "mini.ai"
    ai.setup {
      n_lines = 500,
      custom_textobjects = {
        ["="] = ai.gen_spec.treesitter {
          a = { "@assignment.lhs" },
          i = { "@assignment.rhs" },
        },
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        o = ai.gen_spec.treesitter {
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        },
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
      },
    }
  end,
}
