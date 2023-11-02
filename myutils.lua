local M = {}

--- そのパスが存在するかどうか
---@param file string file path
---@return boolean suc
---@return string? errmsg
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

function M.eval_option(option)
  if type(option) == "function" then option = option() end
  if type(option) == "thread" then
    assert(coroutine.status(option) == "suspended", "If option is a thread it must be suspended")
    local co = coroutine.running()
    -- Schedule ensures `coroutine.resume` happens _after_ coroutine.yield
    -- This is necessary in case the option coroutine is synchronous and
    -- gives back control immediately
    vim.schedule(function() coroutine.resume(option, co) end)
    option = coroutine.yield()
  end
  return option
end

--- `ojb` が `nil` でなければ `obj` を返す,
--- `ojb` が `nil` であれば `nonNullObj`を返す
---@generic T
---@param obj nil | T
---@param nonNullObj T
---@return T
function M.requireNonNullElse(obj, nonNullObj) return obj and obj or nonNullObj end

function M.split(input, delimiter)
  if delimiter == nil then delimiter = " " end

  local result = {}
  for word in input:gmatch("([^" .. delimiter .. "]+)") do
    table.insert(result, word)
  end
  return result
end

--- @type string cache file path
M.cache_file = vim.fn.stdpath "cache" .. "/cache.lua"
--- @type table cache table
M.cache = {}

--- cache を保存する
---@param cache? table デフォルトでは `M.cache` を保存する
function M.saveCache(cache)
  if cache == nil then cache = M.cache end
  local f = io.open(M.cache_file, "w")
  ---@diagnostic disable-next-line: need-check-nil
  f:write("return " .. vim.inspect(cache))
  ---@diagnostic disable-next-line: need-check-nil
  f:close()
end

--- キャッシュのロードをする
---@return table
function M.loadCache()
  if not M.exists(M.cache_file) then os.execute("touch " .. M.cache_file) end
  local _, cache = pcall(dofile, M.cache_file)
  return M.requireNonNullElse(cache, {})
end

M.loadCache()

--- `tbl[key]` が `nil` の場合に `default` を返す
---@param tbl table
---@param key any
---@param default any
---@return any
function M.getOrDefault(tbl, key, default)
  if tbl[key] == nil then
    return default
  else
    return tbl[key]
  end
end

--- `path` のtableを返す。`path`がない場合には空tableを作成し値とする。
---@param path string スペースで区切られたパス
---@param tbl? table デフォルトでは M.cache を利用
---@return table
function M.getOrCreatePath(path, tbl)
  if tbl == nil then tbl = M.cache end
  local t = M.split(path)
  for _, p in ipairs(t) do
    if tbl[p] == nil then tbl[p] = {} end
    tbl = tbl[p]
  end
  return tbl
end

--- telescope で選択したファイルのパスを返す
--- これを使用する際は coroutine を使用してください
--- local run = coroutine.wrap(function()
---   local path = myutils.getChoiceFilePath()
---   -- ... このあとで path を使ってコードを実行する
--- end)
---@return string
function M.getChoiceFilePath()
  local co = coroutine.running()
  local cb = function(p) coroutine.resume(co, p) end
  cb = vim.schedule_wrap(cb)
  require("telescope.builtin").find_files {
    prompt_title = "Select a File",
    shorten_path = false,
    attach_mappings = function(prompt_bufnr, _)
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        cb(getmetatable(selection).cwd .. "/" .. selection[1])
      end)
      return true
    end,
  }
  return M.eval_option(coroutine.yield())
end

M.supported_filetypes = {
  c = {
    run = "${compile} && $debugPath",
    compile = "gcc $file -o $debugPath",
    debug = "gcc -g $file -o $debugPath",
  },
  cpp = {
    run = "${compile} && $debugPath",
    runStdio = "${compile} && $debugPath < ${input}",
    compile = "g++ -std=c++17 $file -o $debugPath",
    debug = "g++ -std=c++17 -Wall -DAL -O2 $file -o $debugPath",
  },
  py = {
    run = "python $file",
  },
}

function M.getDebugPath()
  local debug = vim.fn.expand "%:p:h" .. "/.debug/"
  if not M.exists(debug) then os.execute("mkdir " .. debug) end
  return debug .. vim.fn.expand "%:r"
end

--- > 文字を置換してくれる
--- @param cmd string
--- @return string
function M.substitute(cmd)
  cmd = cmd:gsub("$fileExtension", vim.fn.expand "%:e")
  cmd = cmd:gsub("$fileBase", vim.fn.expand "%:r")
  cmd = cmd:gsub("$filePath", vim.fn.expand "%:p")
  cmd = cmd:gsub("$file", vim.fn.expand "%")
  cmd = cmd:gsub("$dir", vim.fn.expand "%:p:h")
  cmd = cmd:gsub("$debugPath", M.getDebugPath())
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
        local filetypes = M.supported_filetypes[file_extension]
        selected_cmd = filetypes[choice]
        if selected_cmd then
          local run = coroutine.wrap(function()
            selected_cmd = selected_cmd:gsub("${compile}", filetypes["compile"])
            selected_cmd = selected_cmd:gsub("${debug}", filetypes["debug"])
            if selected_cmd:find "${input}" then selected_cmd = selected_cmd:gsub("${input}", M.getChoiceFilePath()) end
            vim.cmd(term_cmd .. M.substitute(selected_cmd))
          end)
          run()
        end
      end)
    end
  else
    vim.notify("The filetype isn't included in the list", vim.log.levels.WARN, { title = "Code Runner" })
  end
end

function M.getPathAndRunDebug()
  local file_extension = vim.fn.expand "%:e"
  local filetype = M.supported_filetypes[file_extension]
  local debug = filetype["debug"]
  local compileCmd = M.substitute(debug)
  local job_id = vim.fn.jobstart(compileCmd)
  vim.fn.jobwait({ job_id }, -1)
  return M.getDebugPath()
end

return M
