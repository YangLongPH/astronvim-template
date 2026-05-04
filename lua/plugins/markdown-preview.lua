return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  ft = { "markdown" },
  build = "cd app && npm install",
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown preview toggle (iamcco)" },
  },
  init = function()
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_browser = ""
  end,
}
