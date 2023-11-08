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
        "djlint",
      })
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
      },
    },
  },
}
