return {
  "folke/snacks.nvim",
  opts = {
    image = {
      enabled = true,
      force_magick = true, -- Force magick if terminal does not support the Kitty graphics protocol
      formats = { "png", "jpg", "jpeg", "webp", "gif" },
    },
  },
}
