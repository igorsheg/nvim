local M = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

function M.config()
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
  keymap("n", "<leader>m", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
  keymap("n", "<leader>1", [[<cmd>lua require('harpoon.ui').nav_file(1)<CR>]], opts)
  keymap("n", "<leader>2", [[<cmd>lua require('harpoon.ui').nav_file(2)<CR>]], opts)
  keymap("n", "<leader>3", [[<cmd>lua require('harpoon.ui').nav_file(3)<CR>]], opts)
  keymap("n", "<leader>4", [[<cmd>lua require('harpoon.ui').nav_file(4)<CR>]], opts)
  keymap("n", "<leader>5", [[<cmd>lua require('harpoon.ui').nav_file(5)<CR>]], opts)
  vim.api.nvim_create_autocmd({ "filetype" }, {
    pattern = "harpoon",
    callback = function()
      vim.cmd [[highlight link HarpoonBorder TelescopeBorder]]
      -- vim.cmd [[setlocal nonumber]]
      -- vim.cmd [[highlight HarpoonWindow guibg=#313132]]
    end,
  })
end

function M.mark_file()
  require("harpoon.mark").add_file()
  vim.notify "󱡅  marked file"
end

return M
