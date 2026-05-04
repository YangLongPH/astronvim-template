return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = { "markdown" },
  keys = {
    { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Markdown render toggle" },
  },
  opts = {
    enabled = false,             -- start disabled, toggle with <leader>mr
    render_modes = { "n", "c" }, -- render in normal and command mode (not insert, so you can still edit)
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    bullet = {
      icons = { "●", "○", "◆", "◇" },
    },
  },
}
