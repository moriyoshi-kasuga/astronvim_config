local myutils = require "user.myutils"
local utils = require "astronvim.utils"

return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "jdtls" }) end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        "flake8",
        "djlint",
      })
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "javadbg", "javatest" })
      opts.handlers = {
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
                program = myutils.getDebugPath,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Launch file with input",
                type = "codelldb",
                request = "launch",
                program = myutils.getDebugPath,
                stdio = myutils.getChoiceFilePath,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Compile and Launch file",
                type = "codelldb",
                request = "launch",
                program = myutils.getPathAndRunDebug,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Compile and Launch file with input",
                type = "codelldb",
                request = "launch",
                program = myutils.getPathAndRunDebug,
                stdio = myutils.getChoiceFilePath,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
            },
          }
        end,
      }
    end,
  },
}
