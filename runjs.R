# # Explanation here: https://www.r-bloggers.com/web-scraping-javascript-rendered-sites/

mongo_connect = function(collectionName, dbName) {
  # Cred
  hostName = "mongodb://fdrennan:thirdday1@drenr.com:27017"
  
  m <- mongolite::mongo(collection = collectionName , 
                        db = dbName, 
                        url = hostName)
  
  m
}

m = mongo_connect('bnb', 'datasets')

library(tidyverse)
library(rvest)
library(stringr)

source("scrapeJs.R")
source("functions.R")

lat = 50
long = 50
zoom = 9

site = "https://www.airbnb.com/s/homes?allow_override%5B%5D=&refinement_paths%5B%5D=%2Fhomes&ne_lat=30.97855687613024&ne_lng=-97.19728718511101&sw_lat=29.90656374808267&sw_lng=-98.21626911870476&search_by_map=true&zoom=9&s_tag=l5HL7UMh&section_offset="
site = paste0(site, 7:16)
output = "website.html"


for(i in seq_along(site)) {
  print(paste0("Getting Site:", i))
  scrapeJs(siteName = site[i], outputName = output)
  
  locations <-
    read_html(output) %>%
    html_nodes("._1rths372") %>%
    html_text()
  
  prices <-
    read_html(output) %>%
    html_nodes("span span ._hylizj6 span") %>%
    html_text() %>% 
    remove_if("Price")
  
  ######
  
  ### House specific data
  page_tibble <-
    tibble(
      locations = locations,
      prices    = prices,
      links     = NA
    )
  print("Getting Locations")
  for(j in seq_along(locations)) {
    print(paste0("Getting location ", j))
    search.url <- getGoogleURL(search.term=locations[j], quotes="TRUE")
    
    links <- getGoogleLinks(search.url)[1]
    
    link <-
      links %>% 
      str_sub(start = 16) %>% 
      gsub("&.*", "", .)
    
    page_tibble[j,3] = link
    print(page_tibble)
  }
  
  
  page_tibble <-
    page_tibble %>% 
    mutate(
      is_bnb = str_detect(links, "www.airbnb.com/rooms")
    ) %>% 
    filter(is_bnb)
  
  if(i == 1) {
    page_tibble_df = page_tibble
  } else {
    page_tibble_df = bind_rows(page_tibble_df, page_tibble)
  }
  page_tibble$time = Sys.time()
  page_tibble$i = i
  page_tibble$j = j
  m$insert(page_tibble)
  print(page_tibble_df)
}




