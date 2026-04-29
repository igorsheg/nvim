vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
      },
      staticcheck = true,
    },
  },
})
