return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    local null_ls = require "null-ls"

    config.sources = {
      null_ls.builtins.formatting.black.with { extra_args = { "--fast" } },
    }
    return config -- return final config table
  end,
}
