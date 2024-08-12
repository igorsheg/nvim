return {
  "echasnovski/mini.indentscope",
  event = "VeryLazy",
  version = false,
  opts = function(_, opts)
    opts.symbol = "┊"
    opts.options = { try_as_border = true }
    opts.draw = {
      delay = 0,
      animation = require('mini.indentscope').gen_animation.none(),
    }
  end
}
