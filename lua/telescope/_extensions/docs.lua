local parser = vim.treesitter.get_parser(bufnr, lang)
local G = {}
-- For sites that do not have a good search engine, use a search query that tries to find information from that site.
-- EXAMPLE QUERY FOR NON SEARCHABLE DOCS
-- In the example we are looking for documentation about coroutine's from the lua manual page
-- #############################################################
-- ##                                                         ##
-- ##           coroutine site:lua.org/manual/5.4/            ##
-- ##                                                         ##
-- #############################################################
--
-- Contains the corresponding documentation page.
G.docs_urls = {
  ["lua"] = "https://www.google.com/search?q=%s?as_sitesearch=lua.org/manual/5.4/",
  ["rust"] = "https://doc.rust-lang.org/std/index.html?search=%s",
  ["cpp"] = "https://www.google.com/search?q=%s?as_sitesearch=site:cppreference.com",
  ["c"] = "https://www.google.com/search?q=%s?as_sitesearch=site:cppreference.com",
  ["java"] = "https://docs.oracle.com/search/?q=%s&category=java&product=en%2Fjava",
  ["javascript"] = "https://developer.mozilla.org/en-US/search?q=%s",
  ["php"] = "https://www.php.net/manual-lookup.php?pattern=%s&scope=quickref",
  ["vim"] = "https://vim.fandom.com/wiki/Special:Search?query=%s&scope=internal&contentType=&ns%5B0%5D=0",
  ["kotlin"] = "https://kotlinlang.org/docs/home.html?q=%s&s=full",
}

-- Gets the correct file type from treesitter.
local get_filetype = function(bufnr)
  return parser._lang
end

-- Gets the corresponding documentation site attached to the language name
G.get_docs_url = function(bufnr)
  local file_type = get_filetype(bufnr)
  local docs_url = G.docs_urls[file_type]
  return docs_url
end

return G
