local U = {}

function U.get_visual_selection()
  -- does not handle rectangular selection
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  if lines[1] ~= nil then
    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
      lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
      lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    local namespaces = vim.api.nvim_get_namespaces()["hlyank"]
    -- print(vim.inspect(namespaces))
    -- vim.api.nvim_buf_clear_namespace(0, namespaces["hlyank"], s_start, s_end)
    vim.api.nvim_buf_clear_namespace(0, namespaces, 0, -1)
    print(vim.inspect(lines))
    return lines
  else
    return ""
  end
  -- vim.api.nvim_buf_clear_namespace(0, s_start, s_end)
end

--package.config:sub(1,1) returns the path separator, which is '\\' on Windows and '/' on Unixes.
local getOS = function()
  local os = package.config:sub(1, 1)
  if os == '\\' then
    return 'windows'
  else if os == '/' then
      return 'unix'
    else
      return nil
    end
  end
end

U.open_url = function(url)
  local OS = getOS()
  print(vim.inspect(OS))
  if OS == "windows" then
    os.execute('start ""  &"' .. url .. '"')
  else
    os.execute('open ""  &"' .. url .. '"')
  end
end
U.get_visual_selection()
return U
