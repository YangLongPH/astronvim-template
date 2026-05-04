return {
  {
    "stevearc/resession.nvim",
    -- This ensures the plugin is loaded when needed
    lazy = false, 
    opts = {
      autosave = {
        enabled = true,
        interval = 60,
        notify = false,
      },
      dirsession = {
        dir = "dirsession",
        icon = "󰄉 ",
      },
    },
    config = function(_, opts)
      local resession = require("resession")
      opts.buf_filter = function(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if vim.fn.isdirectory(name) == 1 then return false end
        return resession.default_buf_filter(bufnr)
      end
      opts.extensions = vim.tbl_extend("force", opts.extensions or {}, {
        workspace = {},
      })
      resession.setup(opts)
    end,
  },
}
