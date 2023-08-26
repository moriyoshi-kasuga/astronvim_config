return {
  "L3MON4D3/LuaSnip",
  config = function(plugin, opts)
    require "plugins.configs.luasnip"(plugin, opts)
    require("luasnip.loaders.from_vscode").lazy_load { paths = { "./lua/user/snippets" } }
    local luasnip = require "luasnip"
    luasnip.filetype_extend("javascript", { "javascriptreact" })
    luasnip.filetype_extend("htmldjango", { "html" })
  end,
}
