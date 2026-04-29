vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
        importModuleSpecifierEnding = "minimal",
        includePackageJsonAutoImports = "auto",
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        providePrefixAndSuffixTextForRename = true,
        useAliasesForRenames = true,
      },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = false },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    javascript = {
      preferences = {
        importModuleSpecifier = "non-relative",
      },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = false },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = false },
      },
    },
  },
})
