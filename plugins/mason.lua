local utils = require "astronvim.utils"

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
      local lspconfig = require "lspconfig"
      opts.handlers.clangd = function()
        ---@diagnostic disable-next-line: missing-fields
        lspconfig["clangd"].setup {
          capabilities = {
            offsetEncoding = "utf-8",
          },
        }
      end
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

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      handlers = {
        codelldb = function(source_name)
          local dap = require "dap"
          dap.adapters = {
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
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/" .. vim.fn.expand "%:r", "file")
                end,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Launch file with input.txt",
                type = "codelldb",
                request = "launch",
                stdio = "${fileDirname}/input.txt",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/" .. vim.fn.expand "%:r", "file")
                end,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Compile and Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                  local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/" .. vim.fn.expand "%", "file")
                  local directory = path:match "^(.*/)"
                  local fileBase = path:match "^.*/(.*)%..*$"
                  local basePath = directory .. fileBase
                  local compileCmd = require("user.myutils").supported_filetypes["cpp"]["debug"]
                    :gsub("%%", path)
                    :gsub("$fileBase", basePath)
                  local job_id = vim.fn.jobstart(compileCmd)
                  vim.fn.jobwait({ job_id }, -1)
                  return basePath
                end,
                cwd = "${fileDirname}",
                stopOnEntry = false,
              },
              {
                name = "Compile and Launch file with input.txt",
                type = "codelldb",
                request = "launch",
                stdio = "${fileDirname}/input.txt",
                program = function()
                  local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/" .. vim.fn.expand "%", "file")
                  local directory = path:match "^(.*/)"
                  local fileBase = path:match "^.*/(.*)%..*$"
                  local basePath = directory .. fileBase
                  local compileCmd = require("user.myutils").supported_filetypes["cpp"]["debug"]
                    :gsub("%%", path)
                    :gsub("$fileBase", basePath)
                  local job_id = vim.fn.jobstart(compileCmd)
                  vim.fn.jobwait({ job_id }, -1)
                  return basePath
                end,
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
