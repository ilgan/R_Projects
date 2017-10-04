library(gapminder)
library(tidyverse)
library(knitr)
library(dplyr)
# Is it a data.frame, a matrix, a vector, a list?

typeof(gapminder) #list
head(gapminder) 

# How many variables/columns?
# How many rows/observations?
# Can you get these facts about “extent” or “size” in more than one way? 

dim(gapminder)  # rows x cols: 1704x6
ncol(gapminder) # 6
nrow(gapminder) # 1704

# What data type is each variable?
typeof(gapminder$country)   # integer
typeof(gapminder$continent) # integer
typeof(gapminder$year)      # integer
typeof(gapminder$lifeExp)   # double
typeof(gapminder$pop)       # integer
typeof(gapminder$gdpPercap) # double

# What are possible values (or range, whichever is appropriate) of each variable?
summary(gapminder$year)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1952    1966    1980    1980    1993    2007

# What values are typical? What’s the spread? What’s the distribution? Etc., tailored to the variable at hand.
# Mean: 1980, spread: from 1952 till 2007

# Distribution:
hist(gapminder$year)

# A scatterplot of two quantitative variables.
ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_point()
ggplot(gapminder, aes(x = year, y = gdpPercap)) + geom_point()

# A plot of one quantitative variable. Maybe a histogram or densityplot or frequency polygon.
hist(gapminder$lifeExp)

# A plot of one quantitative variable and one categorical. Maybe boxplots for several continents or countries.
ggplot(gapminder, aes(x = continent, y = lifeExp)) + geom_boxplot()

# Use filter() to create data subsets that you want to plot.
filter(gapminder, continent=="Asia" & pop>=2.960e+07)
filter(gapminder, continent=="Asia")

# Practice piping together filter() and select(). Possibly even piping into ggplot().
gapminder %>% 
  filter(continent=="Asia" & pop>=2.960e+07) %>% 
  select(-gdpPercap)

filter(gapminder, country %in% c("Rwanda", "Afghanistan"))
filter(gapminder, country == c("Rwanda", "Afghanistan"))

gapminder %>% 
  filter(country %in% c("Rwanda", "Afghanistan")) %>% 
  kable(., format = "markdown", caption = "Title of the table")

gapminder %>% 
  filter(continent=="Asia" & pop>=2.960e+07) %>% 
  select(-pop) %>% 
  mutate(developpedCountries = gdpPercap>20000) %>% 
  kable(., format = "markdown", caption = "Kable Rmd Good Looking Table")


