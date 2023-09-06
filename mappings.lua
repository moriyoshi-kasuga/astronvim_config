-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
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
    ["<leader>h"] = { "<cmd>noh<cr>", desc = "clear higlight" },
    ["<leader>fd"] = { "<cmd>TodoTelescope<cr>", desc = "Find Todo" },
  },
  t = {
    ["<C-h>"] = { "<Bs>" },
  },
}
