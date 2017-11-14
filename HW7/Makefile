all: 

wind_data.csv:
	Rscript 1_download_wind_data.R
	
clean_wind_data.csv: wind_data.csv
	Rscript 2_clean_wind_data.r
	
my_plot.png: clean_wind_data.csv
	Rscript 3_plot_wind_data.r
	
wind_data.md: clean_wind_data.csv
	Rscript -e 'rmarkdown::render("4_wind_data.rmd")'
	
clean:
	rm -f *.csv *.png