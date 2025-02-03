local M = {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    "luukvbaal/statuscol.nvim",
  },
}

function M.config()
  local statuscol = require "statuscol"
  local builtin = require "statuscol.builtin"
  local ufo = require "ufo"

  -- Configure status column
  statuscol.setup {
    setopt = true,
    relculright = true,
    segments = {
      { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa", hl = "Comment" },
      { text = { "%s" }, click = "v:lua.ScSa" },
      { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
    },
  }

  -- Fold options
  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"

  -- Virtual text handler for folds
  local function virtTextHandler(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" 󰡏 %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local text = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(text)
      if curWidth + chunkWidth < targetWidth then
        table.insert(newVirtText, chunk)
      else
        text = truncate(text, targetWidth - curWidth)
        table.insert(newVirtText, { text, chunk[2] })
        if curWidth + vim.fn.strdisplaywidth(text) < targetWidth then
          suffix = suffix .. string.rep(" ", targetWidth - curWidth - vim.fn.strdisplaywidth(text))
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
  end

  local ftMap = {} -- Extend this table for filetype-specific providers if needed

  ufo.setup {
    fold_virt_text_handler = virtTextHandler,
    close_fold_kinds_for_ft = { default = { "imports" } },
    provider_selector = function(_, filetype)
      return ftMap[filetype]
    end,
    preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        winhighlight = "Normal:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-k>",
        scrollD = "<C-j>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },
  }

  -- Key mappings for fold operations
  vim.keymap.set("n", "zR", ufo.openAllFolds)
  vim.keymap.set("n", "zM", ufo.closeAllFolds)
  vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
  vim.keymap.set("n", "zm", ufo.closeFoldsWith)
  vim.keymap.set("n", "K", function()
    local winid = ufo.peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end)
end

return M
