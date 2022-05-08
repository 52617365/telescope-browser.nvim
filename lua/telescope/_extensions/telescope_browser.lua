local has_telescope, telescope = pcall(require, 'telescope')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local window = require "telescope.themes".get_dropdown()

local B = {}

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

function get_visual_selection()
  -- does not handle rectangular selection
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return lines
end


local picker_table = {
  { "rust", "rustdocs" },
  { "mozilla", "#00ff00" },
  { "ylilauta kappa :D", "#0000ff" },
}

B.search = function(opts, engine)
  opts = opts or {}
  -- Contains the website url
  -- print(vim.inspect(engine.value[2]))

  -- Contains the website name
  -- print(vim.inspect(engine.value[1]))

  pickers.new(opts, {
    prompt_title = "search: " .. engine.value[1],
    print(vim.inspect(engine)),
    finder = finders.new_table {
      results = {},
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    },
    -- action_state.get_current_line()
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        -- Gets the current line so we can use that as a query
        local selection = action_state.get_current_line()
        print(vim.inspect(selection))

        vim.api.nvim_command("silent " .. "!" .. "firefox" .. " &" .. selection)
        -- vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,
  }):find()
end

-- our picker function: engines
-- Pass in nothing if regular search, if visual selected search then pass '<','>
B.engines = function(opts, opt_visual_query)
  opts = opts or {}
  local visualized_shit = get_visual_selection()
  print(vim.inspect(visualized_shit))
  opt_visual_query = opt_visual_query or nil -- See if user passed in the highlighted string in visual mode or not.
  pickers.new(opts, {
    prompt_title = "engines",
    finder = finders.new_table {
      results = picker_table,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local select_engine = action_state.get_selected_entry()
        -- print(vim.inspect(selection))

        -- If user did not visually select the text, go into search picker, else search right away with visualised selection.
        if opt_visual_query == nil then
          B.search(opts, select_engine)
        else
          -- TODO: Attach the browser of choice in here.
          --vim.get_visual_selection()
          vim.api.nvim_command("silent " .. "!" .. "firefox &" .. opt_visual_query)
        end
      end)
      return true
    end,
  }):find()
end

B.engines(window)

return B
