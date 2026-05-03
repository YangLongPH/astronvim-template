return function()
  -- Fix clipboard for macOS
  vim.opt.clipboard = "unnamedplus"

  -- Force Alpha dashboard on directory open
  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Start Alpha dashboard when opening a directory",
    callback = function()
      local arg = vim.fn.argv(0)
      if arg ~= nil and vim.fn.isdirectory(arg) == 1 then
        vim.schedule(function()
          -- Force close the directory buffer to clear the UI
          vim.cmd "silent! bwipeout!"
          
          local ok, alpha = pcall(require, "alpha")
          if ok then 
            alpha.start(false) 
          end
        end)
      end
    end,
  })
end
