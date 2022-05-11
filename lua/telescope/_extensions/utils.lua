local api = vim.api
local ts_utils = require 'nvim-treesitter.ts_utils'
local parsers = require 'nvim-treesitter.parsers'
local Mod = {}

-- Returns the text contents of the visualized text.
Mod.visual_selection_contents = function()
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
    return lines
  else
    return ""
  end
end

--package.config:sub(1,1) returns the path separator, which is '\\' on Windows and '/' on Unixes.
Mod.OS = function()
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
