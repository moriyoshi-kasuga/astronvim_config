return {
  "L3MON4D3/LuaSnip",
  config = function(plugin, opts)
    -- include the default astronvim config that calls the setup call
    require "plugins.configs.luasnip"(plugin, opts)

    -- require("luasnip").filetype_extend("javascriptreact", { "html" })

    require("luasnip").filetype_extend("htmldjango", { "html" })
    require("luasnip.loaders.from_vscode").lazy_load {
      exclude = { "html" },
      -- this can be used if your configuration lives in ~/.config/nvim
      -- if your configuration lives in ~/.config/astronvim, the full path
      -- must be specified in the next line
      paths = { "./lua/user/snippets" },
    }
  end,
}
