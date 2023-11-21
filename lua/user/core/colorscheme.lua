vim.g.colorscheme = 'arctic'
vim.g.transparent = true
vim.g.border_enabled = true
vim.g.border_style = vim.g.border_enabled and 'rounded' or 'none'
--
--
vim.o.termguicolors = true
vim.o.background = 'dark'
--
-- if vim.g.transparent then
--   vim.api.nvim_create_augroup('CleanBackground', { clear = true })
--   vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
--     group = 'CleanBackground',
--     pattern = '*',
--     callback = function()
--       vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
--     end,
--   })
-- end

vim.cmd('colorscheme ' .. vim.g.colorscheme)
