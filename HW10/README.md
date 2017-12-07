# STAT545-hw-ganelin-ilya
# HW10: Web Scraping


### Data set
We collect data from a several sources for this project:
- [Open Weather API](https://openweathermap.org/api)
- [OMDb API](https://www.omdbapi.com/)

### Features
I decided to use in conjunction a few data scparing modules. A few functoins were created starting from the simple one that downloads the information for just one movie and outputs the dataframe with it. The next step was to extend this function so the user could download the information for multiple movies of his choice.
In order to integrate it with anothe data set, I decided to download the current weather from Open Weather API for the movie location.

#### Plots:
- The map of teh movie locations
- Rating for movies of interest

### Notes
The initial idea was to collect the movie info from a multiple soutces and join them together into one large data base, but I neded the API and stil wating for the owners of the web services to approve my request. I wrote the function at teh bottom of the .md file. These functions are active and worked at testing stage. Personally this is one of the most important lessons, as the scraping data is a powerful tool to have. In conjunction with the NOSQL databases (jsons) it really helped me before.

### API Keys
Please use them wisely. Do not copy. I decided to provide them upon request (just send me an email) for the test purposes to save your time.

The keys that are provided in the code, will be deleted at the end of the month from the code.

Happy Holidays and Good Luck with the Exams!!!