return {
  {
    "user/web-bookmarks.nvim",
    dir = vim.fn.stdpath("config"),
    keys = {
      {
        "<leader>ab",
        function()
          require("local.libs.web_bookmarks").open()
        end,
        desc = "Open bookmarks",
      },
    },
    cmd = { "OpenBookmarks" },
    config = function()
      vim.api.nvim_create_user_command("OpenBookmarks", function()
        require("local.libs.web_bookmarks").open()
      end, {})
    end,
  },
}
