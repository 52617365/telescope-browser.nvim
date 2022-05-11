local utils = require 'nvim-treesitter.ts_utils'
local parser = vim.treesitter.get_parser(bufnr, lang)
local range =  vim.treesitter.tsnode:range()

local TS = {}

-- Make browser search the docs depending on the file type.
TS.file_type = function(bufnr)
  print(vim.inspect(parser._lang))
end

TS.visualized_text = function(bufnr)
  print(vim.inspect(range))
end

TS.visualized_text()
-- TS.file_type()
