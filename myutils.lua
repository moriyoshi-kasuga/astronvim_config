local M = {}

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

M.supported_filetypes = {
  html = {
    default = "$file",
  },
  c = {
    default = "gcc $file -o $fileBase && $fileBase",
    debug = "gcc -g $file -o $fileBase && $fileBase",
  },
  cs = {
    default = "dotnet run",
  },
  cpp = {
    default = "g++ -std=c++17 $file -o  $fileBase && ./$fileBase",
    debug = "g++ -std=c++17 -g $file -o  $fileBase",
    competitive = "g++ -std=c++17 -Wall -DAL -O2 $file -o $fileBase && ./$fileBase < $dir/input.txt",
  },
  py = {
    default = "python $file",
  },
  go = {
    default = "go run $file",
  },
  java = {
    default = "java $file",
  },
  js = {
    default = "node $file",
    debug = "node --inspect $file",
  },
  ts = {
    default = "tsc $file && node $fileBase",
  },
  rs = {
    default = "rustc $file && $fileBase",
  },
  php = {
    default = "php $file",
  },
  r = {
    default = "Rscript $file",
  },
  jl = {
    default = "julia $file",
  },
  rb = {
    default = "ruby $file",
  },
  pl = {
    default = "perl $file",
  },
}

function M.exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

function M.isdir(path)
  -- "/" works on both Unix and Windows
  return M.exists(path .. "/")
end

function M.requireNonNullElse(obj, nonNullObj)
  return (obj and obj or (type(nonNullObj) == "function" and nonNullObj() or nonNullObj))
end

function M.split(input, delimiter)
  if delimiter == nil then delimiter = " " end

  local result = {}
  for word in input:gmatch("([^" .. delimiter .. "]+)") do
    table.insert(result, word)
  end
  return result
end

--- > 文字を置換してくれる
--- $file     = file name
--- $fileBase = excluded file extension name
--- $filePath = file path
--- $dir      = current file dir name
--- @param cmd string
--- @return string
function M.substitute(cmd)
  cmd = cmd:gsub("$fileExtension", vim.fn.expand "%:e")
  cmd = cmd:gsub("$fileBase", vim.fn.expand "%:r")
  cmd = cmd:gsub("$filePath", vim.fn.expand "%:p")
  cmd = cmd:gsub("$file", vim.fn.expand "%")
  cmd = cmd:gsub("$dir", vim.fn.expand "%:p:h")
  return cmd
end

function M.RunCode()
  local file_extension = M.substitute "$fileExtension"
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

M.cache_file = vim.fn.stdpath "cache" .. "/cache.lua"
M.cache = {}

function M.saveCache(cache)
  if cache == nil then cache = M.cache end
  local f = io.open(M.cache_file, "w")
  f:write("return " .. vim.inspect(cache))
  f:close()
end

function M.loadCache()
  if not M.exists(M.cache_file) then os.execute("touch " .. M.cache_file) end
  local _, cache = pcall(dofile, M.cache_file)
  return M.requireNonNullElse(cache, {})
end

function M.loadDefaultCache() M.cache = M.loadCache() end

M.loadDefaultCache()

function M.getOrDefault(tbl, key, default)
  if tbl[key] == nil then
    return default
  else
    return tbl[key]
  end
end

function M.getOrCreatePath(path, tbl)
  if tbl == nil then tbl = M.cache end
  local t = M.split(path)
  for _, p in ipairs(t) do
    if tbl[p] == nil then tbl[p] = {} end
    tbl = tbl[p]
  end
  return tbl
end

--- Debug の input のファイルを選択
---@return string?
function M.getInput()
  local co = coroutine.running()
  local cb = function(p) coroutine.resume(co, p) end
  cb = vim.schedule_wrap(cb)
  require("telescope.builtin").find_files {
    prompt_title = "Select a File",
    shorten_path = false,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        cb(getmetatable(selection).cwd .. "/" .. selection[1])
      end)
      return true
    end,
  }
  if co then return coroutine.yield() end
end

--- cache が あれば cache,なければ取得
---@param choice string ("program","compile","input")
---@return string
function M.getDebugCache(choice)
  if choice == "program" then
    local debug = M.substitute "$dir/.debug/"
    if not M.exists(debug) then os.execute("mkdir " .. debug) end
    return debug .. M.substitute "$fileBase"
  elseif choice == "compile" then
    local path = M.getDebugCache "program"
    local compile = M.substitute "$file"
    local compileCmd = M.supported_filetypes["cpp"]["debug"]:gsub("$fileBase", path):gsub("$file", compile)
    local job_id = vim.fn.jobstart(compileCmd)
    vim.fn.jobwait({ job_id }, -1)
    return path
  end
  local file_path = M.substitute "$filePath"
  local c = M.getOrCreatePath("debug cache " .. file_path)
  return M.requireNonNullElse(c[choice], function()
    local path
    if choice == "input" then path = M.getInput() end
    c[choice] = path
    M.saveCache()
    return path
  end)
end

return M
