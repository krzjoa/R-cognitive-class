library(magrittr)
library(dplyr)
library(httr)

url <- "https://github.com/r0f1/datascience"

#' 
#' Checks, if the given URL is a Github URL
#' If not, it returns README download URL using Github v3 API
#' @param url Url to the library
#' 
as_raw_github <- function(url){
  if(grepl("(https://)?raw.githubusercontent.com.*\\.md", url)) return(url)
  
  url.divided <- stringr::str_match(url, "github.com\\/(.*)\\/(.*)") 
  user.name <- url.divided[,2]
  repo.name <- url.divided[,3]
  
  sprintf("http://api.github.com/repos/%s/%s/readme", user.name, repo.name) %>% 
    GET() %>% 
    content() -> readme
  return(readme$download_url)
}

#' If url is from Github
is_github <- function(url){
  grepl("(https://)?github.com/", url) |
    grepl("(https://)?raw.githubusercontent.com", url)
}

awesome_list <- function(url, github.info = FALSE){
  
    if(!is_github(url))
      print(paste0(url, " is not a corect Github URL."))
  
    # Converting URL to its raw form
    url <- as_raw_github(url)
  
    # Fetching markdown from the Web
    file.content <- suppressWarnings(readLines(url))
    
    # Parsing markdown list
    file.content %>% 
      stringr::str_match("\\[(.*?)\\]\\((.*?)\\).?-(.*\\.)") -> awesome.list
    
    # Removing empty lines
    awesome.list <- awesome.list %>% 
      na.omit() %>% 
      as.data.frame() %>% 
      `colnames<-`(c("original", "name", "url", "description"))
    
    # Username & repo
    awesome.list$url %>% 
      stringr::str_match("github.com\\/(.*)\\/(.*)") %>% 
      as.data.frame() %>% 
      `colnames<-`(c("full.name", "user.name", "repo.name")) %>% 
      select(-full.name) -> awesome.list.urls
    
    awesome.list <- cbind(awesome.list, awesome.list)
    
    return(awesome.list)
}


call_github_api_v3 <- function(user, repo){
  
  # Get basic info about repo
  sprintf("http://api.github.com/repos/%s/%s", user, repo) %>% 
    GET() %>% 
    content() -> basic.info
  
  # Get topics
  sprintf("http://api.github.com/repos/%s/%s/topics", user, repo) %>% 
    GET(accept("application/vnd.github.mercy-preview+json")) %>% 
    content() -> topics
  
  output <- list(
    # Basic info
    github.desc = basic.info$description,
    stars = basic.info$stargazers_count,
    forks = basic.info$forks_count,
    
    # Topics
    topics = paste0(topics %>% unlist(), collapse = ",")
  )
  
  return(output)
}


check_on_github <- function(awesome.list){
  
  awesome.list <- awesome.list %>% 
    mutate(is.github = is_github(url))
  
  
}