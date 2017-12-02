library(tidyverse)
library(magrittr)
library(purrr)
library(glue)
library(stringr)
library(purrr)
library(rvest)
library(xml2)
library(httr)

movies_list <- c("babe", "thor", "spiderman")
movie_content <- data.frame()

for (i in 1:length(movies_list)){
	if (i == 1){
		query_string <- glue("http://www.omdbapi.com/?t={movies_list[i]}&apikey=33ffee5e")
		movie_result <- httr::GET(query_string)
		movie_content <- as.data.frame(content(movie_result))
	}
	else{
		query_string <- glue("http://www.omdbapi.com/?t={movies_list[i]}&apikey=33ffee5e")
		movie_result <- httr::GET(query_string)
		movie_content <- full_join(movie_content, as.data.frame(content(movie_result)), by = colnames(as.data.frame(content(movie_result))))
	}
	i
}
View(movie_content)




countries <- str_split(movie_info$Country, ",")
loc <- geocode(as.character(countries))
m <- leaflet() %>%
	addTiles() %>%  # Add default OpenStreetMap map tiles
	addMarkers(lng=loc$lon, lat=loc$lat, popup="Movie Location")
return(m)

col_names <- colnames(movies)
movie_info2 <- get_movie2("transformers", "2007")
View(movie_info2)

query_string <- glue("https://api.themoviedb.org/3/search/movie?api_key=ae1992621fc683b8b15c4a9bef59b8bb&query=Jack+Reacher")
movie_result <- httr::GET(query_string)
movie_content <- as.data.frame(content(movie_result))
View(content(movie_result))

ae1992621fc683b8b15c4a9bef59b8bb

query_string <- glue("http://www.theimdbapi.org/api/find/movie?title=transformers&year=2007")

query_string <- glue("http://www.theimdbapi.org/api/find/movie?title=transformers&year=2007")
movie_result <- httr::GET(query_string)
movie_content <- as.data.frame(content(movie_result)[[1]])

typeof(movie_info2)
View(content(movie_result)[[1]])

full_join(movie_content, as.data.frame(content(movie_result)), by = colnames(as.data.frame(content(movie_result))))
content(movie_result)[[1]]
