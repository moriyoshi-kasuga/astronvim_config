local utils = require "astronvim.utils"
local myutils = require "user.myutils"

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

      local has_stylelint = function(util)
        return util.root_has_file ".stylelint"
          or util.root_has_file ".stylelintrc.json"
          or util.root_has_file ".stylelintrc.yml"
          or util.root_has_file ".stylelintrc.yaml"
          or util.root_has_file ".stylelintrc.js"
          or util.root_has_file "stylelint.config.js"
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
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "emmet_ls" })
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      handlers = {
        codelldb = function()
          local dap = require "dap"

          dap.adapters = {
            ---@diagnostic disable-next-line: missing-fields
            codelldb = {
              type = "server",
              port = "${port}",
              executable = {
                command = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/adapter/codelldb",
                args = { "--port", "${port}" },
              },
            },
          }

          dap.configurations = {
            cpp = {
              {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function() return myutils.getDebugPath() end,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Launch file with input",
                type = "codelldb",
                request = "launch",
                program = function() return myutils.getDebugCache "program" end,
                stdio = function() return myutils.getDebugCache "input" end,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Compile and Launch file",
                type = "codelldb",
                request = "launch",
                program = function() return myutils.getDebugCache "compile" end,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Compile and Launch file with input",
                type = "codelldb",
                request = "launch",
                program = function() return myutils.getDebugPath() end,
                stdio = function() return myutils.getChoiceFilePath() end,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
            },
          }
        end,
      },
    },
  },
}
