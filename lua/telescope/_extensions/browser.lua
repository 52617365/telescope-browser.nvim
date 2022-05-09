local has_telescope = pcall(require, 'telescope')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local dropdown_window = require "telescope.themes".get_dropdown()
local utils = require("utils")

local mod = {}

local visual_selection = nil

-- Contains the website url
-- print(vim.inspect(engine.value[2]))

-- Contains the website name
-- print(vim.inspect(engine.value[1]))

local picker_table = {
  { "rust", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
  { "mozilla", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
  { "ylilauta kappa :D", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
  { "google", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
}

-- Call this with the same binding but in visual mode.
mod.engine = function(opts)
  opts = opts or {}
  visual_selection = utils.get_visual_selection()
  print(vim.inspect(string.len(visual_selection[1])))
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

        if visual_selection[1] ~= nil then
          -- If then it's visual mode, else normal mode AKA selection has not been made, redirect to search screen.
          if string.len(visual_selection[1]) < 1 then
            mod.search(opts, select_engine.value)
          end
        else
          local url = select_engine.value[2] .. visual_selection[1]
          vim.api.nvim_command("silent " .. "!" .. "firefox" .. " &" .. url)
        end

      end)
      return true
    end,
  }):find()
end

mod.search = function(opts, engine)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "search: " .. engine.value[1],
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
mod.engine()
-- B.engines(dropdown_window)
--return mod
