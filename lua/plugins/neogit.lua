return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>gg",
        "<cmd>Neogit<cr>",
        desc = "Git",
      },
    },
    opts = {
      integrations = {
        diffview = false,
        telescope = false,
        fzf_lua = false,
      },
    },
  },
}
