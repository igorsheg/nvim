require("bufferline").setup({
  options = {
    indicator = {
      style = "icon",
      icon = " ",
    },
    modified_icon = "●",
    offsets = { { filetype = "NvimTree", text = "EXPLORER", text_align = "center" } },
    show_close_icon = false,
    show_tab_indicators = true,
    separator_style = "thin",
  },
})
