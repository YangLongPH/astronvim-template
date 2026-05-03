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
      resession.setup(opts)
    end,
  },
}
