HW4
================
iganelin
October 4, 2017

Homework 4
==========

### Loading libraries

``` r
library(gapminder)
library(tidyverse)
```

    ## Warning: package 'tidyverse' was built under R version 3.4.2

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Warning: package 'tidyr' was built under R version 3.4.2

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

``` r
library(knitr)
library(dplyr)
```

Activity \#1: Minimal guide to tidyr
------------------------------------

This is a minimal guide, mostly for myself, to remind me of the most import tidyr functions **gather** and **spread** functions that I'm familiar with. Also check out [A tidyr Tutorial](http://data.library.virginia.edu/a-tidyr-tutorial/).

Start with installing the package using following commands **install.packages("tidyverse")** and **install.packages("tidyr")**.

We will be using the **gapminder** data as our input. - Firstly, let's create a data frame to manipulate with:

``` r
dp <- gapminder %>%
  group_by(continent) %>% 
  summarize(mean_gdpPercap = mean(gdpPercap),
              n_countries    = length(gdpPercap))

continents <- data.frame(
   continent = dp$continent,
   meanGdp   = dp$mean_gdpPercap,
   n_countries = dp$n_countries)
continents 
```

    ##   continent   meanGdp n_countries
    ## 1    Africa  2193.755         624
    ## 2  Americas  7136.110         300
    ## 3      Asia  7902.150         396
    ## 4    Europe 14469.476         360
    ## 5   Oceania 18621.609          24

-   The help page for gather says that it “takes multiple columns and collapses into key-value pairs, duplicating all other columns as needed”

``` r
continentsG <- gather(data = continents, key = continent, value = meanGdp)
continentsG
```

    ##   continent   meanGdp   continent meanGdp
    ## 1    Africa  2193.755 n_countries     624
    ## 2  Americas  7136.110 n_countries     300
    ## 3      Asia  7902.150 n_countries     396
    ## 4    Europe 14469.476 n_countries     360
    ## 5   Oceania 18621.609 n_countries      24

...or as we call it "melting data". ![](melting.png)

Activity \#2: Make a tibble with one row per year and columns for life expectancy for two or more countries.
------------------------------------------------------------------------------------------------------------

-   A tibble with *year* as a measure, *gdpPercap* as a value for Canada and Australia.

``` r
leTbl <- select(filter(gapminder, country %in% c("Canada", "Australia")),
      year, country, lifeExp) %>% 
      gather(measure, value, lifeExp) %>% 
      arrange(country, year)
kable(leTbl, format = "markdown", caption = "Life Expectancy in Canada and Australia")
```

|  year| country   | measure |   value|
|-----:|:----------|:--------|-------:|
|  1952| Australia | lifeExp |  69.120|
|  1957| Australia | lifeExp |  70.330|
|  1962| Australia | lifeExp |  70.930|
|  1967| Australia | lifeExp |  71.100|
|  1972| Australia | lifeExp |  71.930|
|  1977| Australia | lifeExp |  73.490|
|  1982| Australia | lifeExp |  74.740|
|  1987| Australia | lifeExp |  76.320|
|  1992| Australia | lifeExp |  77.560|
|  1997| Australia | lifeExp |  78.830|
|  2002| Australia | lifeExp |  80.370|
|  2007| Australia | lifeExp |  81.235|
|  1952| Canada    | lifeExp |  68.750|
|  1957| Canada    | lifeExp |  69.960|
|  1962| Canada    | lifeExp |  71.300|
|  1967| Canada    | lifeExp |  72.130|
|  1972| Canada    | lifeExp |  72.880|
|  1977| Canada    | lifeExp |  74.210|
|  1982| Canada    | lifeExp |  75.760|
|  1987| Canada    | lifeExp |  76.860|
|  1992| Canada    | lifeExp |  77.950|
|  1997| Canada    | lifeExp |  78.610|
|  2002| Canada    | lifeExp |  79.770|
|  2007| Canada    | lifeExp |  80.653|

-   A scatterplot of life expectancy for Canada against Australia.

``` r
ggplot(leTbl, aes(x=year, y=value, colour=country))+
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Year") +
  scale_y_continuous("Life Expectancy") +
  labs(title = "Life Expectancy in Canada and Australia") +
  theme_classic()
```

    ## `geom_smooth()` using method = 'loess'

![](HW4_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-5-1.png)

-   We can see from the scatterplot that from 1958 and until 1999 the life expectancy in Canada was higher.

Activity \#3 Compute some measure of life expectancy.
-----------------------------------------------------
