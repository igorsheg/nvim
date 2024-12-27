---@param require_path string
---@return table<string, fun(...): any>
local function reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        return require(require_path)[k](...)
      end
    end,
  })
end

local fzf_lua = reqcall "fzf-lua"

local function title(str, icon, icon_hl)
  return { { " " }, { (icon or ""), icon_hl or "DevIconDefault" }, { " " }, { str, "Bold" }, { " " } }
end
local function ivy(opts, ...)
  opts = opts or {}
  opts["winopts"] = opts.winopts or {}
  opts.winopts.preview = opts.winopts.preview or {}

  return vim.tbl_deep_extend("force", {
    prompt = "> ",
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      title_pos = opts["winopts"].title and "center" or nil,
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

local function file_picker(opts_or_cwd)
  if type(opts_or_cwd) == "table" then
    fzf_lua.files(ivy(opts_or_cwd))
  else
    fzf_lua.files(ivy { cwd = opts_or_cwd })
  end
end

local function dropdown(opts, ...)
  -- dd(I(opts))
  opts = opts or {}
  opts["winopts"] = opts.winopts or {}

  return vim.tbl_deep_extend("force", {
    prompt = ">",
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      title_pos = opts["winopts"].title and "center" or nil,
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
        require("fzf-lua").live_grep()
      end,
    },
    {
      "<leader>f",
      file_picker,
    },
    { "<leader>A", fzf_lua.grep_cword, desc = "grep (under cursor)" },
    {
      "<leader>n",
      function()
        file_picker "~/workspace/notes"
      end,
      desc = "dotfiles",
    },
    { "<leader>o", fzf_lua.oldfiles, desc = "oldfiles" },
    {
      "<leader>,",
      function()
        require("fzf-lua").resume()
      end,
    },
  },
  config = function()
    local fzf = require "fzf-lua"

    local delta_syntax_theme = {
      ["dark"] = "Dracula",
      ["light"] = "GitHub",
    }

    local preview_pager = table.concat({
      "delta",
      "--syntax-theme",
      delta_syntax_theme[vim.o.background],
      "--line-numbers",
      "--side-by-side",
      "--hunk-header-style='omit'",
      "--file-style='omit'",
    }, " ")

    local actions = require "fzf-lua.actions"

    local function toggle_preview_and_height(selected, opts)
      -- Get the current window
      local win = vim.api.nvim_get_current_win()
      local current_height = vim.api.nvim_win_get_height(win)

      -- Toggle preview
      actions.toggle_preview(selected, opts)

      -- Get the window again as it might have changed
      win = vim.api.nvim_get_current_win()

      -- Calculate new height based on current preview state
      local new_height
      if vim.w[win].preview_hidden then
        new_height = math.floor(vim.o.lines * 0.3)
      else
        new_height = math.floor(vim.o.lines * 0.5)
      end

      -- Set the new height
      vim.api.nvim_win_set_height(win, new_height)
    end

    local function hl_match(t)
      for _, h in ipairs(t) do
        local ok, hl = pcall(vim.api.nvim_get_hl_by_name, h, true)
        -- must have at least bg or fg, otherwise this returns
        -- succesffully for cleared highlights (on colorscheme switch)
        if ok and (hl.foreground or hl.background) then
          return h
        end
      end
    end

    require("fzf-lua").setup {
      defaults = {
        file_icons = false,
        git_icons = false, -- show git icons?
      },
      fzf_opts = {
        ["--info"] = "default", -- hidden OR inline:⏐
        ["--reverse"] = false,
        ["--layout"] = "reverse", -- "default" or "reverse"
        ["--scrollbar"] = "▓",
        ["--ellipsis"] = "...",
      },
      fzf_colors = {
        -- ["fg"] = { "fg", "TelescopeNormal" },
        -- ["fg+"] = { "fg", "TelescopeNormal" },
        -- ["bg"] = { "bg", "TelescopeNormal" },
        ["bg+"] = { "bg", hl_match { "CursorLine" } },
        ["hl"] = { "fg", hl_match { "Directory" } },
        ["hl+"] = { "fg", "CmpItemKindVariable", "italic" },
        ["info"] = { "fg", hl_match { "FzfLuaInfo" } },
        ["prompt"] = { "fg", hl_match { "FzfLuaPrompt" }, "italic" },
        -- ["pointer"] = { "fg", "DiagnosticError" },
        -- ["marker"] = { "fg", "DiagnosticError" },
        -- ["spinner"] = { "fg", "Label" },
        -- ["header"] = { "bg", hl_match { "TelescopeTitle" } },
        -- ["border"] = { "fg", "TelescopeBorder" },
        ["gutter"] = { "bg", hl_match { "TelescopePromptPrefix" } },
        ["separator"] = { "fg", hl_match { "FzfLuaSeparator" } },

        -- ["bg"] = { "bg", "TelescopeNormal" },
        -- ["bg+"] = { "bg", "CursorLine" },
        -- ["fg"] = { "fg", "Comment" },
        -- ["fg+"] = { "fg", "TelescopeNormal" },
        -- ["hl"] = { "fg", "CmpItemAbbrMatch" },
        -- ["hl+"] = { "fg", "CmpItemAbbrMatch" },
        -- ["gutter"] = { "bg", "TelescopeNormal" },
        ["header"] = { "fg", "NonText" },
        -- ["info"] = { "fg", "NonText" },
        ["pointer"] = { "bg", "Cursor" },
        -- ["separator"] = { "bg", "TelescopeNormal" },
        -- ["spinner"] = { "fg", "NonText" },
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
          syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
          syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
          limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
          extensions = {
            -- or, this is known to work: { "viu", "-t" }
            ["gif"] = { "chafa", "-c", "full" },
            ["jpg"] = { "chafa", "-c", "full" },
            ["jpeg"] = { "chafa", "-c", "full" },
            ["png"] = { "chafa", "-c", "full" },
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
        winopts = { title = title "files" },
        -- previewer = "builtin",
        -- action = { ["ctrl-r"] = fzf.actions.arg_add },
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
      grep = ivy {
        multiprocess = true,
        prompt = " ",
        winopts = { title = title "grep" },
        rg_opts = "--hidden --column --line-number --no-ignore-vcs --no-heading --color=always --smart-case -g '!.git'",
        rg_glob = true, -- enable glob parsing by default to all
        glob_flag = "--iglob", -- for case sensitive globs use '--glob'
        glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
        actions = { ["ctrl-g"] = fzf.actions.grep_lgrep },
        rg_glob_fn = function(query, opts)
          -- this enables all `rg` arguments to be passed in after the `--` glob separator
          local search_query, glob_str = query:match("(.*)" .. opts.glob_separator .. "(.*)")
          local glob_args = glob_str:gsub("^%s+", ""):gsub("-", "%-") .. " "

          return search_query, glob_args
        end,
        -- previewer = "builtin",
        -- fzf_opts = {
        --   ["--keep-right"] = "",
        -- },
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
    fzf.register_ui_select(ivy {
      winopts = {
        preview = { hidden = "hidden", layout = "flex" },
      },
    })
  end,
}
