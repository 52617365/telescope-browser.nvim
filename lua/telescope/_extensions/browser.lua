local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local utils = require("utils")
local mod = {}
-- Contains the website url
-- print(vim.inspect(engine.value[2]))

-- Contains the website name
-- print(vim.inspect(engine.value[1]))

-- TODO: This will come from the config file but I have not figured that out yet.
local picker_table = {
  { "rust", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
  { "mozilla", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
  { "ylilauta kappa :D", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
  { "google", "https://www.google.com/search?channel=fs&client=ubuntu&q=" },
}

local search_finder = finders.new_table {
  results = picker_table,
  entry_maker = function(entry)
    return {
      value = entry,
      display = entry[1],
      ordinal = entry[1],
    }
  end
}


-- Showcases all active sites
mod.engine = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "engines",
    finder = search_finder,
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local select_engine = action_state.get_selected_entry()
        local visual_selection = utils.get_visual_selection()

        if visual_selection == nil then
          mod.search(opts, select_engine);
        else
          if visual_selection ~= nil then
            local url = select_engine.value[2] .. visual_selection[1]
            utils.open_url(url)
            -- vim.api.nvim_command("silent " .. "!" .. "xdg-open" .. " &" .. url)
          else
            print("No query provided")
          end
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
    finder = search_finder,
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_current_line() -- Gets the current line so we can use that as a query
        if selection ~= "" then
          local url = engine.value[2] .. selection
          utils.open_url(url)
          -- vim.api.nvim_command("silent " .. "!" .. "xdg-open" .. " &" .. url)
        else
          print("No query provided")
        end
      end)
      return true
    end,
  }):find()
end


mod.engine()
-- B.engines(dropdown_window)
--return mod
