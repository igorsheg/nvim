local g = vim.g
local M = {
  "skywind3000/asyncrun.vim",
}

function M.config()
  g.asyncrun_rootmarks = { "pom.xml", ".git", ".svn", ".root", ".project", ".hg", "package.json" }
end

return M
