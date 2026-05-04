local M = {}

-- Expands outward from cursor to extract a full filename token.
-- Handles: astrocore, astrocore.lua, lua/plugins/astrocore.lua, astrocore.lua:42
function M.get_cursor_token()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based

  if col > #line or line == "" then return "" end

  local function is_name_char(c) return c:match("[%w%.%-%_/]") ~= nil end

  -- Expand left
  local s = col
  while s > 1 and is_name_char(line:sub(s - 1, s - 1)) do
    s = s - 1
  end

  -- Expand right, also capture trailing :42 line number
  local e = col
  while e < #line and is_name_char(line:sub(e + 1, e + 1)) do
    e = e + 1
  end
  if e < #line and line:sub(e + 1, e + 1) == ":" and line:sub(e + 2, e + 2):match("%d") then
    e = e + 1
    while e < #line and line:sub(e + 1, e + 1):match("%d") do
      e = e + 1
    end
  end

  local token = line:sub(s, e)
  return token:match("%a") and token or "" -- must contain at least one letter
end

function M.open(query)
  if not query or query == "" then return end

  local lnum = query:match(":(%d+)$")
  query = query:gsub(":%d+$", ""):gsub("%s+", "")
  if query == "" then return end

  local cwd = vim.fn.getcwd()
  local results = {}
  local seen = {}

  local function add(path)
    local p = vim.fn.fnamemodify(path, ":p")
    if not seen[p] and vim.fn.isdirectory(p) == 0 and vim.fn.filereadable(p) == 1 then
      seen[p] = true
      table.insert(results, p)
    end
  end

  -- Exact match anywhere under cwd
  local exact = vim.fn.findfile(query, cwd .. "/**")
  if exact ~= "" then add(exact) end

  -- Glob: partial name match (astrocor → astrocore.lua)
  for _, m in ipairs(vim.fn.glob(cwd .. "/**/" .. query .. "*", false, true)) do
    add(m)
  end

  if #results == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(results[1]))
    if lnum then vim.api.nvim_win_set_cursor(0, { tonumber(lnum), 0 }) end
  else
    require("snacks").picker.files({ search = query })
  end
end

return M
