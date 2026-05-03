return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      -- Disable hijacking netrw so Neo-tree doesn't open on directories
      hijack_netrw_behavior = "disabled",
      -- This ensures the tree root matches your :pwd
      bind_to_cwd = true,
      -- Change the 'Root' header in the UI
      sync_root_with_cwd = true,
    },
  },
}
