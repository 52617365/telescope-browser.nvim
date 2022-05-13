local opts = {}
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
opts.docs = {
  ["lua"] = [["https://www.google.com/search?q=%s&as_sitesearch=lua.org/manual/5.4"]],
  ["rust"] = [["https://doc.rust-lang.org/std/index.html?search=%s"]],
  ["cpp"] = [["https://www.google.com/search?q=%s&as_sitesearch=cppreference.com"]],
  ["c"] = [["https://www.google.com/search?q=%s&as_sitesearch=cppreference.com"]],
  ["java"] = [["https://docs.oracle.com/search/?q=%s&category=java&product=en%3Fjava"]],
  ["javascript"] = [["https://developer.mozilla.org/en-US/search?q=%s"]],
  ["php"] = [["https://www.php.net/manual-lookup.php?pattern=%s&scope=quickref"]],
  ["vim"] = [["https://vim.fandom.com/wiki/Special:Search?query=%s&scope=internal&contentType=&ns%5B0%5D=0"]],
  ["kotlin"] = [["https://kotlinlang.org/docs/home.html?q=%s&s=full"]],
}

return opts
