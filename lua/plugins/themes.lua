return {
  { "sainnhe/sonokai", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
  { "sainnhe/everforest", lazy = false, priority = 1000 },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,          -- Required to show Ghostty background color
      italic_comments = true,     -- Render comments in italic
      hide_fillchars = true,      -- Remove ~ characters on empty lines
      borderless_pickers = true,  -- Remove borders from picker windows (e.g. Telescope)
      theme = {
        variant = "default",      -- Always use the dark variant
      },
    },
  }
}
