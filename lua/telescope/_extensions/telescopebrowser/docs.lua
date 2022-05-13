local config = require("config")
local parser = vim.treesitter.get_parser(bufnr, lang)

-- Gets the correct file type from treesitter.
local get_filetype = function(bufnr)
  return parser._lang
end

local D = {}

-- Gets the corresponding documentation site attached to the language name
function D.get_docs(bufnr)
  local file_type = get_filetype(bufnr)
  local doc_url = config.docs[file_type]
  if doc_url == nil then
    print(vim.inspect("You did not specify a url for this file type."))
  end
  return doc_url
end

return D.get_docs
