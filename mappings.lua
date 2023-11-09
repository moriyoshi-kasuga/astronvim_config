local myutils = require "user.myutils"
return {
  -- first key is the mode
  i = {
    ["<C-f>"] = {
      function() return vim.fn["codeium#Accept"]() end,
      desc = "Codeium Accept",
      expr = true,
    },
    ["<C-n>"] = {
      function() return vim.fn["codeium#CycleCompletions"](1) end,
      desc = "Codeium Next Cycle",
      expr = true,
    },
    ["<C-p>"] = {
      function() return vim.fn["codeium#CycleCompletions"](-1) end,
      desc = "Codeium Previous Cycle",
      expr = true,
    },
    ["<C-x>"] = {
      function() return vim.fn["codeium#Clear"]() end,
      desc = "Codeium Clear",
      expr = true,
    },
  },
  n = {
    ["<leader>n"] = {

      function()
        if vim.v.count > 0 then
          require("harpoon.ui").nav_file(vim.v.count)
        else
          require("harpoon.ui").toggle_quick_menu()
        end
      end,
      desc = "Move to file",
    },
    ["<leader>dm"] = {
      function() myutils.RunCode() end,
      desc = "CodeRunner",
    },
    ["<leader>du"] = { function() require("dapui").toggle { reset = true } end, desc = "Toggle Debugger UI" },
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
