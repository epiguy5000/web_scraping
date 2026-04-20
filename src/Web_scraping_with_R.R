# Import libraries
library(tidyverse)
library(rvest) # Basic web scraping with R
library(writexl) # Export excel files
library(reticulate) # Run Python code in R


# Scraping static webpages

## Identify chrome browser location
Sys.setenv(CHROMOTE_CHROME = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe")

## Set working directory
setwd("C:\\Users\\huntmat\\Documents\\Tutorials\\Web scraping with R and Python\\web_scraping")

## Read webpage html
url = "https://www.worldometers.info/coronavirus/"
page = read_html(url)

## Scraping tables
tables = page %>% html_nodes("table") %>% html_table()
table1 = tables[[1]]

## Save table for later
write_xlsx(table1,"data\\covid_data.xlsx")

## Scraping text
text = page %>% html_elements("#maincounter-wrap") %>% html_nodes("span") %>% html_text2()

## Scraping emails
url = "data\\Table.html"
page = read_html(url)
tables = page %>% html_nodes("table") %>% html_table()
email_table = tables[[1]]

## Scraping many webpages
url = "https://www.canada.ca/en/public-health/services/diseases/flu-influenza/influenza-surveillance/weekly-influenza-reports.html"
page = read_html(url)
links = page %>% html_nodes("a")
link_text = links %>% html_text2()
link_url = links %>% html_attr("href")

link_data = data.frame(link_text,link_url)
link_data = link_data %>%
  filter(str_detect(link_text,"Weekly report")) %>%
  mutate(
    link_url = paste("https://canada.ca",link_url,sep="")
  )

for(i in 1:nrow(link_data)){ # Loop 1 start
  
  url=link_data$link_url[i]
  text=link_data$link_text[i]
  
  print(paste("Navigating to ",text,sep=""))
  
  page2 = read_html(url)
  links2 = page2 %>% html_nodes("a")
  link_text2 = links2 %>%html_text()
  link_url2 = links2 %>% html_attr("href")
  
  link_data2 = data.frame(link_text2,link_url2)
  link_data2 = link_data2 %>%
    filter(str_detect(link_text2,"\\(week")) %>%
    mutate(
      link_url2 = paste("https://canada.ca",link_url2,sep="")
    )
  
  for(j in 1:nrow(link_data2)){ # Loop 2 start
    url2 = link_data2$link_url2[j]
    text2 = link_data2$link_text2[j]
    print(paste("Navigating to ",text2,sep=""))
    
    tables = read_html(url2) %>% html_nodes("table") %>% html_table()
    
    assign(paste("tables",i,j,sep="_"),tables)
    
  } # Loop 2 end
  
} # Loop 1 end


# Scraping dynamic webpages

url = "https://health-infobase.canada.ca/respiratory-virus-surveillance/influenza.html"

## Static method (does not work)
page = read_html(url)
tables = page %>% html_nodes("table") %>% html_table()

## Web scraping in Python
source_python("src\\Web_scraping_with_Python.py")

## Import tables
for(i in 0:11){
  tryCatch({
    assign(
      paste("table",i,sep="_"),
      read.csv(paste("data\\table_",i,".csv",sep=""))
    )
  }, error=function(e){})
}

