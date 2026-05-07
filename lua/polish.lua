-- OSC 52: works over SSH (Windows Terminal, WezTerm, etc.)
if os.getenv "SSH_TTY" then
  local osc52 = require "vim.ui.clipboard.osc52"
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy "+",
      ["*"] = osc52.copy "*",
    },
    paste = {
      ["+"] = osc52.paste "+",
      ["*"] = osc52.paste "*",
    },
  }
end
vim.opt.clipboard = "unnamedplus"

-- Force Alpha dashboard on directory open
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Start Alpha dashboard when opening a directory",
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= nil and vim.fn.isdirectory(arg) == 1 then
      vim.schedule(function()
        vim.cmd "silent! bwipeout!"
        local ok, alpha = pcall(require, "alpha")
        if ok then alpha.start(false) end
      end)
    end
  end,
})
