return {
  {
    "Exafunction/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufEnter",
    opts = {
      virtual_text = { enabled = false }, -- use blink.cmp popup instead of ghost text
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "codeium" },
        providers = {
          codeium = {
            name = "Codeium",
            module = "codeium.blink",
            score_offset = 100, -- show Codeium suggestions at the top
          },
        },
      },
    },
  },
}
