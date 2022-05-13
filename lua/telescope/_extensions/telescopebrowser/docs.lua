local parser = vim.treesitter.get_parser(bufnr, lang)
local C = require("config")

-- Gets the correct file type from treesitter.
local get_filetype = function(bufnr)
  return parser._lang
end

-- Gets the corresponding documentation site attached to the language name
return function(bufnr)
  local file_type = get_filetype(bufnr)
  local doc_url = C.docs[file_type]
  return doc_url
end

