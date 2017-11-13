#wind_data.csv:
#	curl -o wind_data.csv https://raw.githubusercontent.com/ilgan/STAT545-hw-ganelin-ilya/master/HW6/10.0.103.10.csv
	
wind_data.csv:
	Rscript download_wind_data.R
	
#clean_wind_data.csv: wind_data.csv
#	Rscript -e 'rmarkdown::render("clean_wind_data.rmd")'

clean_wind_data.csv: wind_data.csv
	Rscript clean_wind_data.r
	
my_plot.png: wind_data_cleaned.csv
	Rscript -e 'rmarkdown::render("plot_wind_data.rmd")'