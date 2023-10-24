local function substitute(cmd)
  cmd = cmd:gsub("%%", vim.fn.expand "%")
  cmd = cmd:gsub("$fileBase", vim.fn.expand "%:r")
  cmd = cmd:gsub("$filePath", vim.fn.expand "%:p")
  cmd = cmd:gsub("$file", vim.fn.expand "%")
  cmd = cmd:gsub("$dir", vim.fn.expand "%:p:h")
  cmd = cmd:gsub("#", vim.fn.expand "#")
  cmd = cmd:gsub("$altFile", vim.fn.expand "#")
  return cmd
end

local function RunCode()
  local file_extension = vim.fn.expand "%:e"
  local selected_cmd = ""
  local term_cmd = "bot 10 new | term "
  local supported_filetypes = {
    html = {
      default = "%",
    },
    c = {
      default = "gcc % -o $fileBase && $fileBase",
      debug = "gcc -g % -o $fileBase && $fileBase",
    },
    cs = {
      default = "dotnet run",
    },
    cpp = {
      default = "g++ -std=c++17 % -o  $fileBase && ./$fileBase",
      debug = "g++ -std=c++17 -g % -o  $fileBase",
      competitive = "g++ -std=c++17 -Wall -DAL -O2 % -o $fileBase && ./$fileBase < $fileBase.txt",
    },
    py = {
      default = "python %",
    },
    go = {
      default = "go run %",
    },
    java = {
      default = "java %",
    },
    js = {
      default = "node %",
      debug = "node --inspect %",
    },
    ts = {
      default = "tsc % && node $fileBase",
    },
    rs = {
      default = "rustc % && $fileBase",
    },
    php = {
      default = "php %",
    },
    r = {
      default = "Rscript %",
    },
    jl = {
      default = "julia %",
    },
    rb = {
      default = "ruby %",
    },
    pl = {
      default = "perl %",
    },
  }

  if supported_filetypes[file_extension] then
    local choices = vim.tbl_keys(supported_filetypes[file_extension])

    if #choices == 0 then
      vim.notify("It doesn't contain any command", vim.log.levels.WARN, { title = "Code Runner" })
    elseif #choices == 1 then
      selected_cmd = supported_filetypes[file_extension][choices[1]]
      vim.cmd(term_cmd .. substitute(selected_cmd))
    else
      vim.ui.select(choices, { prompt = "Choose a command: " }, function(choice)
        selected_cmd = supported_filetypes[file_extension][choice]
        if selected_cmd then vim.cmd(term_cmd .. substitute(selected_cmd)) end
      end)
    end
  else
    vim.notify("The filetype isn't included in the list", vim.log.levels.WARN, { title = "Code Runner" })
  end
end

return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>dm"] = {
      function() RunCode() end,
      desc = "RunCode",
    },
    ["]o"] = {
      function() require("todo-comments").jump_next() end,
      desc = "Next todo comment",
    },
    ["[o"] = {
      function() require("todo-comments").jump_prev() end,
      desc = "Previous todo comment",
    },
    ["<leader>r"] = {
      function()
        vim.lsp.buf.format { async = false }
        vim.cmd "update"
      end,
      desc = "format",
    },
    [";"] = {
      "<Plug>(jumpcursor-jump)",
      desc = "jump cursor",
    },
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
    ["<leader>h"] = { "<cmd>noh<cr>", desc = "clear higlight" },
    ["<leader>fd"] = { "<cmd>TodoTelescope<cr>", desc = "Find Todo" },
    ["<leader>z"] = {
      name = "Translate",
    },
    ["<leader>ze"] = {
      "<cmd>Translate en<cr>",
      desc = "translate to en",
    },
    ["<leader>zj"] = {
      "<cmd>Translate ja<cr>",
      desc = "translate to ja",
    },
    ["<leader>zr"] = {
      "<cmd>Translate en -output=replace<cr>",
      desc = "translate to en of replace",
    },
    ["<leader>zk"] = {
      "<cmd>Translate ja -output=replace<cr>",
      desc = "translate to ja of replace",
    },
  },
  v = {
    ["<leader>z"] = {
      name = "Translate",
    },
    ["<leader>ze"] = {
      "<cmd>Translate en<cr>",
      desc = "translate to en",
    },
    ["<leader>zj"] = {
      "<cmd>Translate ja<cr>",
      desc = "translate to ja",
    },
    ["<leader>zr"] = {
      "<cmd>Translate en -output=replace<cr>",
      desc = "translate to en of replace",
    },
    ["<leader>zk"] = {
      "<cmd>Translate ja -output=replace<cr>",
      desc = "translate to ja of replace",
    },
  },
  t = {
    ["<C-h>"] = { "<Bs>" },
  },
}
