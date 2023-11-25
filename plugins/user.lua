local function replace_markdown(var)
  if type(var) == "table" then
    return vim.tbl_map(replace_markdown, var)
  elseif type(var) == "string" then
    return var
      :gsub("%[([^%]]+)%]%([^%)]+%)", "***%1***")
      :gsub("<b>", "**")
      :gsub("</b>", "**")
      :gsub("<i>", "*")
      :gsub("</i>", "*")
  end
end
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
        if file_extension ~= "java" and file_extension ~= "class" and file_extension ~= "kt" then
          return vim.lsp.handlers.hover(_, result, ctx, config)
        end
        config = config or {}
        config.focus_id = ctx.method
        if not (result and result.contents) then return end
        local contents = result.contents
        contents = replace_markdown(contents)
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(contents)
        if vim.tbl_isempty(markdown_lines) then return end
        return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
      end, { border = "rounded" })
    end,
  },
  {
    "phaazon/hop.nvim",
    event = "User AstroFile",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
    end,
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
    "FotiadisM/tabset.nvim",
    lazy = false,
    config = function()
      require("tabset").setup {
        defaults = {
          expandtab = false,
        },
        languages = {
          yaml = {
            tabwidth = 2,
            expandtab = true,
          },
          {
            filetypes = {
              "javascript",
              "typescript",
              "javascriptreact",
              "typescriptreact",
              "json",
              "html",
              "lua",
            },
            config = {
              tabwidth = 2,
            },
          },
          {
            filetype = { "python" },
            config = {
              tabwidth = 4,
            },
          },
        },
      }
    end,
  },
  {
    "ThePrimeagen/harpoon",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "Harpoon" },
    config = function()
      require("harpoon").setup {
        menu = {
          width = math.floor(vim.api.nvim_win_get_width(0) / 3),
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
    },
  },
  {
    "mbbill/undotree",
    lazy = false,
  },
  { -- override nvim-autopairs plugin
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "plugins.configs.nvim-autopairs"(plugin, opts)
      for _, punct in pairs { ",", ";" } do
        require("nvim-autopairs").add_rules {
          require "nvim-autopairs.rule"("", punct)
            :with_move(function(hello) return hello.char == punct end)
            :with_pair(function() return false end)
            :with_del(function() return false end)
            :with_cr(function() return false end)
            :use_key(punct),
        }
      end
    end,
  },
}
