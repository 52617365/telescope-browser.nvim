local br = require "telescope._extensions.telescope_browser"

return require("telescope").register_extension {
  exports = {
    engines = br.engines,
    search = br.search,
  },
}
