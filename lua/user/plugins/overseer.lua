local M = {}

function M.task_template()
  return {
    name = "Yarn Build (Package Root)",
    builder = function(params)
      -- Find the nearest package.json
      local package_json_path = vim.fn.findfile("package.json", vim.fn.expand "%:p:h" .. ";")
      if package_json_path == "" then
        print "package.json not found"
        return nil
      end

      -- Set the working directory to the directory of package.json
      local cwd = vim.fn.fnamemodify(package_json_path, ":h")

      return {
        cmd = { "yarn", "build" },
        cwd = cwd,
        name = "Yarn Build",
        components = { "default" },
      }
    end,
    desc = "Runs yarn build in the project root directory",
    tags = { "build" },
  }
end

--------------
-- Overseer --
--------------
return {
  "stevearc/overseer.nvim",
  keys = {
    { "<leader>o", "<cmd>OverseerOpen<CR>", desc = "Overseer" },
  },
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerClearCache",
  },
  opts = {
    -- Template modules to load
    templates = { "builtin", "npm", M.task_template() },
    task_list = {
      bindings = {
        ["{"] = "DecreaseWidth",
        ["}"] = "IncreaseWidth",
        ["["] = "PrevTask",
        ["]"] = "NextTask",
      },
    },
  },
}
