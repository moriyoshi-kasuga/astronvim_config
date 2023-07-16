return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    local null_ls = require "null-ls"

    config.sources = {
      null_ls.builtins.diagnostics.flake8.with { extra_args = { "--max-line-length", 88 } },
      null_ls.builtins.formatting.black.with { extra_args = { "--fast" } },
      null_ls.builtins.diagnostics.djlint.with { filetypes = { "html" } },
    }
    return config -- return final config table
  end,
}
