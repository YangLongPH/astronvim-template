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
      -- Automatically restore the last session when opening a directory
      restore_session_on_dir = {
        {
          event = "VimEnter",
          desc = "Restore directory session using Resession.nvim",
          callback = function()
            local arg = vim.fn.argv(0)
            -- Only trigger if opening a directory
            if arg ~= nil and vim.fn.isdirectory(arg) == 1 then
              -- Set working directory to the target folder
              vim.api.nvim_set_current_dir(arg)
              
              -- Always show Neo-tree sidebar for context
              vim.cmd("Neotree show")
              
              -- Schedule session restoration to ensure all plugins are ready
              vim.defer_fn(function()
                local ok, resession = pcall(require, "resession")
                if ok then
                  -- Attempt to load the session for the current directory
                  resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
                end
              end, 100) -- 100ms delay to stabilize UI
            end
          end,
        },
      },
    },
  },
}
