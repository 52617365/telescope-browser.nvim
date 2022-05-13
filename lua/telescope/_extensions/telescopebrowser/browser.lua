local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local docs = require "docs"

local Q = {}
--#############################################################
--######          query is one of the two functions       #####
--######          that the user can call, this being      #####
--######          the documentation searching one.        #####
--#############################################################

function Q.open_browser(_, browser, url)
  local command = "silent !" .. browser .. " " .. url
  vim.api.nvim_command(command)
end

function Q.query(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Insert query",
    finder = finders.new_table {
      results = {}
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_current_line() -- Gets the current line so we can use that as a query
        local url = string.format(docs(), selection)
        print(url)
        Q.open_browser(opts, "open", url)
      end)
      return true
    end
  }):find()
end

return Q
