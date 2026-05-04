return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Diffview open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview file history" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>",       desc = "Diffview close" },
  },
  opts = function()
    local actions = require("diffview.actions")
    return {
      keymaps = {
        merge_tool = {
          -- Choose a side
          ["<leader>co"] = actions.conflict_choose("ours"),    -- accept ours
          ["<leader>ct"] = actions.conflict_choose("theirs"),  -- accept theirs
          ["<leader>cb"] = actions.conflict_choose("base"),    -- accept base
          ["<leader>ca"] = actions.conflict_choose("all"),     -- keep all (both sides)
          ["<leader>cx"] = actions.conflict_choose("none"),    -- delete conflict

          -- Navigate between conflict markers
          ["]x"] = actions.next_conflict,
          ["[x"] = actions.prev_conflict,
        },
      },
    }
  end,
}
