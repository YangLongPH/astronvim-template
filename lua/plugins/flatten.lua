return {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001,
  -- Using 'opts' allows AstroNvim to handle the setup call correctly
  opts = {
    window = {
      open = "current",
    },
    hooks = {
      -- Use 'pre_open' instead of 'callbacks' to prevent crashes
      pre_open = function()
        -- Only hide the terminal; do not close it to maintain session focus
        vim.cmd("silent! hide")
      end,
      post_open = function(bufnr, winnr, ft, is_blocking)
        if is_blocking then
          vim.api.nvim_set_current_win(winnr)
        else
          -- Force exit from Terminal mode to Normal mode
          -- This ensures hotkeys like <Space>e remain functional
          vim.cmd("stopinsert")
        end
        -- Force neo-tree open <Leader>e alway work
        require("neo-tree.command").execute({ action = "show", source = "filesystem", position = "left" })
      end,
      -- Ensure clean state after finishing blocking tasks like git commits
      block_end = function()
        vim.cmd("stopinsert")
      end,
    },
  },
}
