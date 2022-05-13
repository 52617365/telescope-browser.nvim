local get_docs = require("docs")
local default_config = require("config")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

--#############################################################
--######          query is one of the two functions       #####
--######          that the user can call, this being      #####
--######          the documentation searching one.        #####
--#############################################################

local open_browser = function(_, browser, url)
  local command = "silent !" .. browser .. " " .. url
  vim.api.nvim_command(command)
end

local query = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "query",
    finder = finders.new_table {
      results = {}
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_current_line() -- Gets the current line so we can use that as a query
        local url = string.format(get_docs(), selection)
        open_browser(opts, "open", url)
      end)
      return true
    end
  }):find()
end

local function setup(opts)
  query(opts)
end

return setup
