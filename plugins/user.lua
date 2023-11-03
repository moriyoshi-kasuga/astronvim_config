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
  {
    "rcarriga/nvim-dap-ui",
    opts = function(_, opts)
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open { reset = true } end
      dap.listeners.after.event_terminated["dapui_config"] = function() dapui.open { reset = true } end
      dap.listeners.after.event_exited["dapui_config"] = function() dapui.open { reset = true } end
      opts.layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 40,
        },
        {
          elements = {
            {
              id = "console",
              size = 0.5,
            },
            {
              id = "repl",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
        },
      }
    end,
  },
  {
    "Exafunction/codeium.vim",
    event = "User AstroFile",
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    config = function()
      require("lspsaga").setup {
        ui = {
          border = "rounded",
        },
        lightbulb = {
          enable = false,
        },
        symbol_in_winbar = {
          enable = false,
        }
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "ray-x/lsp_signature.nvim",
      opts = {},
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        ["java.format.settings.url"] = vim.fn.stdpath "config" .. "/java-google-formatter.xml",
        ["java.format.settings.profile"] = "GoogleStyle",
      },
    },
  },
}
