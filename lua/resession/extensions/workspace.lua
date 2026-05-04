local M = {}

local log_path = vim.fn.stdpath("cache") .. "/resession_workspace.log"

local function log(msg)
  local f = io.open(log_path, "a")
  if f then
    f:write(os.date("[%H:%M:%S] ") .. msg .. "\n")
    f:close()
  end
end

local function get_claude_session_id(cwd)
  local encoded = cwd:gsub("[/.]", "-")
  local project_dir = vim.fn.expand("~/.claude/projects/") .. encoded
  local files = vim.fn.glob(project_dir .. "/*.jsonl", false, true)
  if not files or #files == 0 then return nil end
  table.sort(files, function(a, b)
    return vim.fn.getftime(a) > vim.fn.getftime(b)
  end)
  return vim.fn.fnamemodify(files[1], ":t:r")
end

M.on_save = function()
  local data = {}
  log("=== on_save called ===")

  -- neo-tree: still visible at VimLeavePre, scan windows directly
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "neo-tree" then
      data.neotree_visible = true
      break
    end
  end

  -- toggleterm + claude: read from ExitPre snapshot (windows already closed at VimLeavePre)
  local snap_ids = vim.g.snapshot_toggleterm_ids
  if type(snap_ids) == "table" and #snap_ids > 0 then
    data.toggleterm_ids = snap_ids
  end

  if vim.g.snapshot_claude_open then
    data.claude_open = true
  end

  log("neo-tree: " .. tostring(data.neotree_visible or false))
  log("toggleterm_ids: " .. vim.inspect(data.toggleterm_ids or {}))
  log("claude_open: " .. tostring(data.claude_open or false))

  -- Save the session ID using the project cwd stored at session load time
  if data.claude_open then
    local project_cwd = vim.g.resession_project_cwd or vim.fn.getcwd()
    local session_id = get_claude_session_id(project_cwd)
    if session_id then
      data.claude_session_id = session_id
      log("claude session_id=" .. session_id .. " (cwd=" .. project_cwd .. ")")
    else
      log("claude: session_id not found for cwd=" .. project_cwd)
    end
  end

  log("=== on_save done: " .. vim.inspect(data) .. " ===")
  return data
end

M.on_load = function(data)
  log("=== on_load: " .. vim.inspect(data) .. " ===")
  if not data then return end

  vim.schedule(function()
    if data.neotree_visible then
      log("restoring neo-tree")
      local ok, err = pcall(vim.cmd, "Neotree show")
      if not ok then log("neo-tree error: " .. tostring(err)) end
    end

    if data.toggleterm_ids then
      for _, id in ipairs(data.toggleterm_ids) do
        log("restoring toggleterm id=" .. id)
        local ok, err = pcall(vim.cmd, id .. "ToggleTerm")
        if not ok then log("toggleterm error: " .. tostring(err)) end
      end
    end

    if data.claude_open then
      vim.defer_fn(function()
        local cmd = "ClaudeCode --resume"
        if data.claude_session_id then
          cmd = cmd .. " " .. data.claude_session_id
        end
        log("restoring claude: " .. cmd)
        local ok, err = pcall(vim.cmd, cmd)
        if not ok then log("claude error: " .. tostring(err)) end
      end, 500)
    end
  end)
end

return M
