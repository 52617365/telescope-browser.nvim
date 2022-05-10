local TS = {}

-- Make browser search the docs depending on the file type.
TS.file_type = function(bufnr)
  -- tsnode:range()
  --
  local parser = vim.treesitter.get_parser(bufnr, lang)
  print(vim.inspect(parser._lang))
end


TS.file_type()
