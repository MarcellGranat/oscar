library(tidyverse)
library(rvest)

oscar_df <- tibble()

i <- 1
go <- TRUE
while (go) {
  if (i == 1) {
    url <- "https://utitars.oszkar.com/date-2021-10-14/"
  } else {
    url <- str_c("https://utitars.oszkar.com/date-2021-10-14/pageexact-", i -1, "#exact")
  }
  
  message(url)
  
  page <- read_html(url)
  
  go <- page %>% 
    html_nodes(".light-button") %>% 
    html_text() %>% 
    {!all(parse_number(.) == c(2, 3, 4, 5))} | i == 1
  
  if (go) {
    
  trip_data <- page %>% 
    html_nodes(".span8 a") 
  
  trip_url <- trip_data %>% 
    html_attr("href")
  
  trip_data <- trip_data %>% 
    html_text() %>% 
    str_remove_all("\\\r|\\\n|\\\t")
  
  user <- page %>% 
    html_nodes("img+ .rating-star-value") %>% 
    html_text()
  
  oscar_df <- tibble(trip_url, trip_data, user) %>% 
    bind_rows(oscar_df)
  
  }
  
  i <- i + 1
  print(oscar_df)
  
}

