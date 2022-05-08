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

local picker_table = {
  { "rust", "rustdocs" },
  { "green", "#00ff00" },
  { "blue", "#0000ff" },
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
        -- vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,
  }):find()
end

-- our picker function: colors
B.engines = function(opts)
  opts = opts or {}
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
        local selection = action_state.get_selected_entry()
        -- print(vim.inspect(selection))
        B.search(opts, selection)
        -- vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,
  }):find()
end

B.engines(window)

return B
