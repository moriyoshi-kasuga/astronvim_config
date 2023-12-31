local utils = require "astronvim.utils"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "html", "css", "groovy" })
      end
      opts.indent = {
        enable = true,
        disable = {"html"}
      }
    end,
  },
}
