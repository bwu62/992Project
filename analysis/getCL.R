# to be run on CHTC cluster to get country info

f = read.delim( (filename<-list.files(".",pattern="titles.*")) ,header=F)[[1]]

suppressMessages(library(rvest))

getCountryLanguage = function(tconst){
  browser()
  tryCatch({
    details = read_html(paste0("https://www.imdb.com/title/",tconst)) %>% 
      html_nodes(xpath='//div[@id="titleDetails"]') %>% 
      html_nodes("a")
    details %>% grep("country_of_origin",.,value=T) %>% 
      sub("^.+>([^<]+)<.+$","\\1",.) %>% 
      setdiff("None") %>% 
      paste(collapse="/") -> 
      countries
    details %>% grep("primary_language",.,value=T) %>% 
      sub("^.+>([^<]+)<.+$","\\1",.) %>% 
      setdiff("None") %>% 
      paste(collapse="/") -> 
      languages
    return(c(countries,languages))
  },error=function(e){
    print(sprintf("ERROR %s : %s",tconst,e$message))
    return(c("NA","NA"))
  })
}
