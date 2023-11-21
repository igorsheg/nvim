vim.loader.enable()

require("user.core.options")
require("user.core.lazy")
require("user.core.keymaps")
require("user.core.colorscheme")
require("user.core.autocmds")

vim.defer_fn(function()
  require("user.lsp.lspconfig")
  require("user.lsp.null-ls")
  vim.cmd([[doautocmd User ConfigLoaded]])
end, 0)
