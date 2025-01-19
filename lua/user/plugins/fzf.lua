--- Helper function to create functions that call methods of a required module.
---@param require_path string The path to the module to require.
---@return table<string, fun(...): any> A table where keys are method names and values are functions calling those methods.
local function create_module_caller(require_path)
  return setmetatable({}, {
    __index = function(_, method_name)
      return function(...)
        return require(require_path)[method_name](...)
      end
    end,
  })
end

local fzf_lua = create_module_caller "fzf-lua"

--- Creates a title row for the fzf-lua window.
---@param text string The title text.
---@param icon? string An optional icon to display.
---@param icon_highlight? string An optional highlight group for the icon.
---@return table The title definition for fzf-lua.
local function create_title(text, icon, icon_highlight)
  return { { " " }, { (icon or ""), icon_highlight or "DevIconDefault" }, { " " }, { text, "Bold" }, { " " } }
end

--- Configuration for Ivy-style fzf-lua windows.
---@param opts? table User-provided options.
---@vararg any Additional arguments passed to `vim.tbl_deep_extend`.
---@return table Merged options for fzf-lua.
local function ivy_style(opts, ...)
  opts = opts or {}
  opts.winopts = opts.winopts or {}
  opts.winopts.preview = opts.winopts.preview or {}

  return vim.tbl_deep_extend("force", {
    prompt = "> ",
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      title_pos = opts.winopts.title and "center" or nil,
      height = 0.35,
      width = 1.00,
      row = 1,
      col = 1,
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      preview = {
        layout = "flex",
        hidden = opts.winopts.preview.hidden or "nohidden",
        flip_columns = 130,
        scrollbar = "float",
        scrolloff = "-1",
        scrollchars = { "█", "░" },
      },
    },
  }, opts, ...)
end

--- Opens the file picker using fzf-lua.
---@param opts_or_cwd? string|table Either a directory path or a table of options.
local function open_file_picker(opts_or_cwd)
  local options = type(opts_or_cwd) == "table" and opts_or_cwd or { cwd = opts_or_cwd }
  fzf_lua.files(ivy_style(options))
end

--- Configuration for dropdown-style fzf-lua windows.
---@param opts? table User-provided options.
---@vararg any Additional arguments passed to `vim.tbl_deep_extend`.
---@return table Merged options for fzf-lua.
local function dropdown_style(opts, ...)
  opts = opts or {}
  opts.winopts = opts.winopts or {}

  return vim.tbl_deep_extend("force", {
    prompt = ">",
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      title_pos = opts.winopts.title and "center" or nil,
      height = 0.70,
      width = 0.45,
      row = 0.1,
      col = 0.5,
      preview = { hidden = "hidden", layout = "vertical", vertical = "up:50%" },
    },
  }, opts, ...)
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  lazy = false,
  keys = {
    {
      "<leader>F",
      function()
        fzf_lua.live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>f",
      open_file_picker,
      desc = "File Picker",
    },
    { "<leader>A", fzf_lua.grep_cword, desc = "Grep Current Word" },
    {
      "<leader>n",
      function()
        open_file_picker "~/workspace/notes"
      end,
      desc = "Open Notes",
    },
    { "<leader>o", fzf_lua.oldfiles, desc = "Open Recent Files" },
    {
      "<leader>,",
      function()
        fzf_lua.resume()
      end,
      desc = "Resume Last Fzf Action",
    },
  },
  config = function()
    local fzf = require "fzf-lua"
    local actions = require "fzf-lua.actions"

    local delta_syntax_themes = {
      dark = "Dracula",
      light = "GitHub",
    }
    local current_background = vim.o.background
    local delta_theme = delta_syntax_themes[current_background]

    local preview_pager_command = {
      "delta",
      "--syntax-theme",
      delta_theme,
      "--line-numbers",
      "--side-by-side",
      "--hunk-header-style='omit'",
      "--file-style='omit'",
    }
    local preview_pager = table.concat(preview_pager_command, " ")

    --- Toggles the preview window and adjusts the fzf window height.
    ---@param selected table The currently selected item (unused).
    ---@param opts table Fzf options.
    local function toggle_preview_and_resize(selected, opts)
      local win_id = vim.api.nvim_get_current_win()
      local current_height = vim.api.nvim_win_get_height(win_id)

      actions.toggle_preview(selected, opts)

      win_id = vim.api.nvim_get_current_win() -- Window might have changed
      local is_preview_hidden = vim.w[win_id].preview_hidden

      local new_height
      if is_preview_hidden then
        new_height = math.floor(vim.o.lines * 0.3)
      else
        new_height = math.floor(vim.o.lines * 0.5)
      end

      vim.api.nvim_win_set_height(win_id, new_height)
    end

    --- Finds the first valid highlight group from a list.
    ---@param highlight_groups string[] List of highlight group names.
    ---@return string? The first valid highlight group or nil.
    local function find_valid_highlight(highlight_groups)
      for _, group in ipairs(highlight_groups) do
        local success, hl_data = pcall(vim.api.nvim_get_hl_by_name, group, true)
        if success and (hl_data.foreground or hl_data.background) then
          return group
        end
      end
      return nil
    end

    require("fzf-lua").setup {
      defaults = {
        file_icons = false,
        git_icons = false,
      },
      fzf_opts = {
        ["--info"] = "default",
        ["--reverse"] = false,
        ["--layout"] = "reverse",
        ["--scrollbar"] = "▓",
        ["--ellipsis"] = "...",
      },
      fzf_colors = {
        ["bg+"] = { "bg", find_valid_highlight { "CursorLine" } },
        ["hl"] = { "fg", find_valid_highlight { "Directory" } },
        ["hl+"] = { "fg", "CmpItemKindVariable", "italic" },
        ["info"] = { "fg", find_valid_highlight { "FzfLuaInfo" } },
        ["prompt"] = { "fg", find_valid_highlight { "FzfLuaPrompt" }, "italic" },
        ["gutter"] = { "bg", find_valid_highlight { "TelescopePromptPrefix" } },
        ["separator"] = { "fg", find_valid_highlight { "FzfLuaSeparator" } },
        ["header"] = { "fg", "NonText" },
        ["pointer"] = { "bg", "Cursor" },
      },
      winopts = {
        title_pos = nil,
        height = 0.35,
        width = 1.00,
        row = 1,
        col = 1,
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
        hls = {
          border = "TelescopeBorder",
          header_bind = "NonText",
          header_text = "NonText",
          help_normal = "NonText",
          normal = "TelescopeNormal",
          preview_border = "TelescopePreviewBorder",
          preview_normal = "TelescopePreviewNormal",
          search = "CmpItemAbbrMatch",
          title = "TelescopeTitle",
        },
        preview = {
          layout = "flex",
          flip_columns = 130,
          scrollbar = "float",
          scrolloff = "-1",
          scrollchars = { "█", "░" },
        },
        on_create = function()
          vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
          vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
        end,
      },
      previewers = {
        builtin = {
          toggle_behavior = "extend",
          syntax_limit_l = 0,
          syntax_limit_b = 1024 * 1024,
          limit_b = 1024 * 1024 * 10,
          extensions = {
            gif = { "chafa", "-c", "full" },
            jpg = { "chafa", "-c", "full" },
            jpeg = { "chafa", "-c", "full" },
            png = { "chafa", "-c", "full" },
          },
        },
      },
      keymap = {
        builtin = {
          ["<C-y>"] = "toggle-preview",
          ["<c-=>"] = "toggle-fullscreen",
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-p"] = "toggle-preview",
          ["tab"] = "toggle-down",
          ["shift-tab"] = "toggle-up",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
        },
      },
      actions = {
        files = {
          ["default"] = actions.file_edit,
          ["ctrl-s"] = actions.file_split,
          ["ctrl-v"] = actions.file_vsplit,
        },
      },
      files = {
        multiprocess = true,
        prompt = ">",
        winopts = { title = create_title "files" },
      },
      buffers = {
        no_header = true,
      },
      git = {
        status = {
          preview_pager = preview_pager,
          no_header = true,
        },
      },
      grep = ivy_style {
        multiprocess = true,
        prompt = " ",
        winopts = { title = create_title "grep" },
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git'",
        rg_glob = true,
        glob_flag = "--iglob",
        glob_separator = "%s%-%-",
        actions = { ["ctrl-g"] = fzf.actions.grep_lgrep },
        rg_glob_fn = function(query, opts)
          local search_query, glob_str = query:match("(.*)" .. opts.glob_separator .. "(.*)")
          local glob_args = glob_str:gsub("^%s+", ""):gsub("-", "%-") .. " "
          return search_query, glob_args
        end,
      },
      lsp = {
        no_header = true,
        symbols = {
          symbol_icons = {
            File = " ",
            Module = " ",
            Namespace = " ",
            Package = " ",
            Class = " ",
            Method = " ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = " ",
            Interface = " ",
            Function = " ",
            Variable = " ",
            Constant = " ",
            String = " ",
            Number = " ",
            Boolean = " ",
            Array = " ",
            Object = " ",
            Key = " ",
            Null = "null ",
            EnumMember = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " ",
          },
        },
        code_actions = {
          previewer = "codeaction_native",
          preview_pager = preview_pager,
        },
      },
    }
    fzf.register_ui_select(ivy_style {
      winopts = {
        preview = { hidden = "hidden", layout = "flex" },
      },
    })
  end,
}
