local docs = require("docs")
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

-- local open_browser = function(opts, browser, url)
--   local query = browser .. " " .. url
--   vim.fn.jobstart(query)
-- end

local open_browser = function(opts, browser, url)
  local command = "silent !" .. browser .. " " .. url
  vim.api.nvim_command(command)
end

-- local selection = action_state.get_current_line() -- Gets the current line so we can use that as a query
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
        local url = string.format(docs.get_docs_url(), selection)
        open_browser(opts, "open", url)
        -- Do query here
      end)
      return true
    end
  }):find()
end
-- local url = string.format(docs.get_docs_url(), "insert query here")
query()
