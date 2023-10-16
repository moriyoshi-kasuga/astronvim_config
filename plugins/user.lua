return {
  { "unblevable/quick-scope", lazy = false },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "User AstroFile",
  },
  {
    "uga-rosa/translate.nvim",
    lazy = false,
    opts = {
      preset = {
        output = {
          split = {
            append = true,
          },
        },
      },
    },
  },
}
