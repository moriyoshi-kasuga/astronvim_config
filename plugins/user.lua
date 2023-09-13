return {
  { "unblevable/quick-scope", lazy = false },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = {
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
    },
  },
}
