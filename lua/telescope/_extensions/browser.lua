local br = require "telescope._extensions.telescope_browser"

return require("telescope").register_extension {
  exports = {
    engines = br.engines,
    regular_engines = br.regular_engines,
    visual_engines = br.visual_engines,
  },
}
