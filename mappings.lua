local utils = require "user.myutils"
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>dm"] = {
      function() utils.RunCode() end,
      desc = "RunCode",
    },
    ["<leader>dd"] = {
      function()
        local cache = utils.getOrCreatePath "debug cache"
        cache[utils.substitute "$filePath"] = nil
        utils.saveCache()
        vim.notify "Remve Debug Cache."
      end,
      desc = "Remvoe Debug Cache",
    },
    ["]o"] = {
      function() require("todo-comments").jump_next() end,
      desc = "Next todo comment",
    },
    ["[o"] = {
      function() require("todo-comments").jump_prev() end,
      desc = "Previous todo comment",
    },
    ["<leader>r"] = {
      function()
        vim.lsp.buf.format { async = false }
        vim.cmd "update"
      end,
      desc = "format",
    },
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
    ["<leader>h"] = { "<cmd>noh<cr>", desc = "clear higlight" },
    ["<leader>fd"] = { "<cmd>TodoTelescope<cr>", desc = "Find Todo" },
    ["<leader>z"] = {
      name = "Translate",
    },
    ["<leader>ze"] = {
      "<cmd>Translate en<cr>",
      desc = "translate to en",
    },
    ["<leader>zj"] = {
      "<cmd>Translate ja<cr>",
      desc = "translate to ja",
    },
    ["<leader>zr"] = {
      "<cmd>Translate en -output=replace<cr>",
      desc = "translate to en of replace",
    },
    ["<leader>zk"] = {
      "<cmd>Translate ja -output=replace<cr>",
      desc = "translate to ja of replace",
    },
  },
  v = {
    ["<leader>z"] = {
      name = "Translate",
    },
    ["<leader>ze"] = {
      "<cmd>Translate en<cr>",
      desc = "translate to en",
    },
    ["<leader>zj"] = {
      "<cmd>Translate ja<cr>",
      desc = "translate to ja",
    },
    ["<leader>zr"] = {
      "<cmd>Translate en -output=replace<cr>",
      desc = "translate to en of replace",
    },
    ["<leader>zk"] = {
      "<cmd>Translate ja -output=replace<cr>",
      desc = "translate to ja of replace",
    },
  },
  t = {
    ["<C-h>"] = { "<Bs>" },
  },
}
