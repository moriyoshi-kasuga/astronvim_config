return {
  lsp = {
    mappings = {
      n = {
        K = {
          "<cmd>Lspsaga hover_doc<cr>",
          desc = "Hover",
        },
        ["<leader>ld"] = {
          "<cmd>Lspsaga show_line_diagnostics<cr>",
          desc = "show lien diagnostics",
        },
        ["<leader>lD"] = {
          "<cmd>Lspsaga show_buf_diagnostics<cr>",
          desc = "show buffer diagnostics",
        },
        ["<leader>l<C-d>"] = {
          "<cmd>Lspsaga show_workspace_diagnostics<cr>",
          desc = "show workspace diagnostics",
        },
        ["<C-j"] = {
          "<cmd>Lspsaga diagnostic_jump_next<cr>",
          desc = "Next diagnostic",
        },
        ["<C-k"] = {
          "<cmd>Lspsaga diagnostic_jump_prev<cr>",
          desc = "Previous diagnostic",
        },
      },
    },
    formatting = {
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
      },
      timeout_ms = 5000,
    },
    config = {
      clangd = function()
        return {
          capabilities = {
            offsetEncoding = "utf-8",
          },
        }
      end,
      emmet_ls = function()
        return {
          filetypes = {
            "html",
            "htmldjango",
          },
        }
      end,
    },
  },

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- colorscheme = "astrodark",
  -- colorscheme = "noctis",
  colorscheme = "vscode",
  -- colorscheme = "tokyonight",
  -- colorscheme = "tokyodark",
  -- colorscheme = "nightfox",
  -- colorscheme = "kanagawa",
  -- colorscheme = "catppuccin",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}
