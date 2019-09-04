library(magrittr)
library(rvest)

site.url <- 'https://github.com/krzjoa/awesome-python-data-science/blob/master/README.md'
site.url2 <- 'https://raw.githubusercontent.com/krzjoa/awesome-python-data-science/master/README.md'

#' If url is from Github
is_github_url <- function(url){
  
}

get_list2 <- function(url){
  file.content <- suppressWarnings(readLines(site.url2))
  file.content %>% sapply(function(x) stringr::str_match(x, "\\(.*\\)")) %>% View
    #stringr::str_match_all("[\\(\\)]") %>% View
}

get_list <- function(url){
    file.content <- suppressWarnings(readLines(site.url2))
    
    file.content %>% stringr::str_replace_all("[\r\n]" , "")
    
    commonmark::markdown_xml(file.content) -> cnt
    cnt %>% stringr::str_replace_all("[\r\n]" , "")
    xml2::xml_find_all(xmldoc$doc, ".//bullet")
}
