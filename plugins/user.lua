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
    keys = {
      {
        "<leader>;",
        function()
          if vim.g.codeium_enabled == true then
            vim.cmd "CodeiumDisable"
            vim.notify "Codeium Disable"
          else
            vim.cmd "CodeiumEnable"
            vim.notify "Codeium Enable"
          end
        end,
        desc = "Codeium Accept",
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "User AstroFile",
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
        },
        hover = {
          max_width = 0.6,
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
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
  {
    "neovim/nvim-lspconfig",
    config = function(...)
      -- run AstroNvim core lspconfig setup
      require "plugins.configs.lspconfig"(...)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(function(_, result, ctx, config)
        local file_extension = vim.fn.expand "%:e"
        if file_extension ~= "java" then return vim.lsp.handlers.hover(_, result, ctx, config) end
        config = config or {}
        config.focus_id = ctx.method
        if not (result and result.contents) then return end
        local contents = result.contents
        if type(result.contents) == "table" then
          contents = vim.tbl_map(
            function(v) return type(v) == "string" and v:gsub("%[(.-)%]%((.-)%)", "***%1***") or v end,
            contents
          )
        else
          contents = contents:gsub("%[(.-)%]%((.-)%)", "***%1***")
        end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(contents)
        if vim.tbl_isempty(markdown_lines) then return end
        return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
      end, { border = "rounded" })
    end,
  },
  {
    "phaazon/hop.nvim",
    event = "User AstroFile",
    config = function() require("hop").setup { keys = "etovxqpdygfblzhckisuran" } end,
    keys = {
      { "mw", "<cmd>HopWord<cr>", desc = "HopWord" },
      { "mW", "<cmd>HopWordMW<cr>", desc = "HopWordMW" },
      { "mm", "<cmd>HopAnywhere<cr>", desc = "HopAnywhere" },
      { "mM", "<cmd>HopAnywhereMW<cr>", desc = "HopAnywhereMW" },
      { "mf", "<cmd>HopChar1<cr>", desc = "HopChar1" },
      { "mF", "<cmd>HopChar1MW<cr>", desc = "HopChar1MW" },
      { "mk", "<cmd>HopChar2<cr>", desc = "HopChar2" },
      { "mK", "<cmd>HopChar2MW<cr>", desc = "HopChar2MW" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader><leader>e",
        function()
          if vim.v.count > 0 then
            require("harpoon.ui").nav_file(vim.v.count)
          else
            require("harpoon.ui").toggle_quick_menu()
          end
        end,
        desc = "Move to file",
      },
    },
  },
}
