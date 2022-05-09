local has_telescope = pcall(require, 'telescope')
local B = require(telescope._extensions.browser)

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

return require("telescope").register_extension {
    exports = {
      open_menu = B.engines
  },
}
