local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

local default_config = require "telescope._extensions.telescopebrowser.config"
local telescopebrowser = require "telescope._extensions.telescopebrowser.browser"

return require("telescope").register_extension {
  setup = function(ext_config)
    default_config.docs = ext_config.docs or default_config.docs
  end,
  exports = {
    browser = telescopebrowser.query
  }
}
