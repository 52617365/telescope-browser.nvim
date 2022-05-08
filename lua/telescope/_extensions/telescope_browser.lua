-- TODO: Don't have two functions for two difference things, just make one function and check which mode is on ":h mode()"
local has_telescope = pcall(require, 'telescope')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local dropdown_window = require "telescope.themes".get_dropdown()
local utils = require("utils")
local B = {}

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

local picker_table = {
  { "rust", "rustdocs" },
  { "mozilla", "#00ff00" },
  { "ylilauta kappa :D", "#0000ff%a" },
  { "google", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
}

function search(opts, engine)
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

        local engine_url = engine.value[2]
        local url = engine_url .. selection
        vim.api.nvim_command("silent " .. "!" .. "firefox" .. " &" .. url)
      end)
      return true
    end,
  }):find()
end

-- Call this with the same binding but in visual mode.
B.engines = function(opts)
  opts = opts or {}
  local visualized_shit = utils.get_visual_selection()
  print(vim.inspect(visualized_shit[1]))
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

        print(vim.inspect(select_engine.value[1]))
        -- If then it's visual mode, else normal mode AKA selection has not been made, redirect to search screen.
        if #visualized_shit[1] == 0 then
          search(opts, select_engine)
        else
          local url = select_engine.value[2] .. visualized_shit[1]
          vim.api.nvim_command("silent " .. "!" .. "firefox" .. " &" .. url)
        end
      end)
      return true
    end,
  }):find()
end
-- B.engines(dropdown_window)
return require("telescope").register_extension {
  exports = {
    exports = {
      telescope_browser = B.engines()
    }
  },
}
