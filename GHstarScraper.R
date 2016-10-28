library(rvest)
library(purrr)

Link <- "https://github.com/qinwf/awesome-R"

## Get entries with github links, and then the links themselves
FullPage <- read_html(Link)
MyPart <- html_nodes(FullPage,"#readme li a")
withGHlinks <- MyPart[grep("//github",MyPart)]
justLinks <- html_attr(withGHlinks,"href")

## Function to get stars per repository, in numeric 
## In case of numeric (starless), return 0
getter <- function(x){
  a <- as.numeric(gsub("[^\\d]","",html_text(html_nodes(read_html(x),".js-social-count")),perl=T))
  if (length(a) == 0) {a=0}
  a
}

## Get stars!
stars <- map_dbl(justLinks,getter)

## Now make df with all entries with github links and the stars of those links
df <- data.frame(links = as.character(withGHlinks), stars = stars,stringsAsFactors = F)

## Over 400? Add a star to the list of links that contains
df$links2 <- df$links
df$links2[df$stars>400] <-
  gsub('</','<img class="emoji" alt="star" src="https://awesome-r.com/star.png" height="20" align="absmiddle" width="20"> </',df$links[df$stars>400])

## Now go get the readme.md
readMe <- readLines("README.md")

## Replacer function
starrer <- function(x,y){
  gsub()
  
}
gsub(df$links,df$links2,readMe)
