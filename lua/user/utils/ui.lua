local M = {}

M.ui.palette = {
  green = "#98c379",
  dark_green = "#10B981",
  blue = "#82AAFE",
  dark_blue = "#4e88ff",
  bright_blue = "#51afef",
  teal = "#15AABF",
  pale_pink = "#b490c0",
  magenta = "#c678dd",
  pale_red = "#E06C75",
  light_red = "#c43e1f",
  dark_red = "#be5046",
  dark_orange = "#FF922B",
  bright_yellow = "#FAB005",
  light_yellow = "#e5c07b",
  whitesmoke = "#9E9E9E",
  light_gray = "#626262",
  comment_grey = "#5c6370",
  grey = "#3E4556",
}

M.ui.border = {
  line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
  rectangle = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
}

M.ui.icons = {
  separators = {
    left_thin_block = "▏",
    right_thin_block = "▕",
    vert_bottom_half_block = "▄",
    vert_top_half_block = "▀",
    right_block = "🮉",
    light_shade_block = "░",
  },
  lsp = {
    error = "", -- '✗'
    warn = "", -- 
    info = "󰋼", --  ℹ 󰙎 
    hint = "󰌶", --  ⚑
  },
  git = {
    add = "", -- '',
    mod = "",
    remove = "", -- '',
    ignore = "",
    rename = "",
    untracked = "",
    ignored = "",
    unstaged = "󰄱",
    staged = "",
    conflict = "",
    diff = "",
    repo = "",
    logo = "󰊢",
    branch = "",
  },
  documents = {
    file = "",
    files = "",
    folder = "",
    open_folder = "",
  },
  misc = {
    -- 
    plus = "",
    ellipsis = "…",
    up = "⇡",
    down = "⇣",
    line = "", -- 'ℓ'
    indent = "Ξ",
    tab = "⇥",
    bug = "", --  '󰠭'
    question = "",
    clock = "",
    lock = "",
    shaded_lock = "",
    circle = "",
    project = "",
    dashboard = "",
    history = "󰄉",
    comment = "󰅺",
    robot = "󰚩",
    lightbulb = "󰌵",
    search = "󰍉",
    code = "",
    telescope = "",
    gear = "",
    package = "",
    list = "",
    sign_in = "",
    check = "󰄬",
    fire = "",
    note = "󰎞",
    bookmark = "",
    pencil = "", -- '󰏫',
    tools = "",
    arrow_right = "",
    caret_right = "",
    chevron_right = "",
    double_chevron_right = "»",
    table = "",
    calendar = "",
    block = "▌",
  },
}
