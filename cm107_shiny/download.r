library(downloader)
download(url = "https://i.ytimg.com/vi/w6DW4i-mfbA/hqdefault.jpg", destfile = "www/kitten.jpg")

url_kitten <- "https://i.ytimg.com/vi/w6DW4i-mfbA/hqdefault.jpg"
download.file(url_kitten, "www/kitten.jpg")
