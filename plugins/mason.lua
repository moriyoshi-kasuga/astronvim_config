-- customize mason plugins
return {

  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "flake8",
        "isort",
        "djlint",
        "stylelint",
        -- "prettier",
        -- "stylua",
      })

      if not opts.handlers then opts.handlers = {} end

      local has_stylelint = function(utils)
        return utils.root_has_file ".stylelint"
          or utils.root_has_file ".stylelintrc.json"
          or utils.root_has_file ".stylelintrc.yml"
          or utils.root_has_file ".stylelintrc.yaml"
          or utils.root_has_file ".stylelintrc.js"
          or utils.root_has_file "stylelint.config.js"
      end

      opts.handlers.stylelint = function()
        local null_ls = require "null-ls"
        null_ls.register(null_ls.builtins.formatting.stylelint.with { condition = has_stylelint })
      end
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end
      local lspconfig = require "lspconfig"
      opts.handlers.emmet_ls = function()
        lspconfig["emmet_ls"].setup {
          filetypes = {
            "html",
            "htmldjango",
          },
        }
      end
    end,
  },

  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   -- overrides `require("mason-nvim-dap").setup(...)`
  --   opts = function(_, opts)
  --     -- add more things to the ensure_installed table protecting against community packs modifying it
  --     opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
  --       -- "python",
  --     })
  --   end,
  -- },
}
