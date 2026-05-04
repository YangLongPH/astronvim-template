-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration(for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- Rooter handles directory changes in v6
    rooter = {
      autochdir = true,
      detector = {
        "lsp",
        { ".git", "_darcs", ".hg", ".bzr", ".svn" },
        { "lua", "Makefile", "package.json" },
      },
    },
    -- Vim options
    options = {
      opt = {
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false,
        signcolumn = "yes",
        wrap = false,
        clipboard = "unnamedplus", -- Sync with system clipboard
        termguicolors = true,
      },
      g = {
        -- Global variables
      },
    },
    -- Mappings configuration
    mappings = {
      n = {
        -- Navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- Close buffer safely
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        
        -- Delete line without copying to register (no yank)
        ["x"] = { '"_dd', desc = "Delete line (no yank)" },
      },
      
      v = {
        -- Delete selection without copying to register (no yank)
        ["x"] = { '"_d', desc = "Delete selection (no yank)" },
      }
    },
    -- Autocommands
    autocmds = {
      -- Jenkinsfile → groovy filetype
      jenkinsfile_ft = {
        {
          event = { "BufRead", "BufNewFile" },
          pattern = { "Jenkinsfile", "Jenkinsfile.*", "*.jenkinsfile" },
          callback = function() vim.bo.filetype = "groovy" end,
        },
      },
      -- Automatically restore the last session when opening a directory
      restore_session_on_dir = {
        {
          event = "VimEnter",
          desc = "Restore directory session using Resession.nvim",
          callback = function()
            local arg = vim.fn.argv(0)
            if arg ~= nil and vim.fn.isdirectory(arg) == 1 then
              vim.api.nvim_set_current_dir(arg)
              vim.defer_fn(function()
                local ok, resession = pcall(require, "resession")
                if ok then
                  resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
                  vim.g.resession_dir_active = true
                  vim.g.resession_project_cwd = vim.fn.getcwd()
                end
                vim.cmd("Neotree show")
              end, 100)
            end
          end,
        },
      },
      -- Snapshot visible state BEFORE windows close (ExitPre fires before QuitPre/window closure)
      snapshot_state_on_exit = {
        {
          event = "ExitPre",
          desc = "Snapshot terminal and claude visibility before windows close",
          callback = function()
            -- Snapshot toggleterm IDs that are currently visible in a window
            local ids = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "terminal" then
                local name = vim.api.nvim_buf_get_name(buf)
                local id = name:match("#toggleterm#(%d+)$")
                if id then table.insert(ids, tonumber(id)) end
              end
            end
            vim.g.snapshot_toggleterm_ids = ids

            -- Snapshot claude: visible non-toggleterm terminal window + server running
            local claude_visible = false
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "terminal" and vim.bo[buf].filetype ~= "toggleterm" then
                local name = vim.api.nvim_buf_get_name(buf)
                if not name:match("#toggleterm#") then
                  local ok, claudecode = pcall(require, "claudecode")
                  if ok and claudecode.state and claudecode.state.server then
                    claude_visible = true
                  end
                end
              end
            end
            vim.g.snapshot_claude_open = claude_visible
          end,
        },
      },
      -- Save session on quit so terminal/neo-tree/claude state is always persisted
      save_session_on_quit = {
        {
          event = "VimLeavePre",
          desc = "Save directory session using Resession.nvim",
          callback = function()
            if not vim.g.resession_dir_active then return end
            local ok, resession = pcall(require, "resession")
            if ok then
              resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
            end
          end,
        },
      },
    },
  },
}
