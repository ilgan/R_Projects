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
