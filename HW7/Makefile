## Make file to get the data of the internet, clean it, analyse, and save a few plots out of it.

all: 4_wind_data.md HW7.md

clean:
	rm -f clean_wind_data.csv

#Dowload the raw wind data
wind_data.csv:
	Rscript 1_download_wind_data.R

#Clean the raw wind data and save it
clean_wind_data.csv: wind_data.csv
	Rscript 2_clean_wind_data.r

#Save a few useful graphs
my_plot.png: clean_wind_data.csv _plot_wind_data.r
	Rscript 3_plot_wind_data.r

#Run a PCA and linear regression analysis, save a Variance graph
4_wind_data.md: clean_wind_data.csv 4_wind_data.rmd
	Rscript -e 'rmarkdown::render("4_wind_data.rmd")'

#Just to have a main HW7.md file for the future project development
HW7.md: 4_wind_data.md HW7.rmd
	Rscript -e 'rmarkdown::render("HW7.rmd")'