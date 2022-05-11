local utils = require 'nvim-treesitter.ts_utils'
local parser = vim.treesitter.get_parser(bufnr, lang)

-- For sites that do not have a good search engine, use a search query that tries to find information from that site.
-- EXAMPLE QUERY FOR NON SEARCHABLE DOCS
-- In the example we are looking for documentation about coroutine's from the lua manual page
-- #############################################################
-- ##                                                         ##
-- ##             coroutine site:lua.org/manual/5.4/          ##
-- ##                                                         ##
-- #############################################################

-- Contains the corresponding documentation page.
local Docs_urls = {
  ["lua"] = "{query} site:lua.org/manual/5.4/",
  ["rust"] = "https://doc.rust-lang.org/std/index.html?search={query}",
  ["cpp"] = "{query} site:cppreference.com",
  ["c"] = "{query} site:cppreference.com",
  ["java"] = "https://docs.oracle.com/search/?q={query}&category=java&product=en%2Fjava",
  ["javascript"] = "https://developer.mozilla.org/en-US/search?q={query}",
  ["php"] = "https://www.php.net/manual-lookup.php?pattern={query}&scope=quickref",
  ["vim"] = "https://vim.fandom.com/wiki/Special:Search?query={query}&scope=internal&contentType=&ns%5B0%5D=0",
  ["kotlin"] = "https://kotlinlang.org/docs/home.html?q={query}&s=full",
}

-- Gets the correct file type from treesitter.
local get_filetype = function(bufnr)
  return parser._lang
end

-- Gets the corresponding documentation site attached to the language name
local get_docs_url = function(bufnr)
  local file_type = get_filetype(bufnr)
  local docs_url = Docs_urls[file_type]
  return docs_url
end

local url = get_docs_url()
print(vim.inspect(url))
