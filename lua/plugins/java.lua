---@type LazySpec
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local java21 = vim.env.JDTLS_JAVA
      if java21 then
        opts.cmd = {
          vim.fn.stdpath "data" .. "/mason/bin/jdtls",
          "--java-executable", java21,
          "--jvm-arg=-javaagent:" .. vim.fn.stdpath "data" .. "/mason/share/jdtls/lombok.jar",
        }
      end
      return opts
    end,
  },
}
