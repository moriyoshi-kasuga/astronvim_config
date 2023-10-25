local M = {}

M.supported_filetypes = {
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
    competitive = "g++ -std=c++17 -Wall -DAL -O2 % -o $fileBase && ./$fileBase < $dir/input.txt",
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

function M.substitute(cmd)
  cmd = cmd:gsub("%%", vim.fn.expand "%")
  cmd = cmd:gsub("$fileBase", vim.fn.expand "%:r")
  cmd = cmd:gsub("$filePath", vim.fn.expand "%:p")
  cmd = cmd:gsub("$file", vim.fn.expand "%")
  cmd = cmd:gsub("$dir", vim.fn.expand "%:p:h")
  cmd = cmd:gsub("#", vim.fn.expand "#")
  cmd = cmd:gsub("$altFile", vim.fn.expand "#")
  return cmd
end

function M.RunCode()
  local file_extension = vim.fn.expand "%:e"
  local selected_cmd = ""
  local term_cmd = "bot 10 new | term "

  if M.supported_filetypes[file_extension] then
    local choices = vim.tbl_keys(M.supported_filetypes[file_extension])

    if #choices == 0 then
      vim.notify("It doesn't contain any command", vim.log.levels.WARN, { title = "Code Runner" })
    elseif #choices == 1 then
      selected_cmd = M.supported_filetypes[file_extension][choices[1]]
      vim.cmd(term_cmd .. M.substitute(selected_cmd))
    else
      vim.ui.select(choices, { prompt = "Choose a command: " }, function(choice)
        selected_cmd = M.supported_filetypes[file_extension][choice]
        if selected_cmd then vim.cmd(term_cmd .. M.substitute(selected_cmd)) end
      end)
    end
  else
    vim.notify("The filetype isn't included in the list", vim.log.levels.WARN, { title = "Code Runner" })
  end
end

return M
