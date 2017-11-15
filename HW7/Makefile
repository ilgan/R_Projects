## Make file to get the data of teh internet, clean it, analyse, and save a few plots out of it.

all: 4_wind_data.md

clean:
	rm -f clean_wind_data.csv

#Dowload teh raw wind data
wind_data.csv:
	Rscript 1_download_wind_data.R

#Clean the raw wind data and save it
clean_wind_data.csv: wind_data.csv
	Rscript 2_clean_wind_data.r

#Save a few useful graphs
my_plot.png: clean_wind_data.csv
	Rscript 3_plot_wind_data.r

#Run a PCA and linear regression analysis, save a Variance graph
4_wind_data.md: clean_wind_data.csv
	Rscript -e 'rmarkdown::render("4_wind_data.rmd")'

