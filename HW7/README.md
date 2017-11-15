# STAT545-hw07-ganelin-ilya

## In the folder

### Script Files:

- [HW7](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/HW7.md)
- [HW7.Rmd](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/HW7.Rmd)

### Files that the scripts creates:

- [HW7 media files](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/media)
- And some plots are [here](https://github.com/ilgan/STAT545-hw-ganelin-ilya/tree/master/HW7/4_wind_data_files/figure-markdown_github-ascii_identifiers)

### Excersice Pipeline

- First script: download some data: [1_download_wind_data.r](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/1_download_wind_data.r)
- Second script: read the data, perform some analysis and write numerical data to file in CSV or TSV forma: [2_clean_wind_data.r](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/2_clean_wind_data.r)
- Third script: read the output of the second script, generate some figures and save them to files: [3_plot_wind_data.rmd](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/3_plot_wind_data.rmd)
- Fourth script: an Rmd, actually, that presents original data, the statistical summaries, and/or the figures in a little report: [4_wind_data.rmd](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/4_wind_data.rmd)
- A fifth script to rule them all, i.e. to run the others in sequence: [Makefile](https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW7/Makefile)

### Notes:

- Had some issues with the saving and reading the files, due to the hierarchy of the folder structure that I have.

- Yuuuge Thanks to @ksedivyhaley who kindly helped with the issue!

Thank you!