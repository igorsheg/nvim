------------------
-- Rustaceanvim --
------------------
return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  lazy = false, -- This plugin is already lazy
  dependencies = "neovim/nvim-lspconfig",
  opts = {
    server = {
      on_attach = function(client, bufnr)
        local map = require("user.utils").local_map(bufnr)
        map("n", "<leader>la", "<cmd>RustLsp codeAction<CR>", "Perform code action")
        map("n", "go", "<cmd>RustLsp openCargo<CR>", "Go to cargo.toml")
        map("n", "<C-w>go", "<C-w>v<cmd>RustLsp openCargo<CR>", "Go to cargo.toml (in new window)")
        map("n", "<leader>le", "<cmd>RustLsp explainError<CR>", "Explain error")
        map("n", "<leader>lj", "<cmd>RustLsp moveItem down<CR>", "Move item down")
        map("n", "<leader>lk", "<cmd>RustLsp moveItem up<CR>", "Move item up")
        map("n", "<leader>dc", "<cmd>RustLsp debuggables last<CR>", "Debug")
        map("n", "<leader>ld", "<cmd>RustLsp renderDiagnostic<CR>", "Render idiagnostics")
      end,
      settings = {
        ["rust-analyzer"] = {
          files = {
            excludeDirs = { ".direnv", "node_modules", "target", "dist" },
          },
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          checkOnSave = { -- Add clippy lints for Rust.
            allFeatures = true,
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          local map = vim.keymap.set
          map("n", "<leader>la", "<cmd>RustLsp codeAction<CR>")
          map("n", "go", "<cmd>RustLsp openCargo<CR>")
          map("n", "<C-w>go", "<C-w>v<cmd>RustLsp openCargo<CR>")
          map("n", "<leader>le", "<cmd>RustLsp explainError<CR>")
          map("n", "<leader>lj", "<cmd>RustLsp moveItem down<CR>")
          map("n", "<leader>lk", "<cmd>RustLsp moveItem up<CR>")
          map("n", "<leader>dc", "<cmd>RustLsp debuggables last<CR>")
          map("n", "<leader>gl", "<cmd>RustLsp renderDiagnostic<CR>")
        end,
      },
      tools = {
        float_win_config = {
          border = "rounded",
        },
      },
    }
  end,
}
