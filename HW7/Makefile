wind_data.csv:
	curl -o wind_data.csv https://raw.githubusercontent.com/ilgan/STAT545-hw-ganelin-ilya/master/HW6/10.0.103.10.csv
	
wind_data.csv: wind_data_cleaned.csv clean_wind_data.rmd
	Rscript -e 'rmarkdown::render("clean_wind_data.rmd")'
	
wind_data_cleaned.csv: wind_data_cleaned.csv
	Rscript -e 'rmarkdown::render("plot_wind_data.rmd")'