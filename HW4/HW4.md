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

Data Reshaping
==============

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
#kable(leTbl, format = "markdown", caption = "Life Expectancy in Canada and Australia")

knitr::kable(leTbl)
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

Activity \#3
------------

-   Compute some measure of life expectancy for all possible combinations of continent and year.

``` r
td.gapminder <- gapminder %>% 
  select (-c(country, pop, gdpPercap)) %>% 
  group_by(continent) %>% 
  mutate(meanLifeExp=mean(lifeExp)) %>% 
  gather(measure, value, lifeExp)
knitr::kable(td.gapminder)
```

| continent |  year|  meanLifeExp| measure |     value|
|:----------|-----:|------------:|:--------|---------:|
| Asia      |  1952|     60.06490| lifeExp |  28.80100|
| Asia      |  1957|     60.06490| lifeExp |  30.33200|
| Asia      |  1962|     60.06490| lifeExp |  31.99700|
| Asia      |  1967|     60.06490| lifeExp |  34.02000|
| Asia      |  1972|     60.06490| lifeExp |  36.08800|
| Asia      |  1977|     60.06490| lifeExp |  38.43800|
| Asia      |  1982|     60.06490| lifeExp |  39.85400|
| Asia      |  1987|     60.06490| lifeExp |  40.82200|
| Asia      |  1992|     60.06490| lifeExp |  41.67400|
| Asia      |  1997|     60.06490| lifeExp |  41.76300|
| Asia      |  2002|     60.06490| lifeExp |  42.12900|
| Asia      |  2007|     60.06490| lifeExp |  43.82800|
| Europe    |  1952|     71.90369| lifeExp |  55.23000|
| Europe    |  1957|     71.90369| lifeExp |  59.28000|
| Europe    |  1962|     71.90369| lifeExp |  64.82000|
| Europe    |  1967|     71.90369| lifeExp |  66.22000|
| Europe    |  1972|     71.90369| lifeExp |  67.69000|
| Europe    |  1977|     71.90369| lifeExp |  68.93000|
| Europe    |  1982|     71.90369| lifeExp |  70.42000|
| Europe    |  1987|     71.90369| lifeExp |  72.00000|
| Europe    |  1992|     71.90369| lifeExp |  71.58100|
| Europe    |  1997|     71.90369| lifeExp |  72.95000|
| Europe    |  2002|     71.90369| lifeExp |  75.65100|
| Europe    |  2007|     71.90369| lifeExp |  76.42300|
| Africa    |  1952|     48.86533| lifeExp |  43.07700|
| Africa    |  1957|     48.86533| lifeExp |  45.68500|
| Africa    |  1962|     48.86533| lifeExp |  48.30300|
| Africa    |  1967|     48.86533| lifeExp |  51.40700|
| Africa    |  1972|     48.86533| lifeExp |  54.51800|
| Africa    |  1977|     48.86533| lifeExp |  58.01400|
| Africa    |  1982|     48.86533| lifeExp |  61.36800|
| Africa    |  1987|     48.86533| lifeExp |  65.79900|
| Africa    |  1992|     48.86533| lifeExp |  67.74400|
| Africa    |  1997|     48.86533| lifeExp |  69.15200|
| Africa    |  2002|     48.86533| lifeExp |  70.99400|
| Africa    |  2007|     48.86533| lifeExp |  72.30100|
| Africa    |  1952|     48.86533| lifeExp |  30.01500|
| Africa    |  1957|     48.86533| lifeExp |  31.99900|
| Africa    |  1962|     48.86533| lifeExp |  34.00000|
| Africa    |  1967|     48.86533| lifeExp |  35.98500|
| Africa    |  1972|     48.86533| lifeExp |  37.92800|
| Africa    |  1977|     48.86533| lifeExp |  39.48300|
| Africa    |  1982|     48.86533| lifeExp |  39.94200|
| Africa    |  1987|     48.86533| lifeExp |  39.90600|
| Africa    |  1992|     48.86533| lifeExp |  40.64700|
| Africa    |  1997|     48.86533| lifeExp |  40.96300|
| Africa    |  2002|     48.86533| lifeExp |  41.00300|
| Africa    |  2007|     48.86533| lifeExp |  42.73100|
| Americas  |  1952|     64.65874| lifeExp |  62.48500|
| Americas  |  1957|     64.65874| lifeExp |  64.39900|
| Americas  |  1962|     64.65874| lifeExp |  65.14200|
| Americas  |  1967|     64.65874| lifeExp |  65.63400|
| Americas  |  1972|     64.65874| lifeExp |  67.06500|
| Americas  |  1977|     64.65874| lifeExp |  68.48100|
| Americas  |  1982|     64.65874| lifeExp |  69.94200|
| Americas  |  1987|     64.65874| lifeExp |  70.77400|
| Americas  |  1992|     64.65874| lifeExp |  71.86800|
| Americas  |  1997|     64.65874| lifeExp |  73.27500|
| Americas  |  2002|     64.65874| lifeExp |  74.34000|
| Americas  |  2007|     64.65874| lifeExp |  75.32000|
| Oceania   |  1952|     74.32621| lifeExp |  69.12000|
| Oceania   |  1957|     74.32621| lifeExp |  70.33000|
| Oceania   |  1962|     74.32621| lifeExp |  70.93000|
| Oceania   |  1967|     74.32621| lifeExp |  71.10000|
| Oceania   |  1972|     74.32621| lifeExp |  71.93000|
| Oceania   |  1977|     74.32621| lifeExp |  73.49000|
| Oceania   |  1982|     74.32621| lifeExp |  74.74000|
| Oceania   |  1987|     74.32621| lifeExp |  76.32000|
| Oceania   |  1992|     74.32621| lifeExp |  77.56000|
| Oceania   |  1997|     74.32621| lifeExp |  78.83000|
| Oceania   |  2002|     74.32621| lifeExp |  80.37000|
| Oceania   |  2007|     74.32621| lifeExp |  81.23500|
| Europe    |  1952|     71.90369| lifeExp |  66.80000|
| Europe    |  1957|     71.90369| lifeExp |  67.48000|
| Europe    |  1962|     71.90369| lifeExp |  69.54000|
| Europe    |  1967|     71.90369| lifeExp |  70.14000|
| Europe    |  1972|     71.90369| lifeExp |  70.63000|
| Europe    |  1977|     71.90369| lifeExp |  72.17000|
| Europe    |  1982|     71.90369| lifeExp |  73.18000|
| Europe    |  1987|     71.90369| lifeExp |  74.94000|
| Europe    |  1992|     71.90369| lifeExp |  76.04000|
| Europe    |  1997|     71.90369| lifeExp |  77.51000|
| Europe    |  2002|     71.90369| lifeExp |  78.98000|
| Europe    |  2007|     71.90369| lifeExp |  79.82900|
| Asia      |  1952|     60.06490| lifeExp |  50.93900|
| Asia      |  1957|     60.06490| lifeExp |  53.83200|
| Asia      |  1962|     60.06490| lifeExp |  56.92300|
| Asia      |  1967|     60.06490| lifeExp |  59.92300|
| Asia      |  1972|     60.06490| lifeExp |  63.30000|
| Asia      |  1977|     60.06490| lifeExp |  65.59300|
| Asia      |  1982|     60.06490| lifeExp |  69.05200|
| Asia      |  1987|     60.06490| lifeExp |  70.75000|
| Asia      |  1992|     60.06490| lifeExp |  72.60100|
| Asia      |  1997|     60.06490| lifeExp |  73.92500|
| Asia      |  2002|     60.06490| lifeExp |  74.79500|
| Asia      |  2007|     60.06490| lifeExp |  75.63500|
| Asia      |  1952|     60.06490| lifeExp |  37.48400|
| Asia      |  1957|     60.06490| lifeExp |  39.34800|
| Asia      |  1962|     60.06490| lifeExp |  41.21600|
| Asia      |  1967|     60.06490| lifeExp |  43.45300|
| Asia      |  1972|     60.06490| lifeExp |  45.25200|
| Asia      |  1977|     60.06490| lifeExp |  46.92300|
| Asia      |  1982|     60.06490| lifeExp |  50.00900|
| Asia      |  1987|     60.06490| lifeExp |  52.81900|
| Asia      |  1992|     60.06490| lifeExp |  56.01800|
| Asia      |  1997|     60.06490| lifeExp |  59.41200|
| Asia      |  2002|     60.06490| lifeExp |  62.01300|
| Asia      |  2007|     60.06490| lifeExp |  64.06200|
| Europe    |  1952|     71.90369| lifeExp |  68.00000|
| Europe    |  1957|     71.90369| lifeExp |  69.24000|
| Europe    |  1962|     71.90369| lifeExp |  70.25000|
| Europe    |  1967|     71.90369| lifeExp |  70.94000|
| Europe    |  1972|     71.90369| lifeExp |  71.44000|
| Europe    |  1977|     71.90369| lifeExp |  72.80000|
| Europe    |  1982|     71.90369| lifeExp |  73.93000|
| Europe    |  1987|     71.90369| lifeExp |  75.35000|
| Europe    |  1992|     71.90369| lifeExp |  76.46000|
| Europe    |  1997|     71.90369| lifeExp |  77.53000|
| Europe    |  2002|     71.90369| lifeExp |  78.32000|
| Europe    |  2007|     71.90369| lifeExp |  79.44100|
| Africa    |  1952|     48.86533| lifeExp |  38.22300|
| Africa    |  1957|     48.86533| lifeExp |  40.35800|
| Africa    |  1962|     48.86533| lifeExp |  42.61800|
| Africa    |  1967|     48.86533| lifeExp |  44.88500|
| Africa    |  1972|     48.86533| lifeExp |  47.01400|
| Africa    |  1977|     48.86533| lifeExp |  49.19000|
| Africa    |  1982|     48.86533| lifeExp |  50.90400|
| Africa    |  1987|     48.86533| lifeExp |  52.33700|
| Africa    |  1992|     48.86533| lifeExp |  53.91900|
| Africa    |  1997|     48.86533| lifeExp |  54.77700|
| Africa    |  2002|     48.86533| lifeExp |  54.40600|
| Africa    |  2007|     48.86533| lifeExp |  56.72800|
| Americas  |  1952|     64.65874| lifeExp |  40.41400|
| Americas  |  1957|     64.65874| lifeExp |  41.89000|
| Americas  |  1962|     64.65874| lifeExp |  43.42800|
| Americas  |  1967|     64.65874| lifeExp |  45.03200|
| Americas  |  1972|     64.65874| lifeExp |  46.71400|
| Americas  |  1977|     64.65874| lifeExp |  50.02300|
| Americas  |  1982|     64.65874| lifeExp |  53.85900|
| Americas  |  1987|     64.65874| lifeExp |  57.25100|
| Americas  |  1992|     64.65874| lifeExp |  59.95700|
| Americas  |  1997|     64.65874| lifeExp |  62.05000|
| Americas  |  2002|     64.65874| lifeExp |  63.88300|
| Americas  |  2007|     64.65874| lifeExp |  65.55400|
| Europe    |  1952|     71.90369| lifeExp |  53.82000|
| Europe    |  1957|     71.90369| lifeExp |  58.45000|
| Europe    |  1962|     71.90369| lifeExp |  61.93000|
| Europe    |  1967|     71.90369| lifeExp |  64.79000|
| Europe    |  1972|     71.90369| lifeExp |  67.45000|
| Europe    |  1977|     71.90369| lifeExp |  69.86000|
| Europe    |  1982|     71.90369| lifeExp |  70.69000|
| Europe    |  1987|     71.90369| lifeExp |  71.14000|
| Europe    |  1992|     71.90369| lifeExp |  72.17800|
| Europe    |  1997|     71.90369| lifeExp |  73.24400|
| Europe    |  2002|     71.90369| lifeExp |  74.09000|
| Europe    |  2007|     71.90369| lifeExp |  74.85200|
| Africa    |  1952|     48.86533| lifeExp |  47.62200|
| Africa    |  1957|     48.86533| lifeExp |  49.61800|
| Africa    |  1962|     48.86533| lifeExp |  51.52000|
| Africa    |  1967|     48.86533| lifeExp |  53.29800|
| Africa    |  1972|     48.86533| lifeExp |  56.02400|
| Africa    |  1977|     48.86533| lifeExp |  59.31900|
| Africa    |  1982|     48.86533| lifeExp |  61.48400|
| Africa    |  1987|     48.86533| lifeExp |  63.62200|
| Africa    |  1992|     48.86533| lifeExp |  62.74500|
| Africa    |  1997|     48.86533| lifeExp |  52.55600|
| Africa    |  2002|     48.86533| lifeExp |  46.63400|
| Africa    |  2007|     48.86533| lifeExp |  50.72800|
| Americas  |  1952|     64.65874| lifeExp |  50.91700|
| Americas  |  1957|     64.65874| lifeExp |  53.28500|
| Americas  |  1962|     64.65874| lifeExp |  55.66500|
| Americas  |  1967|     64.65874| lifeExp |  57.63200|
| Americas  |  1972|     64.65874| lifeExp |  59.50400|
| Americas  |  1977|     64.65874| lifeExp |  61.48900|
| Americas  |  1982|     64.65874| lifeExp |  63.33600|
| Americas  |  1987|     64.65874| lifeExp |  65.20500|
| Americas  |  1992|     64.65874| lifeExp |  67.05700|
| Americas  |  1997|     64.65874| lifeExp |  69.38800|
| Americas  |  2002|     64.65874| lifeExp |  71.00600|
| Americas  |  2007|     64.65874| lifeExp |  72.39000|
| Europe    |  1952|     71.90369| lifeExp |  59.60000|
| Europe    |  1957|     71.90369| lifeExp |  66.61000|
| Europe    |  1962|     71.90369| lifeExp |  69.51000|
| Europe    |  1967|     71.90369| lifeExp |  70.42000|
| Europe    |  1972|     71.90369| lifeExp |  70.90000|
| Europe    |  1977|     71.90369| lifeExp |  70.81000|
| Europe    |  1982|     71.90369| lifeExp |  71.08000|
| Europe    |  1987|     71.90369| lifeExp |  71.34000|
| Europe    |  1992|     71.90369| lifeExp |  71.19000|
| Europe    |  1997|     71.90369| lifeExp |  70.32000|
| Europe    |  2002|     71.90369| lifeExp |  72.14000|
| Europe    |  2007|     71.90369| lifeExp |  73.00500|
| Africa    |  1952|     48.86533| lifeExp |  31.97500|
| Africa    |  1957|     48.86533| lifeExp |  34.90600|
| Africa    |  1962|     48.86533| lifeExp |  37.81400|
| Africa    |  1967|     48.86533| lifeExp |  40.69700|
| Africa    |  1972|     48.86533| lifeExp |  43.59100|
| Africa    |  1977|     48.86533| lifeExp |  46.13700|
| Africa    |  1982|     48.86533| lifeExp |  48.12200|
| Africa    |  1987|     48.86533| lifeExp |  49.55700|
| Africa    |  1992|     48.86533| lifeExp |  50.26000|
| Africa    |  1997|     48.86533| lifeExp |  50.32400|
| Africa    |  2002|     48.86533| lifeExp |  50.65000|
| Africa    |  2007|     48.86533| lifeExp |  52.29500|
| Africa    |  1952|     48.86533| lifeExp |  39.03100|
| Africa    |  1957|     48.86533| lifeExp |  40.53300|
| Africa    |  1962|     48.86533| lifeExp |  42.04500|
| Africa    |  1967|     48.86533| lifeExp |  43.54800|
| Africa    |  1972|     48.86533| lifeExp |  44.05700|
| Africa    |  1977|     48.86533| lifeExp |  45.91000|
| Africa    |  1982|     48.86533| lifeExp |  47.47100|
| Africa    |  1987|     48.86533| lifeExp |  48.21100|
| Africa    |  1992|     48.86533| lifeExp |  44.73600|
| Africa    |  1997|     48.86533| lifeExp |  45.32600|
| Africa    |  2002|     48.86533| lifeExp |  47.36000|
| Africa    |  2007|     48.86533| lifeExp |  49.58000|
| Asia      |  1952|     60.06490| lifeExp |  39.41700|
| Asia      |  1957|     60.06490| lifeExp |  41.36600|
| Asia      |  1962|     60.06490| lifeExp |  43.41500|
| Asia      |  1967|     60.06490| lifeExp |  45.41500|
| Asia      |  1972|     60.06490| lifeExp |  40.31700|
| Asia      |  1977|     60.06490| lifeExp |  31.22000|
| Asia      |  1982|     60.06490| lifeExp |  50.95700|
| Asia      |  1987|     60.06490| lifeExp |  53.91400|
| Asia      |  1992|     60.06490| lifeExp |  55.80300|
| Asia      |  1997|     60.06490| lifeExp |  56.53400|
| Asia      |  2002|     60.06490| lifeExp |  56.75200|
| Asia      |  2007|     60.06490| lifeExp |  59.72300|
| Africa    |  1952|     48.86533| lifeExp |  38.52300|
| Africa    |  1957|     48.86533| lifeExp |  40.42800|
| Africa    |  1962|     48.86533| lifeExp |  42.64300|
| Africa    |  1967|     48.86533| lifeExp |  44.79900|
| Africa    |  1972|     48.86533| lifeExp |  47.04900|
| Africa    |  1977|     48.86533| lifeExp |  49.35500|
| Africa    |  1982|     48.86533| lifeExp |  52.96100|
| Africa    |  1987|     48.86533| lifeExp |  54.98500|
| Africa    |  1992|     48.86533| lifeExp |  54.31400|
| Africa    |  1997|     48.86533| lifeExp |  52.19900|
| Africa    |  2002|     48.86533| lifeExp |  49.85600|
| Africa    |  2007|     48.86533| lifeExp |  50.43000|
| Americas  |  1952|     64.65874| lifeExp |  68.75000|
| Americas  |  1957|     64.65874| lifeExp |  69.96000|
| Americas  |  1962|     64.65874| lifeExp |  71.30000|
| Americas  |  1967|     64.65874| lifeExp |  72.13000|
| Americas  |  1972|     64.65874| lifeExp |  72.88000|
| Americas  |  1977|     64.65874| lifeExp |  74.21000|
| Americas  |  1982|     64.65874| lifeExp |  75.76000|
| Americas  |  1987|     64.65874| lifeExp |  76.86000|
| Americas  |  1992|     64.65874| lifeExp |  77.95000|
| Americas  |  1997|     64.65874| lifeExp |  78.61000|
| Americas  |  2002|     64.65874| lifeExp |  79.77000|
| Americas  |  2007|     64.65874| lifeExp |  80.65300|
| Africa    |  1952|     48.86533| lifeExp |  35.46300|
| Africa    |  1957|     48.86533| lifeExp |  37.46400|
| Africa    |  1962|     48.86533| lifeExp |  39.47500|
| Africa    |  1967|     48.86533| lifeExp |  41.47800|
| Africa    |  1972|     48.86533| lifeExp |  43.45700|
| Africa    |  1977|     48.86533| lifeExp |  46.77500|
| Africa    |  1982|     48.86533| lifeExp |  48.29500|
| Africa    |  1987|     48.86533| lifeExp |  50.48500|
| Africa    |  1992|     48.86533| lifeExp |  49.39600|
| Africa    |  1997|     48.86533| lifeExp |  46.06600|
| Africa    |  2002|     48.86533| lifeExp |  43.30800|
| Africa    |  2007|     48.86533| lifeExp |  44.74100|
| Africa    |  1952|     48.86533| lifeExp |  38.09200|
| Africa    |  1957|     48.86533| lifeExp |  39.88100|
| Africa    |  1962|     48.86533| lifeExp |  41.71600|
| Africa    |  1967|     48.86533| lifeExp |  43.60100|
| Africa    |  1972|     48.86533| lifeExp |  45.56900|
| Africa    |  1977|     48.86533| lifeExp |  47.38300|
| Africa    |  1982|     48.86533| lifeExp |  49.51700|
| Africa    |  1987|     48.86533| lifeExp |  51.05100|
| Africa    |  1992|     48.86533| lifeExp |  51.72400|
| Africa    |  1997|     48.86533| lifeExp |  51.57300|
| Africa    |  2002|     48.86533| lifeExp |  50.52500|
| Africa    |  2007|     48.86533| lifeExp |  50.65100|
| Americas  |  1952|     64.65874| lifeExp |  54.74500|
| Americas  |  1957|     64.65874| lifeExp |  56.07400|
| Americas  |  1962|     64.65874| lifeExp |  57.92400|
| Americas  |  1967|     64.65874| lifeExp |  60.52300|
| Americas  |  1972|     64.65874| lifeExp |  63.44100|
| Americas  |  1977|     64.65874| lifeExp |  67.05200|
| Americas  |  1982|     64.65874| lifeExp |  70.56500|
| Americas  |  1987|     64.65874| lifeExp |  72.49200|
| Americas  |  1992|     64.65874| lifeExp |  74.12600|
| Americas  |  1997|     64.65874| lifeExp |  75.81600|
| Americas  |  2002|     64.65874| lifeExp |  77.86000|
| Americas  |  2007|     64.65874| lifeExp |  78.55300|
| Asia      |  1952|     60.06490| lifeExp |  44.00000|
| Asia      |  1957|     60.06490| lifeExp |  50.54896|
| Asia      |  1962|     60.06490| lifeExp |  44.50136|
| Asia      |  1967|     60.06490| lifeExp |  58.38112|
| Asia      |  1972|     60.06490| lifeExp |  63.11888|
| Asia      |  1977|     60.06490| lifeExp |  63.96736|
| Asia      |  1982|     60.06490| lifeExp |  65.52500|
| Asia      |  1987|     60.06490| lifeExp |  67.27400|
| Asia      |  1992|     60.06490| lifeExp |  68.69000|
| Asia      |  1997|     60.06490| lifeExp |  70.42600|
| Asia      |  2002|     60.06490| lifeExp |  72.02800|
| Asia      |  2007|     60.06490| lifeExp |  72.96100|
| Americas  |  1952|     64.65874| lifeExp |  50.64300|
| Americas  |  1957|     64.65874| lifeExp |  55.11800|
| Americas  |  1962|     64.65874| lifeExp |  57.86300|
| Americas  |  1967|     64.65874| lifeExp |  59.96300|
| Americas  |  1972|     64.65874| lifeExp |  61.62300|
| Americas  |  1977|     64.65874| lifeExp |  63.83700|
| Americas  |  1982|     64.65874| lifeExp |  66.65300|
| Americas  |  1987|     64.65874| lifeExp |  67.76800|
| Americas  |  1992|     64.65874| lifeExp |  68.42100|
| Americas  |  1997|     64.65874| lifeExp |  70.31300|
| Americas  |  2002|     64.65874| lifeExp |  71.68200|
| Americas  |  2007|     64.65874| lifeExp |  72.88900|
| Africa    |  1952|     48.86533| lifeExp |  40.71500|
| Africa    |  1957|     48.86533| lifeExp |  42.46000|
| Africa    |  1962|     48.86533| lifeExp |  44.46700|
| Africa    |  1967|     48.86533| lifeExp |  46.47200|
| Africa    |  1972|     48.86533| lifeExp |  48.94400|
| Africa    |  1977|     48.86533| lifeExp |  50.93900|
| Africa    |  1982|     48.86533| lifeExp |  52.93300|
| Africa    |  1987|     48.86533| lifeExp |  54.92600|
| Africa    |  1992|     48.86533| lifeExp |  57.93900|
| Africa    |  1997|     48.86533| lifeExp |  60.66000|
| Africa    |  2002|     48.86533| lifeExp |  62.97400|
| Africa    |  2007|     48.86533| lifeExp |  65.15200|
| Africa    |  1952|     48.86533| lifeExp |  39.14300|
| Africa    |  1957|     48.86533| lifeExp |  40.65200|
| Africa    |  1962|     48.86533| lifeExp |  42.12200|
| Africa    |  1967|     48.86533| lifeExp |  44.05600|
| Africa    |  1972|     48.86533| lifeExp |  45.98900|
| Africa    |  1977|     48.86533| lifeExp |  47.80400|
| Africa    |  1982|     48.86533| lifeExp |  47.78400|
| Africa    |  1987|     48.86533| lifeExp |  47.41200|
| Africa    |  1992|     48.86533| lifeExp |  45.54800|
| Africa    |  1997|     48.86533| lifeExp |  42.58700|
| Africa    |  2002|     48.86533| lifeExp |  44.96600|
| Africa    |  2007|     48.86533| lifeExp |  46.46200|
| Africa    |  1952|     48.86533| lifeExp |  42.11100|
| Africa    |  1957|     48.86533| lifeExp |  45.05300|
| Africa    |  1962|     48.86533| lifeExp |  48.43500|
| Africa    |  1967|     48.86533| lifeExp |  52.04000|
| Africa    |  1972|     48.86533| lifeExp |  54.90700|
| Africa    |  1977|     48.86533| lifeExp |  55.62500|
| Africa    |  1982|     48.86533| lifeExp |  56.69500|
| Africa    |  1987|     48.86533| lifeExp |  57.47000|
| Africa    |  1992|     48.86533| lifeExp |  56.43300|
| Africa    |  1997|     48.86533| lifeExp |  52.96200|
| Africa    |  2002|     48.86533| lifeExp |  52.97000|
| Africa    |  2007|     48.86533| lifeExp |  55.32200|
| Americas  |  1952|     64.65874| lifeExp |  57.20600|
| Americas  |  1957|     64.65874| lifeExp |  60.02600|
| Americas  |  1962|     64.65874| lifeExp |  62.84200|
| Americas  |  1967|     64.65874| lifeExp |  65.42400|
| Americas  |  1972|     64.65874| lifeExp |  67.84900|
| Americas  |  1977|     64.65874| lifeExp |  70.75000|
| Americas  |  1982|     64.65874| lifeExp |  73.45000|
| Americas  |  1987|     64.65874| lifeExp |  74.75200|
| Americas  |  1992|     64.65874| lifeExp |  75.71300|
| Americas  |  1997|     64.65874| lifeExp |  77.26000|
| Americas  |  2002|     64.65874| lifeExp |  78.12300|
| Americas  |  2007|     64.65874| lifeExp |  78.78200|
| Africa    |  1952|     48.86533| lifeExp |  40.47700|
| Africa    |  1957|     48.86533| lifeExp |  42.46900|
| Africa    |  1962|     48.86533| lifeExp |  44.93000|
| Africa    |  1967|     48.86533| lifeExp |  47.35000|
| Africa    |  1972|     48.86533| lifeExp |  49.80100|
| Africa    |  1977|     48.86533| lifeExp |  52.37400|
| Africa    |  1982|     48.86533| lifeExp |  53.98300|
| Africa    |  1987|     48.86533| lifeExp |  54.65500|
| Africa    |  1992|     48.86533| lifeExp |  52.04400|
| Africa    |  1997|     48.86533| lifeExp |  47.99100|
| Africa    |  2002|     48.86533| lifeExp |  46.83200|
| Africa    |  2007|     48.86533| lifeExp |  48.32800|
| Europe    |  1952|     71.90369| lifeExp |  61.21000|
| Europe    |  1957|     71.90369| lifeExp |  64.77000|
| Europe    |  1962|     71.90369| lifeExp |  67.13000|
| Europe    |  1967|     71.90369| lifeExp |  68.50000|
| Europe    |  1972|     71.90369| lifeExp |  69.61000|
| Europe    |  1977|     71.90369| lifeExp |  70.64000|
| Europe    |  1982|     71.90369| lifeExp |  70.46000|
| Europe    |  1987|     71.90369| lifeExp |  71.52000|
| Europe    |  1992|     71.90369| lifeExp |  72.52700|
| Europe    |  1997|     71.90369| lifeExp |  73.68000|
| Europe    |  2002|     71.90369| lifeExp |  74.87600|
| Europe    |  2007|     71.90369| lifeExp |  75.74800|
| Americas  |  1952|     64.65874| lifeExp |  59.42100|
| Americas  |  1957|     64.65874| lifeExp |  62.32500|
| Americas  |  1962|     64.65874| lifeExp |  65.24600|
| Americas  |  1967|     64.65874| lifeExp |  68.29000|
| Americas  |  1972|     64.65874| lifeExp |  70.72300|
| Americas  |  1977|     64.65874| lifeExp |  72.64900|
| Americas  |  1982|     64.65874| lifeExp |  73.71700|
| Americas  |  1987|     64.65874| lifeExp |  74.17400|
| Americas  |  1992|     64.65874| lifeExp |  74.41400|
| Americas  |  1997|     64.65874| lifeExp |  76.15100|
| Americas  |  2002|     64.65874| lifeExp |  77.15800|
| Americas  |  2007|     64.65874| lifeExp |  78.27300|
| Europe    |  1952|     71.90369| lifeExp |  66.87000|
| Europe    |  1957|     71.90369| lifeExp |  69.03000|
| Europe    |  1962|     71.90369| lifeExp |  69.90000|
| Europe    |  1967|     71.90369| lifeExp |  70.38000|
| Europe    |  1972|     71.90369| lifeExp |  70.29000|
| Europe    |  1977|     71.90369| lifeExp |  70.71000|
| Europe    |  1982|     71.90369| lifeExp |  70.96000|
| Europe    |  1987|     71.90369| lifeExp |  71.58000|
| Europe    |  1992|     71.90369| lifeExp |  72.40000|
| Europe    |  1997|     71.90369| lifeExp |  74.01000|
| Europe    |  2002|     71.90369| lifeExp |  75.51000|
| Europe    |  2007|     71.90369| lifeExp |  76.48600|
| Europe    |  1952|     71.90369| lifeExp |  70.78000|
| Europe    |  1957|     71.90369| lifeExp |  71.81000|
| Europe    |  1962|     71.90369| lifeExp |  72.35000|
| Europe    |  1967|     71.90369| lifeExp |  72.96000|
| Europe    |  1972|     71.90369| lifeExp |  73.47000|
| Europe    |  1977|     71.90369| lifeExp |  74.69000|
| Europe    |  1982|     71.90369| lifeExp |  74.63000|
| Europe    |  1987|     71.90369| lifeExp |  74.80000|
| Europe    |  1992|     71.90369| lifeExp |  75.33000|
| Europe    |  1997|     71.90369| lifeExp |  76.11000|
| Europe    |  2002|     71.90369| lifeExp |  77.18000|
| Europe    |  2007|     71.90369| lifeExp |  78.33200|
| Africa    |  1952|     48.86533| lifeExp |  34.81200|
| Africa    |  1957|     48.86533| lifeExp |  37.32800|
| Africa    |  1962|     48.86533| lifeExp |  39.69300|
| Africa    |  1967|     48.86533| lifeExp |  42.07400|
| Africa    |  1972|     48.86533| lifeExp |  44.36600|
| Africa    |  1977|     48.86533| lifeExp |  46.51900|
| Africa    |  1982|     48.86533| lifeExp |  48.81200|
| Africa    |  1987|     48.86533| lifeExp |  50.04000|
| Africa    |  1992|     48.86533| lifeExp |  51.60400|
| Africa    |  1997|     48.86533| lifeExp |  53.15700|
| Africa    |  2002|     48.86533| lifeExp |  53.37300|
| Africa    |  2007|     48.86533| lifeExp |  54.79100|
| Americas  |  1952|     64.65874| lifeExp |  45.92800|
| Americas  |  1957|     64.65874| lifeExp |  49.82800|
| Americas  |  1962|     64.65874| lifeExp |  53.45900|
| Americas  |  1967|     64.65874| lifeExp |  56.75100|
| Americas  |  1972|     64.65874| lifeExp |  59.63100|
| Americas  |  1977|     64.65874| lifeExp |  61.78800|
| Americas  |  1982|     64.65874| lifeExp |  63.72700|
| Americas  |  1987|     64.65874| lifeExp |  66.04600|
| Americas  |  1992|     64.65874| lifeExp |  68.45700|
| Americas  |  1997|     64.65874| lifeExp |  69.95700|
| Americas  |  2002|     64.65874| lifeExp |  70.84700|
| Americas  |  2007|     64.65874| lifeExp |  72.23500|
| Americas  |  1952|     64.65874| lifeExp |  48.35700|
| Americas  |  1957|     64.65874| lifeExp |  51.35600|
| Americas  |  1962|     64.65874| lifeExp |  54.64000|
| Americas  |  1967|     64.65874| lifeExp |  56.67800|
| Americas  |  1972|     64.65874| lifeExp |  58.79600|
| Americas  |  1977|     64.65874| lifeExp |  61.31000|
| Americas  |  1982|     64.65874| lifeExp |  64.34200|
| Americas  |  1987|     64.65874| lifeExp |  67.23100|
| Americas  |  1992|     64.65874| lifeExp |  69.61300|
| Americas  |  1997|     64.65874| lifeExp |  72.31200|
| Americas  |  2002|     64.65874| lifeExp |  74.17300|
| Americas  |  2007|     64.65874| lifeExp |  74.99400|
| Africa    |  1952|     48.86533| lifeExp |  41.89300|
| Africa    |  1957|     48.86533| lifeExp |  44.44400|
| Africa    |  1962|     48.86533| lifeExp |  46.99200|
| Africa    |  1967|     48.86533| lifeExp |  49.29300|
| Africa    |  1972|     48.86533| lifeExp |  51.13700|
| Africa    |  1977|     48.86533| lifeExp |  53.31900|
| Africa    |  1982|     48.86533| lifeExp |  56.00600|
| Africa    |  1987|     48.86533| lifeExp |  59.79700|
| Africa    |  1992|     48.86533| lifeExp |  63.67400|
| Africa    |  1997|     48.86533| lifeExp |  67.21700|
| Africa    |  2002|     48.86533| lifeExp |  69.80600|
| Africa    |  2007|     48.86533| lifeExp |  71.33800|
| Americas  |  1952|     64.65874| lifeExp |  45.26200|
| Americas  |  1957|     64.65874| lifeExp |  48.57000|
| Americas  |  1962|     64.65874| lifeExp |  52.30700|
| Americas  |  1967|     64.65874| lifeExp |  55.85500|
| Americas  |  1972|     64.65874| lifeExp |  58.20700|
| Americas  |  1977|     64.65874| lifeExp |  56.69600|
| Americas  |  1982|     64.65874| lifeExp |  56.60400|
| Americas  |  1987|     64.65874| lifeExp |  63.15400|
| Americas  |  1992|     64.65874| lifeExp |  66.79800|
| Americas  |  1997|     64.65874| lifeExp |  69.53500|
| Americas  |  2002|     64.65874| lifeExp |  70.73400|
| Americas  |  2007|     64.65874| lifeExp |  71.87800|
| Africa    |  1952|     48.86533| lifeExp |  34.48200|
| Africa    |  1957|     48.86533| lifeExp |  35.98300|
| Africa    |  1962|     48.86533| lifeExp |  37.48500|
| Africa    |  1967|     48.86533| lifeExp |  38.98700|
| Africa    |  1972|     48.86533| lifeExp |  40.51600|
| Africa    |  1977|     48.86533| lifeExp |  42.02400|
| Africa    |  1982|     48.86533| lifeExp |  43.66200|
| Africa    |  1987|     48.86533| lifeExp |  45.66400|
| Africa    |  1992|     48.86533| lifeExp |  47.54500|
| Africa    |  1997|     48.86533| lifeExp |  48.24500|
| Africa    |  2002|     48.86533| lifeExp |  49.34800|
| Africa    |  2007|     48.86533| lifeExp |  51.57900|
| Africa    |  1952|     48.86533| lifeExp |  35.92800|
| Africa    |  1957|     48.86533| lifeExp |  38.04700|
| Africa    |  1962|     48.86533| lifeExp |  40.15800|
| Africa    |  1967|     48.86533| lifeExp |  42.18900|
| Africa    |  1972|     48.86533| lifeExp |  44.14200|
| Africa    |  1977|     48.86533| lifeExp |  44.53500|
| Africa    |  1982|     48.86533| lifeExp |  43.89000|
| Africa    |  1987|     48.86533| lifeExp |  46.45300|
| Africa    |  1992|     48.86533| lifeExp |  49.99100|
| Africa    |  1997|     48.86533| lifeExp |  53.37800|
| Africa    |  2002|     48.86533| lifeExp |  55.24000|
| Africa    |  2007|     48.86533| lifeExp |  58.04000|
| Africa    |  1952|     48.86533| lifeExp |  34.07800|
| Africa    |  1957|     48.86533| lifeExp |  36.66700|
| Africa    |  1962|     48.86533| lifeExp |  40.05900|
| Africa    |  1967|     48.86533| lifeExp |  42.11500|
| Africa    |  1972|     48.86533| lifeExp |  43.51500|
| Africa    |  1977|     48.86533| lifeExp |  44.51000|
| Africa    |  1982|     48.86533| lifeExp |  44.91600|
| Africa    |  1987|     48.86533| lifeExp |  46.68400|
| Africa    |  1992|     48.86533| lifeExp |  48.09100|
| Africa    |  1997|     48.86533| lifeExp |  49.40200|
| Africa    |  2002|     48.86533| lifeExp |  50.72500|
| Africa    |  2007|     48.86533| lifeExp |  52.94700|
| Europe    |  1952|     71.90369| lifeExp |  66.55000|
| Europe    |  1957|     71.90369| lifeExp |  67.49000|
| Europe    |  1962|     71.90369| lifeExp |  68.75000|
| Europe    |  1967|     71.90369| lifeExp |  69.83000|
| Europe    |  1972|     71.90369| lifeExp |  70.87000|
| Europe    |  1977|     71.90369| lifeExp |  72.52000|
| Europe    |  1982|     71.90369| lifeExp |  74.55000|
| Europe    |  1987|     71.90369| lifeExp |  74.83000|
| Europe    |  1992|     71.90369| lifeExp |  75.70000|
| Europe    |  1997|     71.90369| lifeExp |  77.13000|
| Europe    |  2002|     71.90369| lifeExp |  78.37000|
| Europe    |  2007|     71.90369| lifeExp |  79.31300|
| Europe    |  1952|     71.90369| lifeExp |  67.41000|
| Europe    |  1957|     71.90369| lifeExp |  68.93000|
| Europe    |  1962|     71.90369| lifeExp |  70.51000|
| Europe    |  1967|     71.90369| lifeExp |  71.55000|
| Europe    |  1972|     71.90369| lifeExp |  72.38000|
| Europe    |  1977|     71.90369| lifeExp |  73.83000|
| Europe    |  1982|     71.90369| lifeExp |  74.89000|
| Europe    |  1987|     71.90369| lifeExp |  76.34000|
| Europe    |  1992|     71.90369| lifeExp |  77.46000|
| Europe    |  1997|     71.90369| lifeExp |  78.64000|
| Europe    |  2002|     71.90369| lifeExp |  79.59000|
| Europe    |  2007|     71.90369| lifeExp |  80.65700|
| Africa    |  1952|     48.86533| lifeExp |  37.00300|
| Africa    |  1957|     48.86533| lifeExp |  38.99900|
| Africa    |  1962|     48.86533| lifeExp |  40.48900|
| Africa    |  1967|     48.86533| lifeExp |  44.59800|
| Africa    |  1972|     48.86533| lifeExp |  48.69000|
| Africa    |  1977|     48.86533| lifeExp |  52.79000|
| Africa    |  1982|     48.86533| lifeExp |  56.56400|
| Africa    |  1987|     48.86533| lifeExp |  60.19000|
| Africa    |  1992|     48.86533| lifeExp |  61.36600|
| Africa    |  1997|     48.86533| lifeExp |  60.46100|
| Africa    |  2002|     48.86533| lifeExp |  56.76100|
| Africa    |  2007|     48.86533| lifeExp |  56.73500|
| Africa    |  1952|     48.86533| lifeExp |  30.00000|
| Africa    |  1957|     48.86533| lifeExp |  32.06500|
| Africa    |  1962|     48.86533| lifeExp |  33.89600|
| Africa    |  1967|     48.86533| lifeExp |  35.85700|
| Africa    |  1972|     48.86533| lifeExp |  38.30800|
| Africa    |  1977|     48.86533| lifeExp |  41.84200|
| Africa    |  1982|     48.86533| lifeExp |  45.58000|
| Africa    |  1987|     48.86533| lifeExp |  49.26500|
| Africa    |  1992|     48.86533| lifeExp |  52.64400|
| Africa    |  1997|     48.86533| lifeExp |  55.86100|
| Africa    |  2002|     48.86533| lifeExp |  58.04100|
| Africa    |  2007|     48.86533| lifeExp |  59.44800|
| Europe    |  1952|     71.90369| lifeExp |  67.50000|
| Europe    |  1957|     71.90369| lifeExp |  69.10000|
| Europe    |  1962|     71.90369| lifeExp |  70.30000|
| Europe    |  1967|     71.90369| lifeExp |  70.80000|
| Europe    |  1972|     71.90369| lifeExp |  71.00000|
| Europe    |  1977|     71.90369| lifeExp |  72.50000|
| Europe    |  1982|     71.90369| lifeExp |  73.80000|
| Europe    |  1987|     71.90369| lifeExp |  74.84700|
| Europe    |  1992|     71.90369| lifeExp |  76.07000|
| Europe    |  1997|     71.90369| lifeExp |  77.34000|
| Europe    |  2002|     71.90369| lifeExp |  78.67000|
| Europe    |  2007|     71.90369| lifeExp |  79.40600|
| Africa    |  1952|     48.86533| lifeExp |  43.14900|
| Africa    |  1957|     48.86533| lifeExp |  44.77900|
| Africa    |  1962|     48.86533| lifeExp |  46.45200|
| Africa    |  1967|     48.86533| lifeExp |  48.07200|
| Africa    |  1972|     48.86533| lifeExp |  49.87500|
| Africa    |  1977|     48.86533| lifeExp |  51.75600|
| Africa    |  1982|     48.86533| lifeExp |  53.74400|
| Africa    |  1987|     48.86533| lifeExp |  55.72900|
| Africa    |  1992|     48.86533| lifeExp |  57.50100|
| Africa    |  1997|     48.86533| lifeExp |  58.55600|
| Africa    |  2002|     48.86533| lifeExp |  58.45300|
| Africa    |  2007|     48.86533| lifeExp |  60.02200|
| Europe    |  1952|     71.90369| lifeExp |  65.86000|
| Europe    |  1957|     71.90369| lifeExp |  67.86000|
| Europe    |  1962|     71.90369| lifeExp |  69.51000|
| Europe    |  1967|     71.90369| lifeExp |  71.00000|
| Europe    |  1972|     71.90369| lifeExp |  72.34000|
| Europe    |  1977|     71.90369| lifeExp |  73.68000|
| Europe    |  1982|     71.90369| lifeExp |  75.24000|
| Europe    |  1987|     71.90369| lifeExp |  76.67000|
| Europe    |  1992|     71.90369| lifeExp |  77.03000|
| Europe    |  1997|     71.90369| lifeExp |  77.86900|
| Europe    |  2002|     71.90369| lifeExp |  78.25600|
| Europe    |  2007|     71.90369| lifeExp |  79.48300|
| Americas  |  1952|     64.65874| lifeExp |  42.02300|
| Americas  |  1957|     64.65874| lifeExp |  44.14200|
| Americas  |  1962|     64.65874| lifeExp |  46.95400|
| Americas  |  1967|     64.65874| lifeExp |  50.01600|
| Americas  |  1972|     64.65874| lifeExp |  53.73800|
| Americas  |  1977|     64.65874| lifeExp |  56.02900|
| Americas  |  1982|     64.65874| lifeExp |  58.13700|
| Americas  |  1987|     64.65874| lifeExp |  60.78200|
| Americas  |  1992|     64.65874| lifeExp |  63.37300|
| Americas  |  1997|     64.65874| lifeExp |  66.32200|
| Americas  |  2002|     64.65874| lifeExp |  68.97800|
| Americas  |  2007|     64.65874| lifeExp |  70.25900|
| Africa    |  1952|     48.86533| lifeExp |  33.60900|
| Africa    |  1957|     48.86533| lifeExp |  34.55800|
| Africa    |  1962|     48.86533| lifeExp |  35.75300|
| Africa    |  1967|     48.86533| lifeExp |  37.19700|
| Africa    |  1972|     48.86533| lifeExp |  38.84200|
| Africa    |  1977|     48.86533| lifeExp |  40.76200|
| Africa    |  1982|     48.86533| lifeExp |  42.89100|
| Africa    |  1987|     48.86533| lifeExp |  45.55200|
| Africa    |  1992|     48.86533| lifeExp |  48.57600|
| Africa    |  1997|     48.86533| lifeExp |  51.45500|
| Africa    |  2002|     48.86533| lifeExp |  53.67600|
| Africa    |  2007|     48.86533| lifeExp |  56.00700|
| Africa    |  1952|     48.86533| lifeExp |  32.50000|
| Africa    |  1957|     48.86533| lifeExp |  33.48900|
| Africa    |  1962|     48.86533| lifeExp |  34.48800|
| Africa    |  1967|     48.86533| lifeExp |  35.49200|
| Africa    |  1972|     48.86533| lifeExp |  36.48600|
| Africa    |  1977|     48.86533| lifeExp |  37.46500|
| Africa    |  1982|     48.86533| lifeExp |  39.32700|
| Africa    |  1987|     48.86533| lifeExp |  41.24500|
| Africa    |  1992|     48.86533| lifeExp |  43.26600|
| Africa    |  1997|     48.86533| lifeExp |  44.87300|
| Africa    |  2002|     48.86533| lifeExp |  45.50400|
| Africa    |  2007|     48.86533| lifeExp |  46.38800|
| Americas  |  1952|     64.65874| lifeExp |  37.57900|
| Americas  |  1957|     64.65874| lifeExp |  40.69600|
| Americas  |  1962|     64.65874| lifeExp |  43.59000|
| Americas  |  1967|     64.65874| lifeExp |  46.24300|
| Americas  |  1972|     64.65874| lifeExp |  48.04200|
| Americas  |  1977|     64.65874| lifeExp |  49.92300|
| Americas  |  1982|     64.65874| lifeExp |  51.46100|
| Americas  |  1987|     64.65874| lifeExp |  53.63600|
| Americas  |  1992|     64.65874| lifeExp |  55.08900|
| Americas  |  1997|     64.65874| lifeExp |  56.67100|
| Americas  |  2002|     64.65874| lifeExp |  58.13700|
| Americas  |  2007|     64.65874| lifeExp |  60.91600|
| Americas  |  1952|     64.65874| lifeExp |  41.91200|
| Americas  |  1957|     64.65874| lifeExp |  44.66500|
| Americas  |  1962|     64.65874| lifeExp |  48.04100|
| Americas  |  1967|     64.65874| lifeExp |  50.92400|
| Americas  |  1972|     64.65874| lifeExp |  53.88400|
| Americas  |  1977|     64.65874| lifeExp |  57.40200|
| Americas  |  1982|     64.65874| lifeExp |  60.90900|
| Americas  |  1987|     64.65874| lifeExp |  64.49200|
| Americas  |  1992|     64.65874| lifeExp |  66.39900|
| Americas  |  1997|     64.65874| lifeExp |  67.65900|
| Americas  |  2002|     64.65874| lifeExp |  68.56500|
| Americas  |  2007|     64.65874| lifeExp |  70.19800|
| Asia      |  1952|     60.06490| lifeExp |  60.96000|
| Asia      |  1957|     60.06490| lifeExp |  64.75000|
| Asia      |  1962|     60.06490| lifeExp |  67.65000|
| Asia      |  1967|     60.06490| lifeExp |  70.00000|
| Asia      |  1972|     60.06490| lifeExp |  72.00000|
| Asia      |  1977|     60.06490| lifeExp |  73.60000|
| Asia      |  1982|     60.06490| lifeExp |  75.45000|
| Asia      |  1987|     60.06490| lifeExp |  76.20000|
| Asia      |  1992|     60.06490| lifeExp |  77.60100|
| Asia      |  1997|     60.06490| lifeExp |  80.00000|
| Asia      |  2002|     60.06490| lifeExp |  81.49500|
| Asia      |  2007|     60.06490| lifeExp |  82.20800|
| Europe    |  1952|     71.90369| lifeExp |  64.03000|
| Europe    |  1957|     71.90369| lifeExp |  66.41000|
| Europe    |  1962|     71.90369| lifeExp |  67.96000|
| Europe    |  1967|     71.90369| lifeExp |  69.50000|
| Europe    |  1972|     71.90369| lifeExp |  69.76000|
| Europe    |  1977|     71.90369| lifeExp |  69.95000|
| Europe    |  1982|     71.90369| lifeExp |  69.39000|
| Europe    |  1987|     71.90369| lifeExp |  69.58000|
| Europe    |  1992|     71.90369| lifeExp |  69.17000|
| Europe    |  1997|     71.90369| lifeExp |  71.04000|
| Europe    |  2002|     71.90369| lifeExp |  72.59000|
| Europe    |  2007|     71.90369| lifeExp |  73.33800|
| Europe    |  1952|     71.90369| lifeExp |  72.49000|
| Europe    |  1957|     71.90369| lifeExp |  73.47000|
| Europe    |  1962|     71.90369| lifeExp |  73.68000|
| Europe    |  1967|     71.90369| lifeExp |  73.73000|
| Europe    |  1972|     71.90369| lifeExp |  74.46000|
| Europe    |  1977|     71.90369| lifeExp |  76.11000|
| Europe    |  1982|     71.90369| lifeExp |  76.99000|
| Europe    |  1987|     71.90369| lifeExp |  77.23000|
| Europe    |  1992|     71.90369| lifeExp |  78.77000|
| Europe    |  1997|     71.90369| lifeExp |  78.95000|
| Europe    |  2002|     71.90369| lifeExp |  80.50000|
| Europe    |  2007|     71.90369| lifeExp |  81.75700|
| Asia      |  1952|     60.06490| lifeExp |  37.37300|
| Asia      |  1957|     60.06490| lifeExp |  40.24900|
| Asia      |  1962|     60.06490| lifeExp |  43.60500|
| Asia      |  1967|     60.06490| lifeExp |  47.19300|
| Asia      |  1972|     60.06490| lifeExp |  50.65100|
| Asia      |  1977|     60.06490| lifeExp |  54.20800|
| Asia      |  1982|     60.06490| lifeExp |  56.59600|
| Asia      |  1987|     60.06490| lifeExp |  58.55300|
| Asia      |  1992|     60.06490| lifeExp |  60.22300|
| Asia      |  1997|     60.06490| lifeExp |  61.76500|
| Asia      |  2002|     60.06490| lifeExp |  62.87900|
| Asia      |  2007|     60.06490| lifeExp |  64.69800|
| Asia      |  1952|     60.06490| lifeExp |  37.46800|
| Asia      |  1957|     60.06490| lifeExp |  39.91800|
| Asia      |  1962|     60.06490| lifeExp |  42.51800|
| Asia      |  1967|     60.06490| lifeExp |  45.96400|
| Asia      |  1972|     60.06490| lifeExp |  49.20300|
| Asia      |  1977|     60.06490| lifeExp |  52.70200|
| Asia      |  1982|     60.06490| lifeExp |  56.15900|
| Asia      |  1987|     60.06490| lifeExp |  60.13700|
| Asia      |  1992|     60.06490| lifeExp |  62.68100|
| Asia      |  1997|     60.06490| lifeExp |  66.04100|
| Asia      |  2002|     60.06490| lifeExp |  68.58800|
| Asia      |  2007|     60.06490| lifeExp |  70.65000|
| Asia      |  1952|     60.06490| lifeExp |  44.86900|
| Asia      |  1957|     60.06490| lifeExp |  47.18100|
| Asia      |  1962|     60.06490| lifeExp |  49.32500|
| Asia      |  1967|     60.06490| lifeExp |  52.46900|
| Asia      |  1972|     60.06490| lifeExp |  55.23400|
| Asia      |  1977|     60.06490| lifeExp |  57.70200|
| Asia      |  1982|     60.06490| lifeExp |  59.62000|
| Asia      |  1987|     60.06490| lifeExp |  63.04000|
| Asia      |  1992|     60.06490| lifeExp |  65.74200|
| Asia      |  1997|     60.06490| lifeExp |  68.04200|
| Asia      |  2002|     60.06490| lifeExp |  69.45100|
| Asia      |  2007|     60.06490| lifeExp |  70.96400|
| Asia      |  1952|     60.06490| lifeExp |  45.32000|
| Asia      |  1957|     60.06490| lifeExp |  48.43700|
| Asia      |  1962|     60.06490| lifeExp |  51.45700|
| Asia      |  1967|     60.06490| lifeExp |  54.45900|
| Asia      |  1972|     60.06490| lifeExp |  56.95000|
| Asia      |  1977|     60.06490| lifeExp |  60.41300|
| Asia      |  1982|     60.06490| lifeExp |  62.03800|
| Asia      |  1987|     60.06490| lifeExp |  65.04400|
| Asia      |  1992|     60.06490| lifeExp |  59.46100|
| Asia      |  1997|     60.06490| lifeExp |  58.81100|
| Asia      |  2002|     60.06490| lifeExp |  57.04600|
| Asia      |  2007|     60.06490| lifeExp |  59.54500|
| Europe    |  1952|     71.90369| lifeExp |  66.91000|
| Europe    |  1957|     71.90369| lifeExp |  68.90000|
| Europe    |  1962|     71.90369| lifeExp |  70.29000|
| Europe    |  1967|     71.90369| lifeExp |  71.08000|
| Europe    |  1972|     71.90369| lifeExp |  71.28000|
| Europe    |  1977|     71.90369| lifeExp |  72.03000|
| Europe    |  1982|     71.90369| lifeExp |  73.10000|
| Europe    |  1987|     71.90369| lifeExp |  74.36000|
| Europe    |  1992|     71.90369| lifeExp |  75.46700|
| Europe    |  1997|     71.90369| lifeExp |  76.12200|
| Europe    |  2002|     71.90369| lifeExp |  77.78300|
| Europe    |  2007|     71.90369| lifeExp |  78.88500|
| Asia      |  1952|     60.06490| lifeExp |  65.39000|
| Asia      |  1957|     60.06490| lifeExp |  67.84000|
| Asia      |  1962|     60.06490| lifeExp |  69.39000|
| Asia      |  1967|     60.06490| lifeExp |  70.75000|
| Asia      |  1972|     60.06490| lifeExp |  71.63000|
| Asia      |  1977|     60.06490| lifeExp |  73.06000|
| Asia      |  1982|     60.06490| lifeExp |  74.45000|
| Asia      |  1987|     60.06490| lifeExp |  75.60000|
| Asia      |  1992|     60.06490| lifeExp |  76.93000|
| Asia      |  1997|     60.06490| lifeExp |  78.26900|
| Asia      |  2002|     60.06490| lifeExp |  79.69600|
| Asia      |  2007|     60.06490| lifeExp |  80.74500|
| Europe    |  1952|     71.90369| lifeExp |  65.94000|
| Europe    |  1957|     71.90369| lifeExp |  67.81000|
| Europe    |  1962|     71.90369| lifeExp |  69.24000|
| Europe    |  1967|     71.90369| lifeExp |  71.06000|
| Europe    |  1972|     71.90369| lifeExp |  72.19000|
| Europe    |  1977|     71.90369| lifeExp |  73.48000|
| Europe    |  1982|     71.90369| lifeExp |  74.98000|
| Europe    |  1987|     71.90369| lifeExp |  76.42000|
| Europe    |  1992|     71.90369| lifeExp |  77.44000|
| Europe    |  1997|     71.90369| lifeExp |  78.82000|
| Europe    |  2002|     71.90369| lifeExp |  80.24000|
| Europe    |  2007|     71.90369| lifeExp |  80.54600|
| Americas  |  1952|     64.65874| lifeExp |  58.53000|
| Americas  |  1957|     64.65874| lifeExp |  62.61000|
| Americas  |  1962|     64.65874| lifeExp |  65.61000|
| Americas  |  1967|     64.65874| lifeExp |  67.51000|
| Americas  |  1972|     64.65874| lifeExp |  69.00000|
| Americas  |  1977|     64.65874| lifeExp |  70.11000|
| Americas  |  1982|     64.65874| lifeExp |  71.21000|
| Americas  |  1987|     64.65874| lifeExp |  71.77000|
| Americas  |  1992|     64.65874| lifeExp |  71.76600|
| Americas  |  1997|     64.65874| lifeExp |  72.26200|
| Americas  |  2002|     64.65874| lifeExp |  72.04700|
| Americas  |  2007|     64.65874| lifeExp |  72.56700|
| Asia      |  1952|     60.06490| lifeExp |  63.03000|
| Asia      |  1957|     60.06490| lifeExp |  65.50000|
| Asia      |  1962|     60.06490| lifeExp |  68.73000|
| Asia      |  1967|     60.06490| lifeExp |  71.43000|
| Asia      |  1972|     60.06490| lifeExp |  73.42000|
| Asia      |  1977|     60.06490| lifeExp |  75.38000|
| Asia      |  1982|     60.06490| lifeExp |  77.11000|
| Asia      |  1987|     60.06490| lifeExp |  78.67000|
| Asia      |  1992|     60.06490| lifeExp |  79.36000|
| Asia      |  1997|     60.06490| lifeExp |  80.69000|
| Asia      |  2002|     60.06490| lifeExp |  82.00000|
| Asia      |  2007|     60.06490| lifeExp |  82.60300|
| Asia      |  1952|     60.06490| lifeExp |  43.15800|
| Asia      |  1957|     60.06490| lifeExp |  45.66900|
| Asia      |  1962|     60.06490| lifeExp |  48.12600|
| Asia      |  1967|     60.06490| lifeExp |  51.62900|
| Asia      |  1972|     60.06490| lifeExp |  56.52800|
| Asia      |  1977|     60.06490| lifeExp |  61.13400|
| Asia      |  1982|     60.06490| lifeExp |  63.73900|
| Asia      |  1987|     60.06490| lifeExp |  65.86900|
| Asia      |  1992|     60.06490| lifeExp |  68.01500|
| Asia      |  1997|     60.06490| lifeExp |  69.77200|
| Asia      |  2002|     60.06490| lifeExp |  71.26300|
| Asia      |  2007|     60.06490| lifeExp |  72.53500|
| Africa    |  1952|     48.86533| lifeExp |  42.27000|
| Africa    |  1957|     48.86533| lifeExp |  44.68600|
| Africa    |  1962|     48.86533| lifeExp |  47.94900|
| Africa    |  1967|     48.86533| lifeExp |  50.65400|
| Africa    |  1972|     48.86533| lifeExp |  53.55900|
| Africa    |  1977|     48.86533| lifeExp |  56.15500|
| Africa    |  1982|     48.86533| lifeExp |  58.76600|
| Africa    |  1987|     48.86533| lifeExp |  59.33900|
| Africa    |  1992|     48.86533| lifeExp |  59.28500|
| Africa    |  1997|     48.86533| lifeExp |  54.40700|
| Africa    |  2002|     48.86533| lifeExp |  50.99200|
| Africa    |  2007|     48.86533| lifeExp |  54.11000|
| Asia      |  1952|     60.06490| lifeExp |  50.05600|
| Asia      |  1957|     60.06490| lifeExp |  54.08100|
| Asia      |  1962|     60.06490| lifeExp |  56.65600|
| Asia      |  1967|     60.06490| lifeExp |  59.94200|
| Asia      |  1972|     60.06490| lifeExp |  63.98300|
| Asia      |  1977|     60.06490| lifeExp |  67.15900|
| Asia      |  1982|     60.06490| lifeExp |  69.10000|
| Asia      |  1987|     60.06490| lifeExp |  70.64700|
| Asia      |  1992|     60.06490| lifeExp |  69.97800|
| Asia      |  1997|     60.06490| lifeExp |  67.72700|
| Asia      |  2002|     60.06490| lifeExp |  66.66200|
| Asia      |  2007|     60.06490| lifeExp |  67.29700|
| Asia      |  1952|     60.06490| lifeExp |  47.45300|
| Asia      |  1957|     60.06490| lifeExp |  52.68100|
| Asia      |  1962|     60.06490| lifeExp |  55.29200|
| Asia      |  1967|     60.06490| lifeExp |  57.71600|
| Asia      |  1972|     60.06490| lifeExp |  62.61200|
| Asia      |  1977|     60.06490| lifeExp |  64.76600|
| Asia      |  1982|     60.06490| lifeExp |  67.12300|
| Asia      |  1987|     60.06490| lifeExp |  69.81000|
| Asia      |  1992|     60.06490| lifeExp |  72.24400|
| Asia      |  1997|     60.06490| lifeExp |  74.64700|
| Asia      |  2002|     60.06490| lifeExp |  77.04500|
| Asia      |  2007|     60.06490| lifeExp |  78.62300|
| Asia      |  1952|     60.06490| lifeExp |  55.56500|
| Asia      |  1957|     60.06490| lifeExp |  58.03300|
| Asia      |  1962|     60.06490| lifeExp |  60.47000|
| Asia      |  1967|     60.06490| lifeExp |  64.62400|
| Asia      |  1972|     60.06490| lifeExp |  67.71200|
| Asia      |  1977|     60.06490| lifeExp |  69.34300|
| Asia      |  1982|     60.06490| lifeExp |  71.30900|
| Asia      |  1987|     60.06490| lifeExp |  74.17400|
| Asia      |  1992|     60.06490| lifeExp |  75.19000|
| Asia      |  1997|     60.06490| lifeExp |  76.15600|
| Asia      |  2002|     60.06490| lifeExp |  76.90400|
| Asia      |  2007|     60.06490| lifeExp |  77.58800|
| Asia      |  1952|     60.06490| lifeExp |  55.92800|
| Asia      |  1957|     60.06490| lifeExp |  59.48900|
| Asia      |  1962|     60.06490| lifeExp |  62.09400|
| Asia      |  1967|     60.06490| lifeExp |  63.87000|
| Asia      |  1972|     60.06490| lifeExp |  65.42100|
| Asia      |  1977|     60.06490| lifeExp |  66.09900|
| Asia      |  1982|     60.06490| lifeExp |  66.98300|
| Asia      |  1987|     60.06490| lifeExp |  67.92600|
| Asia      |  1992|     60.06490| lifeExp |  69.29200|
| Asia      |  1997|     60.06490| lifeExp |  70.26500|
| Asia      |  2002|     60.06490| lifeExp |  71.02800|
| Asia      |  2007|     60.06490| lifeExp |  71.99300|
| Africa    |  1952|     48.86533| lifeExp |  42.13800|
| Africa    |  1957|     48.86533| lifeExp |  45.04700|
| Africa    |  1962|     48.86533| lifeExp |  47.74700|
| Africa    |  1967|     48.86533| lifeExp |  48.49200|
| Africa    |  1972|     48.86533| lifeExp |  49.76700|
| Africa    |  1977|     48.86533| lifeExp |  52.20800|
| Africa    |  1982|     48.86533| lifeExp |  55.07800|
| Africa    |  1987|     48.86533| lifeExp |  57.18000|
| Africa    |  1992|     48.86533| lifeExp |  59.68500|
| Africa    |  1997|     48.86533| lifeExp |  55.55800|
| Africa    |  2002|     48.86533| lifeExp |  44.59300|
| Africa    |  2007|     48.86533| lifeExp |  42.59200|
| Africa    |  1952|     48.86533| lifeExp |  38.48000|
| Africa    |  1957|     48.86533| lifeExp |  39.48600|
| Africa    |  1962|     48.86533| lifeExp |  40.50200|
| Africa    |  1967|     48.86533| lifeExp |  41.53600|
| Africa    |  1972|     48.86533| lifeExp |  42.61400|
| Africa    |  1977|     48.86533| lifeExp |  43.76400|
| Africa    |  1982|     48.86533| lifeExp |  44.85200|
| Africa    |  1987|     48.86533| lifeExp |  46.02700|
| Africa    |  1992|     48.86533| lifeExp |  40.80200|
| Africa    |  1997|     48.86533| lifeExp |  42.22100|
| Africa    |  2002|     48.86533| lifeExp |  43.75300|
| Africa    |  2007|     48.86533| lifeExp |  45.67800|
| Africa    |  1952|     48.86533| lifeExp |  42.72300|
| Africa    |  1957|     48.86533| lifeExp |  45.28900|
| Africa    |  1962|     48.86533| lifeExp |  47.80800|
| Africa    |  1967|     48.86533| lifeExp |  50.22700|
| Africa    |  1972|     48.86533| lifeExp |  52.77300|
| Africa    |  1977|     48.86533| lifeExp |  57.44200|
| Africa    |  1982|     48.86533| lifeExp |  62.15500|
| Africa    |  1987|     48.86533| lifeExp |  66.23400|
| Africa    |  1992|     48.86533| lifeExp |  68.75500|
| Africa    |  1997|     48.86533| lifeExp |  71.55500|
| Africa    |  2002|     48.86533| lifeExp |  72.73700|
| Africa    |  2007|     48.86533| lifeExp |  73.95200|
| Africa    |  1952|     48.86533| lifeExp |  36.68100|
| Africa    |  1957|     48.86533| lifeExp |  38.86500|
| Africa    |  1962|     48.86533| lifeExp |  40.84800|
| Africa    |  1967|     48.86533| lifeExp |  42.88100|
| Africa    |  1972|     48.86533| lifeExp |  44.85100|
| Africa    |  1977|     48.86533| lifeExp |  46.88100|
| Africa    |  1982|     48.86533| lifeExp |  48.96900|
| Africa    |  1987|     48.86533| lifeExp |  49.35000|
| Africa    |  1992|     48.86533| lifeExp |  52.21400|
| Africa    |  1997|     48.86533| lifeExp |  54.97800|
| Africa    |  2002|     48.86533| lifeExp |  57.28600|
| Africa    |  2007|     48.86533| lifeExp |  59.44300|
| Africa    |  1952|     48.86533| lifeExp |  36.25600|
| Africa    |  1957|     48.86533| lifeExp |  37.20700|
| Africa    |  1962|     48.86533| lifeExp |  38.41000|
| Africa    |  1967|     48.86533| lifeExp |  39.48700|
| Africa    |  1972|     48.86533| lifeExp |  41.76600|
| Africa    |  1977|     48.86533| lifeExp |  43.76700|
| Africa    |  1982|     48.86533| lifeExp |  45.64200|
| Africa    |  1987|     48.86533| lifeExp |  47.45700|
| Africa    |  1992|     48.86533| lifeExp |  49.42000|
| Africa    |  1997|     48.86533| lifeExp |  47.49500|
| Africa    |  2002|     48.86533| lifeExp |  45.00900|
| Africa    |  2007|     48.86533| lifeExp |  48.30300|
| Asia      |  1952|     60.06490| lifeExp |  48.46300|
| Asia      |  1957|     60.06490| lifeExp |  52.10200|
| Asia      |  1962|     60.06490| lifeExp |  55.73700|
| Asia      |  1967|     60.06490| lifeExp |  59.37100|
| Asia      |  1972|     60.06490| lifeExp |  63.01000|
| Asia      |  1977|     60.06490| lifeExp |  65.25600|
| Asia      |  1982|     60.06490| lifeExp |  68.00000|
| Asia      |  1987|     60.06490| lifeExp |  69.50000|
| Asia      |  1992|     60.06490| lifeExp |  70.69300|
| Asia      |  1997|     60.06490| lifeExp |  71.93800|
| Asia      |  2002|     60.06490| lifeExp |  73.04400|
| Asia      |  2007|     60.06490| lifeExp |  74.24100|
| Africa    |  1952|     48.86533| lifeExp |  33.68500|
| Africa    |  1957|     48.86533| lifeExp |  35.30700|
| Africa    |  1962|     48.86533| lifeExp |  36.93600|
| Africa    |  1967|     48.86533| lifeExp |  38.48700|
| Africa    |  1972|     48.86533| lifeExp |  39.97700|
| Africa    |  1977|     48.86533| lifeExp |  41.71400|
| Africa    |  1982|     48.86533| lifeExp |  43.91600|
| Africa    |  1987|     48.86533| lifeExp |  46.36400|
| Africa    |  1992|     48.86533| lifeExp |  48.38800|
| Africa    |  1997|     48.86533| lifeExp |  49.90300|
| Africa    |  2002|     48.86533| lifeExp |  51.81800|
| Africa    |  2007|     48.86533| lifeExp |  54.46700|
| Africa    |  1952|     48.86533| lifeExp |  40.54300|
| Africa    |  1957|     48.86533| lifeExp |  42.33800|
| Africa    |  1962|     48.86533| lifeExp |  44.24800|
| Africa    |  1967|     48.86533| lifeExp |  46.28900|
| Africa    |  1972|     48.86533| lifeExp |  48.43700|
| Africa    |  1977|     48.86533| lifeExp |  50.85200|
| Africa    |  1982|     48.86533| lifeExp |  53.59900|
| Africa    |  1987|     48.86533| lifeExp |  56.14500|
| Africa    |  1992|     48.86533| lifeExp |  58.33300|
| Africa    |  1997|     48.86533| lifeExp |  60.43000|
| Africa    |  2002|     48.86533| lifeExp |  62.24700|
| Africa    |  2007|     48.86533| lifeExp |  64.16400|
| Africa    |  1952|     48.86533| lifeExp |  50.98600|
| Africa    |  1957|     48.86533| lifeExp |  58.08900|
| Africa    |  1962|     48.86533| lifeExp |  60.24600|
| Africa    |  1967|     48.86533| lifeExp |  61.55700|
| Africa    |  1972|     48.86533| lifeExp |  62.94400|
| Africa    |  1977|     48.86533| lifeExp |  64.93000|
| Africa    |  1982|     48.86533| lifeExp |  66.71100|
| Africa    |  1987|     48.86533| lifeExp |  68.74000|
| Africa    |  1992|     48.86533| lifeExp |  69.74500|
| Africa    |  1997|     48.86533| lifeExp |  70.73600|
| Africa    |  2002|     48.86533| lifeExp |  71.95400|
| Africa    |  2007|     48.86533| lifeExp |  72.80100|
| Americas  |  1952|     64.65874| lifeExp |  50.78900|
| Americas  |  1957|     64.65874| lifeExp |  55.19000|
| Americas  |  1962|     64.65874| lifeExp |  58.29900|
| Americas  |  1967|     64.65874| lifeExp |  60.11000|
| Americas  |  1972|     64.65874| lifeExp |  62.36100|
| Americas  |  1977|     64.65874| lifeExp |  65.03200|
| Americas  |  1982|     64.65874| lifeExp |  67.40500|
| Americas  |  1987|     64.65874| lifeExp |  69.49800|
| Americas  |  1992|     64.65874| lifeExp |  71.45500|
| Americas  |  1997|     64.65874| lifeExp |  73.67000|
| Americas  |  2002|     64.65874| lifeExp |  74.90200|
| Americas  |  2007|     64.65874| lifeExp |  76.19500|
| Asia      |  1952|     60.06490| lifeExp |  42.24400|
| Asia      |  1957|     60.06490| lifeExp |  45.24800|
| Asia      |  1962|     60.06490| lifeExp |  48.25100|
| Asia      |  1967|     60.06490| lifeExp |  51.25300|
| Asia      |  1972|     60.06490| lifeExp |  53.75400|
| Asia      |  1977|     60.06490| lifeExp |  55.49100|
| Asia      |  1982|     60.06490| lifeExp |  57.48900|
| Asia      |  1987|     60.06490| lifeExp |  60.22200|
| Asia      |  1992|     60.06490| lifeExp |  61.27100|
| Asia      |  1997|     60.06490| lifeExp |  63.62500|
| Asia      |  2002|     60.06490| lifeExp |  65.03300|
| Asia      |  2007|     60.06490| lifeExp |  66.80300|
| Europe    |  1952|     71.90369| lifeExp |  59.16400|
| Europe    |  1957|     71.90369| lifeExp |  61.44800|
| Europe    |  1962|     71.90369| lifeExp |  63.72800|
| Europe    |  1967|     71.90369| lifeExp |  67.17800|
| Europe    |  1972|     71.90369| lifeExp |  70.63600|
| Europe    |  1977|     71.90369| lifeExp |  73.06600|
| Europe    |  1982|     71.90369| lifeExp |  74.10100|
| Europe    |  1987|     71.90369| lifeExp |  74.86500|
| Europe    |  1992|     71.90369| lifeExp |  75.43500|
| Europe    |  1997|     71.90369| lifeExp |  75.44500|
| Europe    |  2002|     71.90369| lifeExp |  73.98100|
| Europe    |  2007|     71.90369| lifeExp |  74.54300|
| Africa    |  1952|     48.86533| lifeExp |  42.87300|
| Africa    |  1957|     48.86533| lifeExp |  45.42300|
| Africa    |  1962|     48.86533| lifeExp |  47.92400|
| Africa    |  1967|     48.86533| lifeExp |  50.33500|
| Africa    |  1972|     48.86533| lifeExp |  52.86200|
| Africa    |  1977|     48.86533| lifeExp |  55.73000|
| Africa    |  1982|     48.86533| lifeExp |  59.65000|
| Africa    |  1987|     48.86533| lifeExp |  62.67700|
| Africa    |  1992|     48.86533| lifeExp |  65.39300|
| Africa    |  1997|     48.86533| lifeExp |  67.66000|
| Africa    |  2002|     48.86533| lifeExp |  69.61500|
| Africa    |  2007|     48.86533| lifeExp |  71.16400|
| Africa    |  1952|     48.86533| lifeExp |  31.28600|
| Africa    |  1957|     48.86533| lifeExp |  33.77900|
| Africa    |  1962|     48.86533| lifeExp |  36.16100|
| Africa    |  1967|     48.86533| lifeExp |  38.11300|
| Africa    |  1972|     48.86533| lifeExp |  40.32800|
| Africa    |  1977|     48.86533| lifeExp |  42.49500|
| Africa    |  1982|     48.86533| lifeExp |  42.79500|
| Africa    |  1987|     48.86533| lifeExp |  42.86100|
| Africa    |  1992|     48.86533| lifeExp |  44.28400|
| Africa    |  1997|     48.86533| lifeExp |  46.34400|
| Africa    |  2002|     48.86533| lifeExp |  44.02600|
| Africa    |  2007|     48.86533| lifeExp |  42.08200|
| Asia      |  1952|     60.06490| lifeExp |  36.31900|
| Asia      |  1957|     60.06490| lifeExp |  41.90500|
| Asia      |  1962|     60.06490| lifeExp |  45.10800|
| Asia      |  1967|     60.06490| lifeExp |  49.37900|
| Asia      |  1972|     60.06490| lifeExp |  53.07000|
| Asia      |  1977|     60.06490| lifeExp |  56.05900|
| Asia      |  1982|     60.06490| lifeExp |  58.05600|
| Asia      |  1987|     60.06490| lifeExp |  58.33900|
| Asia      |  1992|     60.06490| lifeExp |  59.32000|
| Asia      |  1997|     60.06490| lifeExp |  60.32800|
| Asia      |  2002|     60.06490| lifeExp |  59.90800|
| Asia      |  2007|     60.06490| lifeExp |  62.06900|
| Africa    |  1952|     48.86533| lifeExp |  41.72500|
| Africa    |  1957|     48.86533| lifeExp |  45.22600|
| Africa    |  1962|     48.86533| lifeExp |  48.38600|
| Africa    |  1967|     48.86533| lifeExp |  51.15900|
| Africa    |  1972|     48.86533| lifeExp |  53.86700|
| Africa    |  1977|     48.86533| lifeExp |  56.43700|
| Africa    |  1982|     48.86533| lifeExp |  58.96800|
| Africa    |  1987|     48.86533| lifeExp |  60.83500|
| Africa    |  1992|     48.86533| lifeExp |  61.99900|
| Africa    |  1997|     48.86533| lifeExp |  58.90900|
| Africa    |  2002|     48.86533| lifeExp |  51.47900|
| Africa    |  2007|     48.86533| lifeExp |  52.90600|
| Asia      |  1952|     60.06490| lifeExp |  36.15700|
| Asia      |  1957|     60.06490| lifeExp |  37.68600|
| Asia      |  1962|     60.06490| lifeExp |  39.39300|
| Asia      |  1967|     60.06490| lifeExp |  41.47200|
| Asia      |  1972|     60.06490| lifeExp |  43.97100|
| Asia      |  1977|     60.06490| lifeExp |  46.74800|
| Asia      |  1982|     60.06490| lifeExp |  49.59400|
| Asia      |  1987|     60.06490| lifeExp |  52.53700|
| Asia      |  1992|     60.06490| lifeExp |  55.72700|
| Asia      |  1997|     60.06490| lifeExp |  59.42600|
| Asia      |  2002|     60.06490| lifeExp |  61.34000|
| Asia      |  2007|     60.06490| lifeExp |  63.78500|
| Europe    |  1952|     71.90369| lifeExp |  72.13000|
| Europe    |  1957|     71.90369| lifeExp |  72.99000|
| Europe    |  1962|     71.90369| lifeExp |  73.23000|
| Europe    |  1967|     71.90369| lifeExp |  73.82000|
| Europe    |  1972|     71.90369| lifeExp |  73.75000|
| Europe    |  1977|     71.90369| lifeExp |  75.24000|
| Europe    |  1982|     71.90369| lifeExp |  76.05000|
| Europe    |  1987|     71.90369| lifeExp |  76.83000|
| Europe    |  1992|     71.90369| lifeExp |  77.42000|
| Europe    |  1997|     71.90369| lifeExp |  78.03000|
| Europe    |  2002|     71.90369| lifeExp |  78.53000|
| Europe    |  2007|     71.90369| lifeExp |  79.76200|
| Oceania   |  1952|     74.32621| lifeExp |  69.39000|
| Oceania   |  1957|     74.32621| lifeExp |  70.26000|
| Oceania   |  1962|     74.32621| lifeExp |  71.24000|
| Oceania   |  1967|     74.32621| lifeExp |  71.52000|
| Oceania   |  1972|     74.32621| lifeExp |  71.89000|
| Oceania   |  1977|     74.32621| lifeExp |  72.22000|
| Oceania   |  1982|     74.32621| lifeExp |  73.84000|
| Oceania   |  1987|     74.32621| lifeExp |  74.32000|
| Oceania   |  1992|     74.32621| lifeExp |  76.33000|
| Oceania   |  1997|     74.32621| lifeExp |  77.55000|
| Oceania   |  2002|     74.32621| lifeExp |  79.11000|
| Oceania   |  2007|     74.32621| lifeExp |  80.20400|
| Americas  |  1952|     64.65874| lifeExp |  42.31400|
| Americas  |  1957|     64.65874| lifeExp |  45.43200|
| Americas  |  1962|     64.65874| lifeExp |  48.63200|
| Americas  |  1967|     64.65874| lifeExp |  51.88400|
| Americas  |  1972|     64.65874| lifeExp |  55.15100|
| Americas  |  1977|     64.65874| lifeExp |  57.47000|
| Americas  |  1982|     64.65874| lifeExp |  59.29800|
| Americas  |  1987|     64.65874| lifeExp |  62.00800|
| Americas  |  1992|     64.65874| lifeExp |  65.84300|
| Americas  |  1997|     64.65874| lifeExp |  68.42600|
| Americas  |  2002|     64.65874| lifeExp |  70.83600|
| Americas  |  2007|     64.65874| lifeExp |  72.89900|
| Africa    |  1952|     48.86533| lifeExp |  37.44400|
| Africa    |  1957|     48.86533| lifeExp |  38.59800|
| Africa    |  1962|     48.86533| lifeExp |  39.48700|
| Africa    |  1967|     48.86533| lifeExp |  40.11800|
| Africa    |  1972|     48.86533| lifeExp |  40.54600|
| Africa    |  1977|     48.86533| lifeExp |  41.29100|
| Africa    |  1982|     48.86533| lifeExp |  42.59800|
| Africa    |  1987|     48.86533| lifeExp |  44.55500|
| Africa    |  1992|     48.86533| lifeExp |  47.39100|
| Africa    |  1997|     48.86533| lifeExp |  51.31300|
| Africa    |  2002|     48.86533| lifeExp |  54.49600|
| Africa    |  2007|     48.86533| lifeExp |  56.86700|
| Africa    |  1952|     48.86533| lifeExp |  36.32400|
| Africa    |  1957|     48.86533| lifeExp |  37.80200|
| Africa    |  1962|     48.86533| lifeExp |  39.36000|
| Africa    |  1967|     48.86533| lifeExp |  41.04000|
| Africa    |  1972|     48.86533| lifeExp |  42.82100|
| Africa    |  1977|     48.86533| lifeExp |  44.51400|
| Africa    |  1982|     48.86533| lifeExp |  45.82600|
| Africa    |  1987|     48.86533| lifeExp |  46.88600|
| Africa    |  1992|     48.86533| lifeExp |  47.47200|
| Africa    |  1997|     48.86533| lifeExp |  47.46400|
| Africa    |  2002|     48.86533| lifeExp |  46.60800|
| Africa    |  2007|     48.86533| lifeExp |  46.85900|
| Europe    |  1952|     71.90369| lifeExp |  72.67000|
| Europe    |  1957|     71.90369| lifeExp |  73.44000|
| Europe    |  1962|     71.90369| lifeExp |  73.47000|
| Europe    |  1967|     71.90369| lifeExp |  74.08000|
| Europe    |  1972|     71.90369| lifeExp |  74.34000|
| Europe    |  1977|     71.90369| lifeExp |  75.37000|
| Europe    |  1982|     71.90369| lifeExp |  75.97000|
| Europe    |  1987|     71.90369| lifeExp |  75.89000|
| Europe    |  1992|     71.90369| lifeExp |  77.32000|
| Europe    |  1997|     71.90369| lifeExp |  78.32000|
| Europe    |  2002|     71.90369| lifeExp |  79.05000|
| Europe    |  2007|     71.90369| lifeExp |  80.19600|
| Asia      |  1952|     60.06490| lifeExp |  37.57800|
| Asia      |  1957|     60.06490| lifeExp |  40.08000|
| Asia      |  1962|     60.06490| lifeExp |  43.16500|
| Asia      |  1967|     60.06490| lifeExp |  46.98800|
| Asia      |  1972|     60.06490| lifeExp |  52.14300|
| Asia      |  1977|     60.06490| lifeExp |  57.36700|
| Asia      |  1982|     60.06490| lifeExp |  62.72800|
| Asia      |  1987|     60.06490| lifeExp |  67.73400|
| Asia      |  1992|     60.06490| lifeExp |  71.19700|
| Asia      |  1997|     60.06490| lifeExp |  72.49900|
| Asia      |  2002|     60.06490| lifeExp |  74.19300|
| Asia      |  2007|     60.06490| lifeExp |  75.64000|
| Asia      |  1952|     60.06490| lifeExp |  43.43600|
| Asia      |  1957|     60.06490| lifeExp |  45.55700|
| Asia      |  1962|     60.06490| lifeExp |  47.67000|
| Asia      |  1967|     60.06490| lifeExp |  49.80000|
| Asia      |  1972|     60.06490| lifeExp |  51.92900|
| Asia      |  1977|     60.06490| lifeExp |  54.04300|
| Asia      |  1982|     60.06490| lifeExp |  56.15800|
| Asia      |  1987|     60.06490| lifeExp |  58.24500|
| Asia      |  1992|     60.06490| lifeExp |  60.83800|
| Asia      |  1997|     60.06490| lifeExp |  61.81800|
| Asia      |  2002|     60.06490| lifeExp |  63.61000|
| Asia      |  2007|     60.06490| lifeExp |  65.48300|
| Americas  |  1952|     64.65874| lifeExp |  55.19100|
| Americas  |  1957|     64.65874| lifeExp |  59.20100|
| Americas  |  1962|     64.65874| lifeExp |  61.81700|
| Americas  |  1967|     64.65874| lifeExp |  64.07100|
| Americas  |  1972|     64.65874| lifeExp |  66.21600|
| Americas  |  1977|     64.65874| lifeExp |  68.68100|
| Americas  |  1982|     64.65874| lifeExp |  70.47200|
| Americas  |  1987|     64.65874| lifeExp |  71.52300|
| Americas  |  1992|     64.65874| lifeExp |  72.46200|
| Americas  |  1997|     64.65874| lifeExp |  73.73800|
| Americas  |  2002|     64.65874| lifeExp |  74.71200|
| Americas  |  2007|     64.65874| lifeExp |  75.53700|
| Americas  |  1952|     64.65874| lifeExp |  62.64900|
| Americas  |  1957|     64.65874| lifeExp |  63.19600|
| Americas  |  1962|     64.65874| lifeExp |  64.36100|
| Americas  |  1967|     64.65874| lifeExp |  64.95100|
| Americas  |  1972|     64.65874| lifeExp |  65.81500|
| Americas  |  1977|     64.65874| lifeExp |  66.35300|
| Americas  |  1982|     64.65874| lifeExp |  66.87400|
| Americas  |  1987|     64.65874| lifeExp |  67.37800|
| Americas  |  1992|     64.65874| lifeExp |  68.22500|
| Americas  |  1997|     64.65874| lifeExp |  69.40000|
| Americas  |  2002|     64.65874| lifeExp |  70.75500|
| Americas  |  2007|     64.65874| lifeExp |  71.75200|
| Americas  |  1952|     64.65874| lifeExp |  43.90200|
| Americas  |  1957|     64.65874| lifeExp |  46.26300|
| Americas  |  1962|     64.65874| lifeExp |  49.09600|
| Americas  |  1967|     64.65874| lifeExp |  51.44500|
| Americas  |  1972|     64.65874| lifeExp |  55.44800|
| Americas  |  1977|     64.65874| lifeExp |  58.44700|
| Americas  |  1982|     64.65874| lifeExp |  61.40600|
| Americas  |  1987|     64.65874| lifeExp |  64.13400|
| Americas  |  1992|     64.65874| lifeExp |  66.45800|
| Americas  |  1997|     64.65874| lifeExp |  68.38600|
| Americas  |  2002|     64.65874| lifeExp |  69.90600|
| Americas  |  2007|     64.65874| lifeExp |  71.42100|
| Asia      |  1952|     60.06490| lifeExp |  47.75200|
| Asia      |  1957|     60.06490| lifeExp |  51.33400|
| Asia      |  1962|     60.06490| lifeExp |  54.75700|
| Asia      |  1967|     60.06490| lifeExp |  56.39300|
| Asia      |  1972|     60.06490| lifeExp |  58.06500|
| Asia      |  1977|     60.06490| lifeExp |  60.06000|
| Asia      |  1982|     60.06490| lifeExp |  62.08200|
| Asia      |  1987|     60.06490| lifeExp |  64.15100|
| Asia      |  1992|     60.06490| lifeExp |  66.45800|
| Asia      |  1997|     60.06490| lifeExp |  68.56400|
| Asia      |  2002|     60.06490| lifeExp |  70.30300|
| Asia      |  2007|     60.06490| lifeExp |  71.68800|
| Europe    |  1952|     71.90369| lifeExp |  61.31000|
| Europe    |  1957|     71.90369| lifeExp |  65.77000|
| Europe    |  1962|     71.90369| lifeExp |  67.64000|
| Europe    |  1967|     71.90369| lifeExp |  69.61000|
| Europe    |  1972|     71.90369| lifeExp |  70.85000|
| Europe    |  1977|     71.90369| lifeExp |  70.67000|
| Europe    |  1982|     71.90369| lifeExp |  71.32000|
| Europe    |  1987|     71.90369| lifeExp |  70.98000|
| Europe    |  1992|     71.90369| lifeExp |  70.99000|
| Europe    |  1997|     71.90369| lifeExp |  72.75000|
| Europe    |  2002|     71.90369| lifeExp |  74.67000|
| Europe    |  2007|     71.90369| lifeExp |  75.56300|
| Europe    |  1952|     71.90369| lifeExp |  59.82000|
| Europe    |  1957|     71.90369| lifeExp |  61.51000|
| Europe    |  1962|     71.90369| lifeExp |  64.39000|
| Europe    |  1967|     71.90369| lifeExp |  66.60000|
| Europe    |  1972|     71.90369| lifeExp |  69.26000|
| Europe    |  1977|     71.90369| lifeExp |  70.41000|
| Europe    |  1982|     71.90369| lifeExp |  72.77000|
| Europe    |  1987|     71.90369| lifeExp |  74.06000|
| Europe    |  1992|     71.90369| lifeExp |  74.86000|
| Europe    |  1997|     71.90369| lifeExp |  75.97000|
| Europe    |  2002|     71.90369| lifeExp |  77.29000|
| Europe    |  2007|     71.90369| lifeExp |  78.09800|
| Americas  |  1952|     64.65874| lifeExp |  64.28000|
| Americas  |  1957|     64.65874| lifeExp |  68.54000|
| Americas  |  1962|     64.65874| lifeExp |  69.62000|
| Americas  |  1967|     64.65874| lifeExp |  71.10000|
| Americas  |  1972|     64.65874| lifeExp |  72.16000|
| Americas  |  1977|     64.65874| lifeExp |  73.44000|
| Americas  |  1982|     64.65874| lifeExp |  73.75000|
| Americas  |  1987|     64.65874| lifeExp |  74.63000|
| Americas  |  1992|     64.65874| lifeExp |  73.91100|
| Americas  |  1997|     64.65874| lifeExp |  74.91700|
| Americas  |  2002|     64.65874| lifeExp |  77.77800|
| Americas  |  2007|     64.65874| lifeExp |  78.74600|
| Africa    |  1952|     48.86533| lifeExp |  52.72400|
| Africa    |  1957|     48.86533| lifeExp |  55.09000|
| Africa    |  1962|     48.86533| lifeExp |  57.66600|
| Africa    |  1967|     48.86533| lifeExp |  60.54200|
| Africa    |  1972|     48.86533| lifeExp |  64.27400|
| Africa    |  1977|     48.86533| lifeExp |  67.06400|
| Africa    |  1982|     48.86533| lifeExp |  69.88500|
| Africa    |  1987|     48.86533| lifeExp |  71.91300|
| Africa    |  1992|     48.86533| lifeExp |  73.61500|
| Africa    |  1997|     48.86533| lifeExp |  74.77200|
| Africa    |  2002|     48.86533| lifeExp |  75.74400|
| Africa    |  2007|     48.86533| lifeExp |  76.44200|
| Europe    |  1952|     71.90369| lifeExp |  61.05000|
| Europe    |  1957|     71.90369| lifeExp |  64.10000|
| Europe    |  1962|     71.90369| lifeExp |  66.80000|
| Europe    |  1967|     71.90369| lifeExp |  66.80000|
| Europe    |  1972|     71.90369| lifeExp |  69.21000|
| Europe    |  1977|     71.90369| lifeExp |  69.46000|
| Europe    |  1982|     71.90369| lifeExp |  69.66000|
| Europe    |  1987|     71.90369| lifeExp |  69.53000|
| Europe    |  1992|     71.90369| lifeExp |  69.36000|
| Europe    |  1997|     71.90369| lifeExp |  69.72000|
| Europe    |  2002|     71.90369| lifeExp |  71.32200|
| Europe    |  2007|     71.90369| lifeExp |  72.47600|
| Africa    |  1952|     48.86533| lifeExp |  40.00000|
| Africa    |  1957|     48.86533| lifeExp |  41.50000|
| Africa    |  1962|     48.86533| lifeExp |  43.00000|
| Africa    |  1967|     48.86533| lifeExp |  44.10000|
| Africa    |  1972|     48.86533| lifeExp |  44.60000|
| Africa    |  1977|     48.86533| lifeExp |  45.00000|
| Africa    |  1982|     48.86533| lifeExp |  46.21800|
| Africa    |  1987|     48.86533| lifeExp |  44.02000|
| Africa    |  1992|     48.86533| lifeExp |  23.59900|
| Africa    |  1997|     48.86533| lifeExp |  36.08700|
| Africa    |  2002|     48.86533| lifeExp |  43.41300|
| Africa    |  2007|     48.86533| lifeExp |  46.24200|
| Africa    |  1952|     48.86533| lifeExp |  46.47100|
| Africa    |  1957|     48.86533| lifeExp |  48.94500|
| Africa    |  1962|     48.86533| lifeExp |  51.89300|
| Africa    |  1967|     48.86533| lifeExp |  54.42500|
| Africa    |  1972|     48.86533| lifeExp |  56.48000|
| Africa    |  1977|     48.86533| lifeExp |  58.55000|
| Africa    |  1982|     48.86533| lifeExp |  60.35100|
| Africa    |  1987|     48.86533| lifeExp |  61.72800|
| Africa    |  1992|     48.86533| lifeExp |  62.74200|
| Africa    |  1997|     48.86533| lifeExp |  63.30600|
| Africa    |  2002|     48.86533| lifeExp |  64.33700|
| Africa    |  2007|     48.86533| lifeExp |  65.52800|
| Asia      |  1952|     60.06490| lifeExp |  39.87500|
| Asia      |  1957|     60.06490| lifeExp |  42.86800|
| Asia      |  1962|     60.06490| lifeExp |  45.91400|
| Asia      |  1967|     60.06490| lifeExp |  49.90100|
| Asia      |  1972|     60.06490| lifeExp |  53.88600|
| Asia      |  1977|     60.06490| lifeExp |  58.69000|
| Asia      |  1982|     60.06490| lifeExp |  63.01200|
| Asia      |  1987|     60.06490| lifeExp |  66.29500|
| Asia      |  1992|     60.06490| lifeExp |  68.76800|
| Asia      |  1997|     60.06490| lifeExp |  70.53300|
| Asia      |  2002|     60.06490| lifeExp |  71.62600|
| Asia      |  2007|     60.06490| lifeExp |  72.77700|
| Africa    |  1952|     48.86533| lifeExp |  37.27800|
| Africa    |  1957|     48.86533| lifeExp |  39.32900|
| Africa    |  1962|     48.86533| lifeExp |  41.45400|
| Africa    |  1967|     48.86533| lifeExp |  43.56300|
| Africa    |  1972|     48.86533| lifeExp |  45.81500|
| Africa    |  1977|     48.86533| lifeExp |  48.87900|
| Africa    |  1982|     48.86533| lifeExp |  52.37900|
| Africa    |  1987|     48.86533| lifeExp |  55.76900|
| Africa    |  1992|     48.86533| lifeExp |  58.19600|
| Africa    |  1997|     48.86533| lifeExp |  60.18700|
| Africa    |  2002|     48.86533| lifeExp |  61.60000|
| Africa    |  2007|     48.86533| lifeExp |  63.06200|
| Europe    |  1952|     71.90369| lifeExp |  57.99600|
| Europe    |  1957|     71.90369| lifeExp |  61.68500|
| Europe    |  1962|     71.90369| lifeExp |  64.53100|
| Europe    |  1967|     71.90369| lifeExp |  66.91400|
| Europe    |  1972|     71.90369| lifeExp |  68.70000|
| Europe    |  1977|     71.90369| lifeExp |  70.30000|
| Europe    |  1982|     71.90369| lifeExp |  70.16200|
| Europe    |  1987|     71.90369| lifeExp |  71.21800|
| Europe    |  1992|     71.90369| lifeExp |  71.65900|
| Europe    |  1997|     71.90369| lifeExp |  72.23200|
| Europe    |  2002|     71.90369| lifeExp |  73.21300|
| Europe    |  2007|     71.90369| lifeExp |  74.00200|
| Africa    |  1952|     48.86533| lifeExp |  30.33100|
| Africa    |  1957|     48.86533| lifeExp |  31.57000|
| Africa    |  1962|     48.86533| lifeExp |  32.76700|
| Africa    |  1967|     48.86533| lifeExp |  34.11300|
| Africa    |  1972|     48.86533| lifeExp |  35.40000|
| Africa    |  1977|     48.86533| lifeExp |  36.78800|
| Africa    |  1982|     48.86533| lifeExp |  38.44500|
| Africa    |  1987|     48.86533| lifeExp |  40.00600|
| Africa    |  1992|     48.86533| lifeExp |  38.33300|
| Africa    |  1997|     48.86533| lifeExp |  39.89700|
| Africa    |  2002|     48.86533| lifeExp |  41.01200|
| Africa    |  2007|     48.86533| lifeExp |  42.56800|
| Asia      |  1952|     60.06490| lifeExp |  60.39600|
| Asia      |  1957|     60.06490| lifeExp |  63.17900|
| Asia      |  1962|     60.06490| lifeExp |  65.79800|
| Asia      |  1967|     60.06490| lifeExp |  67.94600|
| Asia      |  1972|     60.06490| lifeExp |  69.52100|
| Asia      |  1977|     60.06490| lifeExp |  70.79500|
| Asia      |  1982|     60.06490| lifeExp |  71.76000|
| Asia      |  1987|     60.06490| lifeExp |  73.56000|
| Asia      |  1992|     60.06490| lifeExp |  75.78800|
| Asia      |  1997|     60.06490| lifeExp |  77.15800|
| Asia      |  2002|     60.06490| lifeExp |  78.77000|
| Asia      |  2007|     60.06490| lifeExp |  79.97200|
| Europe    |  1952|     71.90369| lifeExp |  64.36000|
| Europe    |  1957|     71.90369| lifeExp |  67.45000|
| Europe    |  1962|     71.90369| lifeExp |  70.33000|
| Europe    |  1967|     71.90369| lifeExp |  70.98000|
| Europe    |  1972|     71.90369| lifeExp |  70.35000|
| Europe    |  1977|     71.90369| lifeExp |  70.45000|
| Europe    |  1982|     71.90369| lifeExp |  70.80000|
| Europe    |  1987|     71.90369| lifeExp |  71.08000|
| Europe    |  1992|     71.90369| lifeExp |  71.38000|
| Europe    |  1997|     71.90369| lifeExp |  72.71000|
| Europe    |  2002|     71.90369| lifeExp |  73.80000|
| Europe    |  2007|     71.90369| lifeExp |  74.66300|
| Europe    |  1952|     71.90369| lifeExp |  65.57000|
| Europe    |  1957|     71.90369| lifeExp |  67.85000|
| Europe    |  1962|     71.90369| lifeExp |  69.15000|
| Europe    |  1967|     71.90369| lifeExp |  69.18000|
| Europe    |  1972|     71.90369| lifeExp |  69.82000|
| Europe    |  1977|     71.90369| lifeExp |  70.97000|
| Europe    |  1982|     71.90369| lifeExp |  71.06300|
| Europe    |  1987|     71.90369| lifeExp |  72.25000|
| Europe    |  1992|     71.90369| lifeExp |  73.64000|
| Europe    |  1997|     71.90369| lifeExp |  75.13000|
| Europe    |  2002|     71.90369| lifeExp |  76.66000|
| Europe    |  2007|     71.90369| lifeExp |  77.92600|
| Africa    |  1952|     48.86533| lifeExp |  32.97800|
| Africa    |  1957|     48.86533| lifeExp |  34.97700|
| Africa    |  1962|     48.86533| lifeExp |  36.98100|
| Africa    |  1967|     48.86533| lifeExp |  38.97700|
| Africa    |  1972|     48.86533| lifeExp |  40.97300|
| Africa    |  1977|     48.86533| lifeExp |  41.97400|
| Africa    |  1982|     48.86533| lifeExp |  42.95500|
| Africa    |  1987|     48.86533| lifeExp |  44.50100|
| Africa    |  1992|     48.86533| lifeExp |  39.65800|
| Africa    |  1997|     48.86533| lifeExp |  43.79500|
| Africa    |  2002|     48.86533| lifeExp |  45.93600|
| Africa    |  2007|     48.86533| lifeExp |  48.15900|
| Africa    |  1952|     48.86533| lifeExp |  45.00900|
| Africa    |  1957|     48.86533| lifeExp |  47.98500|
| Africa    |  1962|     48.86533| lifeExp |  49.95100|
| Africa    |  1967|     48.86533| lifeExp |  51.92700|
| Africa    |  1972|     48.86533| lifeExp |  53.69600|
| Africa    |  1977|     48.86533| lifeExp |  55.52700|
| Africa    |  1982|     48.86533| lifeExp |  58.16100|
| Africa    |  1987|     48.86533| lifeExp |  60.83400|
| Africa    |  1992|     48.86533| lifeExp |  61.88800|
| Africa    |  1997|     48.86533| lifeExp |  60.23600|
| Africa    |  2002|     48.86533| lifeExp |  53.36500|
| Africa    |  2007|     48.86533| lifeExp |  49.33900|
| Europe    |  1952|     71.90369| lifeExp |  64.94000|
| Europe    |  1957|     71.90369| lifeExp |  66.66000|
| Europe    |  1962|     71.90369| lifeExp |  69.69000|
| Europe    |  1967|     71.90369| lifeExp |  71.44000|
| Europe    |  1972|     71.90369| lifeExp |  73.06000|
| Europe    |  1977|     71.90369| lifeExp |  74.39000|
| Europe    |  1982|     71.90369| lifeExp |  76.30000|
| Europe    |  1987|     71.90369| lifeExp |  76.90000|
| Europe    |  1992|     71.90369| lifeExp |  77.57000|
| Europe    |  1997|     71.90369| lifeExp |  78.77000|
| Europe    |  2002|     71.90369| lifeExp |  79.78000|
| Europe    |  2007|     71.90369| lifeExp |  80.94100|
| Asia      |  1952|     60.06490| lifeExp |  57.59300|
| Asia      |  1957|     60.06490| lifeExp |  61.45600|
| Asia      |  1962|     60.06490| lifeExp |  62.19200|
| Asia      |  1967|     60.06490| lifeExp |  64.26600|
| Asia      |  1972|     60.06490| lifeExp |  65.04200|
| Asia      |  1977|     60.06490| lifeExp |  65.94900|
| Asia      |  1982|     60.06490| lifeExp |  68.75700|
| Asia      |  1987|     60.06490| lifeExp |  69.01100|
| Asia      |  1992|     60.06490| lifeExp |  70.37900|
| Asia      |  1997|     60.06490| lifeExp |  70.45700|
| Asia      |  2002|     60.06490| lifeExp |  70.81500|
| Asia      |  2007|     60.06490| lifeExp |  72.39600|
| Africa    |  1952|     48.86533| lifeExp |  38.63500|
| Africa    |  1957|     48.86533| lifeExp |  39.62400|
| Africa    |  1962|     48.86533| lifeExp |  40.87000|
| Africa    |  1967|     48.86533| lifeExp |  42.85800|
| Africa    |  1972|     48.86533| lifeExp |  45.08300|
| Africa    |  1977|     48.86533| lifeExp |  47.80000|
| Africa    |  1982|     48.86533| lifeExp |  50.33800|
| Africa    |  1987|     48.86533| lifeExp |  51.74400|
| Africa    |  1992|     48.86533| lifeExp |  53.55600|
| Africa    |  1997|     48.86533| lifeExp |  55.37300|
| Africa    |  2002|     48.86533| lifeExp |  56.36900|
| Africa    |  2007|     48.86533| lifeExp |  58.55600|
| Africa    |  1952|     48.86533| lifeExp |  41.40700|
| Africa    |  1957|     48.86533| lifeExp |  43.42400|
| Africa    |  1962|     48.86533| lifeExp |  44.99200|
| Africa    |  1967|     48.86533| lifeExp |  46.63300|
| Africa    |  1972|     48.86533| lifeExp |  49.55200|
| Africa    |  1977|     48.86533| lifeExp |  52.53700|
| Africa    |  1982|     48.86533| lifeExp |  55.56100|
| Africa    |  1987|     48.86533| lifeExp |  57.67800|
| Africa    |  1992|     48.86533| lifeExp |  58.47400|
| Africa    |  1997|     48.86533| lifeExp |  54.28900|
| Africa    |  2002|     48.86533| lifeExp |  43.86900|
| Africa    |  2007|     48.86533| lifeExp |  39.61300|
| Europe    |  1952|     71.90369| lifeExp |  71.86000|
| Europe    |  1957|     71.90369| lifeExp |  72.49000|
| Europe    |  1962|     71.90369| lifeExp |  73.37000|
| Europe    |  1967|     71.90369| lifeExp |  74.16000|
| Europe    |  1972|     71.90369| lifeExp |  74.72000|
| Europe    |  1977|     71.90369| lifeExp |  75.44000|
| Europe    |  1982|     71.90369| lifeExp |  76.42000|
| Europe    |  1987|     71.90369| lifeExp |  77.19000|
| Europe    |  1992|     71.90369| lifeExp |  78.16000|
| Europe    |  1997|     71.90369| lifeExp |  79.39000|
| Europe    |  2002|     71.90369| lifeExp |  80.04000|
| Europe    |  2007|     71.90369| lifeExp |  80.88400|
| Europe    |  1952|     71.90369| lifeExp |  69.62000|
| Europe    |  1957|     71.90369| lifeExp |  70.56000|
| Europe    |  1962|     71.90369| lifeExp |  71.32000|
| Europe    |  1967|     71.90369| lifeExp |  72.77000|
| Europe    |  1972|     71.90369| lifeExp |  73.78000|
| Europe    |  1977|     71.90369| lifeExp |  75.39000|
| Europe    |  1982|     71.90369| lifeExp |  76.21000|
| Europe    |  1987|     71.90369| lifeExp |  77.41000|
| Europe    |  1992|     71.90369| lifeExp |  78.03000|
| Europe    |  1997|     71.90369| lifeExp |  79.37000|
| Europe    |  2002|     71.90369| lifeExp |  80.62000|
| Europe    |  2007|     71.90369| lifeExp |  81.70100|
| Asia      |  1952|     60.06490| lifeExp |  45.88300|
| Asia      |  1957|     60.06490| lifeExp |  48.28400|
| Asia      |  1962|     60.06490| lifeExp |  50.30500|
| Asia      |  1967|     60.06490| lifeExp |  53.65500|
| Asia      |  1972|     60.06490| lifeExp |  57.29600|
| Asia      |  1977|     60.06490| lifeExp |  61.19500|
| Asia      |  1982|     60.06490| lifeExp |  64.59000|
| Asia      |  1987|     60.06490| lifeExp |  66.97400|
| Asia      |  1992|     60.06490| lifeExp |  69.24900|
| Asia      |  1997|     60.06490| lifeExp |  71.52700|
| Asia      |  2002|     60.06490| lifeExp |  73.05300|
| Asia      |  2007|     60.06490| lifeExp |  74.14300|
| Asia      |  1952|     60.06490| lifeExp |  58.50000|
| Asia      |  1957|     60.06490| lifeExp |  62.40000|
| Asia      |  1962|     60.06490| lifeExp |  65.20000|
| Asia      |  1967|     60.06490| lifeExp |  67.50000|
| Asia      |  1972|     60.06490| lifeExp |  69.39000|
| Asia      |  1977|     60.06490| lifeExp |  70.59000|
| Asia      |  1982|     60.06490| lifeExp |  72.16000|
| Asia      |  1987|     60.06490| lifeExp |  73.40000|
| Asia      |  1992|     60.06490| lifeExp |  74.26000|
| Asia      |  1997|     60.06490| lifeExp |  75.25000|
| Asia      |  2002|     60.06490| lifeExp |  76.99000|
| Asia      |  2007|     60.06490| lifeExp |  78.40000|
| Africa    |  1952|     48.86533| lifeExp |  41.21500|
| Africa    |  1957|     48.86533| lifeExp |  42.97400|
| Africa    |  1962|     48.86533| lifeExp |  44.24600|
| Africa    |  1967|     48.86533| lifeExp |  45.75700|
| Africa    |  1972|     48.86533| lifeExp |  47.62000|
| Africa    |  1977|     48.86533| lifeExp |  49.91900|
| Africa    |  1982|     48.86533| lifeExp |  50.60800|
| Africa    |  1987|     48.86533| lifeExp |  51.53500|
| Africa    |  1992|     48.86533| lifeExp |  50.44000|
| Africa    |  1997|     48.86533| lifeExp |  48.46600|
| Africa    |  2002|     48.86533| lifeExp |  49.65100|
| Africa    |  2007|     48.86533| lifeExp |  52.51700|
| Asia      |  1952|     60.06490| lifeExp |  50.84800|
| Asia      |  1957|     60.06490| lifeExp |  53.63000|
| Asia      |  1962|     60.06490| lifeExp |  56.06100|
| Asia      |  1967|     60.06490| lifeExp |  58.28500|
| Asia      |  1972|     60.06490| lifeExp |  60.40500|
| Asia      |  1977|     60.06490| lifeExp |  62.49400|
| Asia      |  1982|     60.06490| lifeExp |  64.59700|
| Asia      |  1987|     60.06490| lifeExp |  66.08400|
| Asia      |  1992|     60.06490| lifeExp |  67.29800|
| Asia      |  1997|     60.06490| lifeExp |  67.52100|
| Asia      |  2002|     60.06490| lifeExp |  68.56400|
| Asia      |  2007|     60.06490| lifeExp |  70.61600|
| Africa    |  1952|     48.86533| lifeExp |  38.59600|
| Africa    |  1957|     48.86533| lifeExp |  41.20800|
| Africa    |  1962|     48.86533| lifeExp |  43.92200|
| Africa    |  1967|     48.86533| lifeExp |  46.76900|
| Africa    |  1972|     48.86533| lifeExp |  49.75900|
| Africa    |  1977|     48.86533| lifeExp |  52.88700|
| Africa    |  1982|     48.86533| lifeExp |  55.47100|
| Africa    |  1987|     48.86533| lifeExp |  56.94100|
| Africa    |  1992|     48.86533| lifeExp |  58.06100|
| Africa    |  1997|     48.86533| lifeExp |  58.39000|
| Africa    |  2002|     48.86533| lifeExp |  57.56100|
| Africa    |  2007|     48.86533| lifeExp |  58.42000|
| Americas  |  1952|     64.65874| lifeExp |  59.10000|
| Americas  |  1957|     64.65874| lifeExp |  61.80000|
| Americas  |  1962|     64.65874| lifeExp |  64.90000|
| Americas  |  1967|     64.65874| lifeExp |  65.40000|
| Americas  |  1972|     64.65874| lifeExp |  65.90000|
| Americas  |  1977|     64.65874| lifeExp |  68.30000|
| Americas  |  1982|     64.65874| lifeExp |  68.83200|
| Americas  |  1987|     64.65874| lifeExp |  69.58200|
| Americas  |  1992|     64.65874| lifeExp |  69.86200|
| Americas  |  1997|     64.65874| lifeExp |  69.46500|
| Americas  |  2002|     64.65874| lifeExp |  68.97600|
| Americas  |  2007|     64.65874| lifeExp |  69.81900|
| Africa    |  1952|     48.86533| lifeExp |  44.60000|
| Africa    |  1957|     48.86533| lifeExp |  47.10000|
| Africa    |  1962|     48.86533| lifeExp |  49.57900|
| Africa    |  1967|     48.86533| lifeExp |  52.05300|
| Africa    |  1972|     48.86533| lifeExp |  55.60200|
| Africa    |  1977|     48.86533| lifeExp |  59.83700|
| Africa    |  1982|     48.86533| lifeExp |  64.04800|
| Africa    |  1987|     48.86533| lifeExp |  66.89400|
| Africa    |  1992|     48.86533| lifeExp |  70.00100|
| Africa    |  1997|     48.86533| lifeExp |  71.97300|
| Africa    |  2002|     48.86533| lifeExp |  73.04200|
| Africa    |  2007|     48.86533| lifeExp |  73.92300|
| Europe    |  1952|     71.90369| lifeExp |  43.58500|
| Europe    |  1957|     71.90369| lifeExp |  48.07900|
| Europe    |  1962|     71.90369| lifeExp |  52.09800|
| Europe    |  1967|     71.90369| lifeExp |  54.33600|
| Europe    |  1972|     71.90369| lifeExp |  57.00500|
| Europe    |  1977|     71.90369| lifeExp |  59.50700|
| Europe    |  1982|     71.90369| lifeExp |  61.03600|
| Europe    |  1987|     71.90369| lifeExp |  63.10800|
| Europe    |  1992|     71.90369| lifeExp |  66.14600|
| Europe    |  1997|     71.90369| lifeExp |  68.83500|
| Europe    |  2002|     71.90369| lifeExp |  70.84500|
| Europe    |  2007|     71.90369| lifeExp |  71.77700|
| Africa    |  1952|     48.86533| lifeExp |  39.97800|
| Africa    |  1957|     48.86533| lifeExp |  42.57100|
| Africa    |  1962|     48.86533| lifeExp |  45.34400|
| Africa    |  1967|     48.86533| lifeExp |  48.05100|
| Africa    |  1972|     48.86533| lifeExp |  51.01600|
| Africa    |  1977|     48.86533| lifeExp |  50.35000|
| Africa    |  1982|     48.86533| lifeExp |  49.84900|
| Africa    |  1987|     48.86533| lifeExp |  51.50900|
| Africa    |  1992|     48.86533| lifeExp |  48.82500|
| Africa    |  1997|     48.86533| lifeExp |  44.57800|
| Africa    |  2002|     48.86533| lifeExp |  47.81300|
| Africa    |  2007|     48.86533| lifeExp |  51.54200|
| Europe    |  1952|     71.90369| lifeExp |  69.18000|
| Europe    |  1957|     71.90369| lifeExp |  70.42000|
| Europe    |  1962|     71.90369| lifeExp |  70.76000|
| Europe    |  1967|     71.90369| lifeExp |  71.36000|
| Europe    |  1972|     71.90369| lifeExp |  72.01000|
| Europe    |  1977|     71.90369| lifeExp |  72.76000|
| Europe    |  1982|     71.90369| lifeExp |  74.04000|
| Europe    |  1987|     71.90369| lifeExp |  75.00700|
| Europe    |  1992|     71.90369| lifeExp |  76.42000|
| Europe    |  1997|     71.90369| lifeExp |  77.21800|
| Europe    |  2002|     71.90369| lifeExp |  78.47100|
| Europe    |  2007|     71.90369| lifeExp |  79.42500|
| Americas  |  1952|     64.65874| lifeExp |  68.44000|
| Americas  |  1957|     64.65874| lifeExp |  69.49000|
| Americas  |  1962|     64.65874| lifeExp |  70.21000|
| Americas  |  1967|     64.65874| lifeExp |  70.76000|
| Americas  |  1972|     64.65874| lifeExp |  71.34000|
| Americas  |  1977|     64.65874| lifeExp |  73.38000|
| Americas  |  1982|     64.65874| lifeExp |  74.65000|
| Americas  |  1987|     64.65874| lifeExp |  75.02000|
| Americas  |  1992|     64.65874| lifeExp |  76.09000|
| Americas  |  1997|     64.65874| lifeExp |  76.81000|
| Americas  |  2002|     64.65874| lifeExp |  77.31000|
| Americas  |  2007|     64.65874| lifeExp |  78.24200|
| Americas  |  1952|     64.65874| lifeExp |  66.07100|
| Americas  |  1957|     64.65874| lifeExp |  67.04400|
| Americas  |  1962|     64.65874| lifeExp |  68.25300|
| Americas  |  1967|     64.65874| lifeExp |  68.46800|
| Americas  |  1972|     64.65874| lifeExp |  68.67300|
| Americas  |  1977|     64.65874| lifeExp |  69.48100|
| Americas  |  1982|     64.65874| lifeExp |  70.80500|
| Americas  |  1987|     64.65874| lifeExp |  71.91800|
| Americas  |  1992|     64.65874| lifeExp |  72.75200|
| Americas  |  1997|     64.65874| lifeExp |  74.22300|
| Americas  |  2002|     64.65874| lifeExp |  75.30700|
| Americas  |  2007|     64.65874| lifeExp |  76.38400|
| Americas  |  1952|     64.65874| lifeExp |  55.08800|
| Americas  |  1957|     64.65874| lifeExp |  57.90700|
| Americas  |  1962|     64.65874| lifeExp |  60.77000|
| Americas  |  1967|     64.65874| lifeExp |  63.47900|
| Americas  |  1972|     64.65874| lifeExp |  65.71200|
| Americas  |  1977|     64.65874| lifeExp |  67.45600|
| Americas  |  1982|     64.65874| lifeExp |  68.55700|
| Americas  |  1987|     64.65874| lifeExp |  70.19000|
| Americas  |  1992|     64.65874| lifeExp |  71.15000|
| Americas  |  1997|     64.65874| lifeExp |  72.14600|
| Americas  |  2002|     64.65874| lifeExp |  72.76600|
| Americas  |  2007|     64.65874| lifeExp |  73.74700|
| Asia      |  1952|     60.06490| lifeExp |  40.41200|
| Asia      |  1957|     60.06490| lifeExp |  42.88700|
| Asia      |  1962|     60.06490| lifeExp |  45.36300|
| Asia      |  1967|     60.06490| lifeExp |  47.83800|
| Asia      |  1972|     60.06490| lifeExp |  50.25400|
| Asia      |  1977|     60.06490| lifeExp |  55.76400|
| Asia      |  1982|     60.06490| lifeExp |  58.81600|
| Asia      |  1987|     60.06490| lifeExp |  62.82000|
| Asia      |  1992|     60.06490| lifeExp |  67.66200|
| Asia      |  1997|     60.06490| lifeExp |  70.67200|
| Asia      |  2002|     60.06490| lifeExp |  73.01700|
| Asia      |  2007|     60.06490| lifeExp |  74.24900|
| Asia      |  1952|     60.06490| lifeExp |  43.16000|
| Asia      |  1957|     60.06490| lifeExp |  45.67100|
| Asia      |  1962|     60.06490| lifeExp |  48.12700|
| Asia      |  1967|     60.06490| lifeExp |  51.63100|
| Asia      |  1972|     60.06490| lifeExp |  56.53200|
| Asia      |  1977|     60.06490| lifeExp |  60.76500|
| Asia      |  1982|     60.06490| lifeExp |  64.40600|
| Asia      |  1987|     60.06490| lifeExp |  67.04600|
| Asia      |  1992|     60.06490| lifeExp |  69.71800|
| Asia      |  1997|     60.06490| lifeExp |  71.09600|
| Asia      |  2002|     60.06490| lifeExp |  72.37000|
| Asia      |  2007|     60.06490| lifeExp |  73.42200|
| Asia      |  1952|     60.06490| lifeExp |  32.54800|
| Asia      |  1957|     60.06490| lifeExp |  33.97000|
| Asia      |  1962|     60.06490| lifeExp |  35.18000|
| Asia      |  1967|     60.06490| lifeExp |  36.98400|
| Asia      |  1972|     60.06490| lifeExp |  39.84800|
| Asia      |  1977|     60.06490| lifeExp |  44.17500|
| Asia      |  1982|     60.06490| lifeExp |  49.11300|
| Asia      |  1987|     60.06490| lifeExp |  52.92200|
| Asia      |  1992|     60.06490| lifeExp |  55.59900|
| Asia      |  1997|     60.06490| lifeExp |  58.02000|
| Asia      |  2002|     60.06490| lifeExp |  60.30800|
| Asia      |  2007|     60.06490| lifeExp |  62.69800|
| Africa    |  1952|     48.86533| lifeExp |  42.03800|
| Africa    |  1957|     48.86533| lifeExp |  44.07700|
| Africa    |  1962|     48.86533| lifeExp |  46.02300|
| Africa    |  1967|     48.86533| lifeExp |  47.76800|
| Africa    |  1972|     48.86533| lifeExp |  50.10700|
| Africa    |  1977|     48.86533| lifeExp |  51.38600|
| Africa    |  1982|     48.86533| lifeExp |  51.82100|
| Africa    |  1987|     48.86533| lifeExp |  50.82100|
| Africa    |  1992|     48.86533| lifeExp |  46.10000|
| Africa    |  1997|     48.86533| lifeExp |  40.23800|
| Africa    |  2002|     48.86533| lifeExp |  39.19300|
| Africa    |  2007|     48.86533| lifeExp |  42.38400|
| Africa    |  1952|     48.86533| lifeExp |  48.45100|
| Africa    |  1957|     48.86533| lifeExp |  50.46900|
| Africa    |  1962|     48.86533| lifeExp |  52.35800|
| Africa    |  1967|     48.86533| lifeExp |  53.99500|
| Africa    |  1972|     48.86533| lifeExp |  55.63500|
| Africa    |  1977|     48.86533| lifeExp |  57.67400|
| Africa    |  1982|     48.86533| lifeExp |  60.36300|
| Africa    |  1987|     48.86533| lifeExp |  62.35100|
| Africa    |  1992|     48.86533| lifeExp |  60.37700|
| Africa    |  1997|     48.86533| lifeExp |  46.80900|
| Africa    |  2002|     48.86533| lifeExp |  39.98900|
| Africa    |  2007|     48.86533| lifeExp |  43.48700|

-   The table summarizes the life expectancy per year per continent

Join Prompt: Join, Merge, Look up
=================================

Activity \#1
------------

-   Create a second data frame, complementary to Gapminder. Join this with (part of) Gapminder using a *dplyr* join function and make some observations about the process and result. Explore the different types of joins.

**Dataframe:** One row per country, a country variable and one or more variables with extra info, such as language spoken, NATO membership, national animal, or capitol city. If you really want to be helpful, you could attempt to make a pull request to resolve this issue, where I would like to bring ISO country codes into the gapminder package.

-   I am going to use WDI climate data set. We start with grabbing GNI per capita data for Chile, Hungary, Uruguay, Mexico, Canada, and USA for years 1952 - 2017.

``` r
library(WDI)
```

    ## Loading required package: RJSONIO

``` r
td.wdi <- WDI(indicator='NY.GDP.PCAP.KD', country=c('MX','CA','US','CL','HU','UY'), start=1952, end=2017) %>% 
  select(-iso2c)
knitr::kable(td.wdi)
```

| country       |  NY.GDP.PCAP.KD|  year|
|:--------------|---------------:|-----:|
| Canada        |       50231.885|  2016|
| Canada        |       50109.875|  2015|
| Canada        |       50067.043|  2014|
| Canada        |       49355.097|  2013|
| Canada        |       48724.246|  2012|
| Canada        |       48456.965|  2011|
| Canada        |       47447.476|  2010|
| Canada        |       46543.792|  2009|
| Canada        |       48510.568|  2008|
| Canada        |       48552.696|  2007|
| Canada        |       48035.036|  2006|
| Canada        |       47181.562|  2005|
| Canada        |       46170.920|  2004|
| Canada        |       45239.811|  2003|
| Canada        |       44883.828|  2002|
| Canada        |       43964.955|  2001|
| Canada        |       43638.283|  2000|
| Canada        |       41856.046|  1999|
| Canada        |       40131.702|  1998|
| Canada        |       38967.953|  1997|
| Canada        |       37765.732|  1996|
| Canada        |       37569.468|  1995|
| Canada        |       36893.982|  1994|
| Canada        |       35648.478|  1993|
| Canada        |       35108.519|  1992|
| Canada        |       35231.021|  1991|
| Canada        |       36489.266|  1990|
| Canada        |       36981.279|  1989|
| Canada        |       36791.760|  1988|
| Canada        |       35689.034|  1987|
| Canada        |       34737.275|  1986|
| Canada        |       34345.614|  1985|
| Canada        |       33099.374|  1984|
| Canada        |       31549.802|  1983|
| Canada        |       31060.645|  1982|
| Canada        |       32477.296|  1981|
| Canada        |       31769.783|  1980|
| Canada        |       31502.044|  1979|
| Canada        |       30651.633|  1978|
| Canada        |       29783.268|  1977|
| Canada        |       29128.014|  1976|
| Canada        |       28057.048|  1975|
| Canada        |       28080.941|  1974|
| Canada        |       27571.293|  1973|
| Canada        |       26216.591|  1972|
| Canada        |       25262.441|  1971|
| Canada        |       24629.216|  1970|
| Canada        |       24188.426|  1969|
| Canada        |       23294.302|  1968|
| Canada        |       22482.650|  1967|
| Canada        |       22242.419|  1966|
| Canada        |       21260.632|  1965|
| Canada        |       20301.660|  1964|
| Canada        |       19389.156|  1963|
| Canada        |       18780.564|  1962|
| Canada        |       17861.936|  1961|
| Canada        |       17664.205|  1960|
| Chile         |       15019.633|  2016|
| Chile         |       14907.116|  2015|
| Chile         |       14701.954|  2014|
| Chile         |       14551.044|  2013|
| Chile         |       14109.143|  2012|
| Chile         |       13518.765|  2011|
| Chile         |       12860.178|  2010|
| Chile         |       12268.441|  2009|
| Chile         |       12588.691|  2008|
| Chile         |       12285.048|  2007|
| Chile         |       11833.952|  2006|
| Chile         |       11249.868|  2005|
| Chile         |       10754.307|  2004|
| Chile         |       10141.732|  2003|
| Chile         |        9852.834|  2002|
| Chile         |        9666.476|  2001|
| Chile         |        9469.110|  2000|
| Chile         |        9100.999|  1999|
| Chile         |        9254.795|  1998|
| Chile         |        8987.620|  1997|
| Chile         |        8479.875|  1996|
| Chile         |        8051.487|  1995|
| Chile         |        7498.852|  1994|
| Chile         |        7247.054|  1993|
| Chile         |        6904.330|  1992|
| Chile         |        6309.458|  1991|
| Chile         |        5947.765|  1990|
| Chile         |        5851.483|  1989|
| Chile         |        5413.325|  1988|
| Chile         |        5128.959|  1987|
| Chile         |        4899.422|  1986|
| Chile         |        4726.906|  1985|
| Chile         |        4618.748|  1984|
| Chile         |        4507.428|  1983|
| Chile         |        4819.762|  1982|
| Chile         |        5499.996|  1981|
| Chile         |        5242.330|  1980|
| Chile         |        4928.701|  1979|
| Chile         |        4615.077|  1978|
| Chile         |        4350.497|  1977|
| Chile         |        4000.223|  1976|
| Chile         |        3913.965|  1975|
| Chile         |        4568.019|  1974|
| Chile         |        4537.196|  1973|
| Chile         |        4861.117|  1972|
| Chile         |        5000.596|  1971|
| Chile         |        4656.624|  1970|
| Chile         |        4663.498|  1969|
| Chile         |        4579.301|  1968|
| Chile         |        4514.601|  1967|
| Chile         |        4451.645|  1966|
| Chile         |        4089.777|  1965|
| Chile         |        4140.772|  1964|
| Chile         |        4127.319|  1963|
| Chile         |        3986.723|  1962|
| Chile         |        3918.367|  1961|
| Chile         |        3806.806|  1960|
| Hungary       |       14840.387|  2016|
| Hungary       |       14518.837|  2015|
| Hungary       |       14042.281|  2014|
| Hungary       |       13459.746|  2013|
| Hungary       |       13144.446|  2012|
| Hungary       |       13289.707|  2011|
| Hungary       |       13025.534|  2010|
| Hungary       |       12908.723|  2009|
| Hungary       |       13794.138|  2008|
| Hungary       |       13648.642|  2007|
| Hungary       |       13566.688|  2006|
| Hungary       |       13042.687|  2005|
| Hungary       |       12470.217|  2004|
| Hungary       |       11849.519|  2003|
| Hungary       |       11380.028|  2002|
| Hungary       |       10858.695|  2001|
| Hungary       |       10439.807|  2000|
| Hungary       |        9992.793|  1999|
| Hungary       |        9655.087|  1998|
| Hungary       |        9242.704|  1997|
| Hungary       |        8928.924|  1996|
| Hungary       |        8913.102|  1995|
| Hungary       |        8770.070|  1994|
| Hungary       |        8507.349|  1993|
| Hungary       |        8546.892|  1992|
| Hungary       |        8813.613|  1991|
| Hungary       |              NA|  1990|
| Hungary       |              NA|  1989|
| Hungary       |              NA|  1988|
| Hungary       |              NA|  1987|
| Hungary       |              NA|  1986|
| Hungary       |              NA|  1985|
| Hungary       |              NA|  1984|
| Hungary       |              NA|  1983|
| Hungary       |              NA|  1982|
| Hungary       |              NA|  1981|
| Hungary       |              NA|  1980|
| Hungary       |              NA|  1979|
| Hungary       |              NA|  1978|
| Hungary       |              NA|  1977|
| Hungary       |              NA|  1976|
| Hungary       |              NA|  1975|
| Hungary       |              NA|  1974|
| Hungary       |              NA|  1973|
| Hungary       |              NA|  1972|
| Hungary       |              NA|  1971|
| Hungary       |              NA|  1970|
| Hungary       |              NA|  1969|
| Hungary       |              NA|  1968|
| Hungary       |              NA|  1967|
| Hungary       |              NA|  1966|
| Hungary       |              NA|  1965|
| Hungary       |              NA|  1964|
| Hungary       |              NA|  1963|
| Hungary       |              NA|  1962|
| Hungary       |              NA|  1961|
| Hungary       |              NA|  1960|
| Mexico        |        9707.136|  2016|
| Mexico        |        9612.965|  2015|
| Mexico        |        9492.551|  2014|
| Mexico        |        9409.965|  2013|
| Mexico        |        9414.906|  2012|
| Mexico        |        9183.328|  2011|
| Mexico        |        8959.581|  2010|
| Mexico        |        8657.836|  2009|
| Mexico        |        9232.197|  2008|
| Mexico        |        9253.318|  2007|
| Mexico        |        9108.065|  2006|
| Mexico        |        8808.564|  2005|
| Mexico        |        8667.289|  2004|
| Mexico        |        8416.904|  2003|
| Mexico        |        8401.016|  2002|
| Mexico        |        8494.839|  2001|
| Mexico        |        8659.797|  2000|
| Mexico        |        8340.564|  1999|
| Mexico        |        8245.494|  1998|
| Mexico        |        7999.858|  1997|
| Mexico        |        7603.709|  1996|
| Mexico        |        7307.177|  1995|
| Mexico        |        7896.121|  1994|
| Mexico        |        7685.217|  1993|
| Mexico        |        7532.608|  1992|
| Mexico        |        7415.506|  1991|
| Mexico        |        7257.931|  1990|
| Mexico        |        7044.825|  1989|
| Mexico        |        6893.916|  1988|
| Mexico        |        6942.826|  1987|
| Mexico        |        6951.816|  1986|
| Mexico        |        7369.866|  1985|
| Mexico        |        7333.353|  1984|
| Mexico        |        7228.939|  1983|
| Mexico        |        7711.239|  1982|
| Mexico        |        7935.986|  1981|
| Mexico        |        7467.538|  1980|
| Mexico        |        7003.035|  1979|
| Mexico        |        6545.368|  1978|
| Mexico        |        6165.411|  1977|
| Mexico        |        6127.206|  1976|
| Mexico        |        6036.819|  1975|
| Mexico        |        5881.256|  1974|
| Mexico        |        5735.520|  1973|
| Mexico        |        5490.266|  1972|
| Mexico        |        5238.981|  1971|
| Mexico        |        5212.902|  1970|
| Mexico        |        5050.561|  1969|
| Mexico        |        5036.374|  1968|
| Mexico        |        4744.742|  1967|
| Mexico        |        4620.520|  1966|
| Mexico        |        4490.494|  1965|
| Mexico        |        4324.486|  1964|
| Mexico        |        3986.441|  1963|
| Mexico        |        3804.548|  1962|
| Mexico        |        3750.841|  1961|
| Mexico        |        3686.395|  1960|
| Uruguay       |       14009.998|  2016|
| Uruguay       |       13859.407|  2015|
| Uruguay       |       13856.695|  2014|
| Uruguay       |       13467.438|  2013|
| Uruguay       |       12913.104|  2012|
| Uruguay       |       12512.913|  2011|
| Uruguay       |       11938.212|  2010|
| Uruguay       |       11112.456|  2009|
| Uruguay       |       10698.052|  2008|
| Uruguay       |       10014.872|  2007|
| Uruguay       |        9424.517|  2006|
| Uruguay       |        9068.239|  2005|
| Uruguay       |        8442.550|  2004|
| Uruguay       |        8036.479|  2003|
| Uruguay       |        7967.163|  2002|
| Uruguay       |        8636.545|  2001|
| Uruguay       |        8997.660|  2000|
| Uruguay       |        9207.792|  1999|
| Uruguay       |        9438.883|  1998|
| Uruguay       |        9089.123|  1997|
| Uruguay       |        8432.621|  1996|
| Uruguay       |        8044.642|  1995|
| Uruguay       |        8221.949|  1994|
| Uruguay       |        7720.467|  1993|
| Uruguay       |        7576.146|  1992|
| Uruguay       |        7070.506|  1991|
| Uruguay       |        6877.287|  1990|
| Uruguay       |        6903.525|  1989|
| Uruguay       |        6872.389|  1988|
| Uruguay       |        6814.581|  1987|
| Uruguay       |        6349.604|  1986|
| Uruguay       |        5872.571|  1985|
| Uruguay       |        5824.946|  1984|
| Uruguay       |        5930.284|  1983|
| Uruguay       |        6652.268|  1982|
| Uruguay       |        7419.914|  1981|
| Uruguay       |        7354.228|  1980|
| Uruguay       |        6995.612|  1979|
| Uruguay       |        6633.200|  1978|
| Uruguay       |        6336.468|  1977|
| Uruguay       |        6280.022|  1976|
| Uruguay       |        6066.265|  1975|
| Uruguay       |        5730.020|  1974|
| Uruguay       |        5572.708|  1973|
| Uruguay       |        5558.678|  1972|
| Uruguay       |        5639.344|  1971|
| Uruguay       |        5670.611|  1970|
| Uruguay       |        5570.576|  1969|
| Uruguay       |        5300.418|  1968|
| Uruguay       |        5248.841|  1967|
| Uruguay       |        5502.523|  1966|
| Uruguay       |        5395.151|  1965|
| Uruguay       |        5397.710|  1964|
| Uruguay       |        5329.625|  1963|
| Uruguay       |        5384.393|  1962|
| Uruguay       |        5539.019|  1961|
| Uruguay       |        5474.622|  1960|
| United States |       52194.886|  2016|
| United States |       51722.097|  2015|
| United States |       50782.521|  2014|
| United States |       49976.629|  2013|
| United States |       49497.586|  2012|
| United States |       48783.469|  2011|
| United States |       48373.879|  2010|
| United States |       47575.609|  2009|
| United States |       49364.645|  2008|
| United States |       49979.534|  2007|
| United States |       49575.401|  2006|
| United States |       48755.616|  2005|
| United States |       47614.280|  2004|
| United States |       46304.036|  2003|
| United States |       45428.646|  2002|
| United States |       45047.487|  2001|
| United States |       45055.818|  2000|
| United States |       43768.885|  1999|
| United States |       42292.891|  1998|
| United States |       40965.847|  1997|
| United States |       39681.520|  1996|
| United States |       38677.715|  1995|
| United States |       38104.972|  1994|
| United States |       37078.050|  1993|
| United States |       36566.174|  1992|
| United States |       35803.868|  1991|
| United States |       36312.414|  1990|
| United States |       36033.330|  1989|
| United States |       35083.969|  1988|
| United States |       33975.655|  1987|
| United States |       33133.695|  1986|
| United States |       32306.833|  1985|
| United States |       31268.976|  1984|
| United States |       29406.257|  1983|
| United States |       28362.495|  1982|
| United States |       29191.999|  1981|
| United States |       28734.399|  1980|
| United States |       29082.594|  1979|
| United States |       28500.240|  1978|
| United States |       27286.252|  1977|
| United States |       26347.809|  1976|
| United States |       25239.920|  1975|
| United States |       25540.501|  1974|
| United States |       25908.913|  1973|
| United States |       24760.145|  1972|
| United States |       23775.277|  1971|
| United States |       23309.621|  1970|
| United States |       22850.011|  1969|
| United States |       22380.607|  1968|
| United States |       21569.836|  1967|
| United States |       21274.135|  1966|
| United States |       20207.750|  1965|
| United States |       19231.172|  1964|
| United States |       18431.158|  1963|
| United States |       17910.279|  1962|
| United States |       17142.194|  1961|
| United States |       17036.885|  1960|

``` r
#or
#View(td.wdi)

td.gapminder <- gapminder %>% 
  select (-c(pop, gdpPercap)) %>% 
  group_by(continent) %>% 
  mutate(meanLifeExp=mean(lifeExp)) %>% 
  gather(measure, value, lifeExp)
knitr::kable(td.gapminder)
```

| country                  | continent |  year|  meanLifeExp| measure |     value|
|:-------------------------|:----------|-----:|------------:|:--------|---------:|
| Afghanistan              | Asia      |  1952|     60.06490| lifeExp |  28.80100|
| Afghanistan              | Asia      |  1957|     60.06490| lifeExp |  30.33200|
| Afghanistan              | Asia      |  1962|     60.06490| lifeExp |  31.99700|
| Afghanistan              | Asia      |  1967|     60.06490| lifeExp |  34.02000|
| Afghanistan              | Asia      |  1972|     60.06490| lifeExp |  36.08800|
| Afghanistan              | Asia      |  1977|     60.06490| lifeExp |  38.43800|
| Afghanistan              | Asia      |  1982|     60.06490| lifeExp |  39.85400|
| Afghanistan              | Asia      |  1987|     60.06490| lifeExp |  40.82200|
| Afghanistan              | Asia      |  1992|     60.06490| lifeExp |  41.67400|
| Afghanistan              | Asia      |  1997|     60.06490| lifeExp |  41.76300|
| Afghanistan              | Asia      |  2002|     60.06490| lifeExp |  42.12900|
| Afghanistan              | Asia      |  2007|     60.06490| lifeExp |  43.82800|
| Albania                  | Europe    |  1952|     71.90369| lifeExp |  55.23000|
| Albania                  | Europe    |  1957|     71.90369| lifeExp |  59.28000|
| Albania                  | Europe    |  1962|     71.90369| lifeExp |  64.82000|
| Albania                  | Europe    |  1967|     71.90369| lifeExp |  66.22000|
| Albania                  | Europe    |  1972|     71.90369| lifeExp |  67.69000|
| Albania                  | Europe    |  1977|     71.90369| lifeExp |  68.93000|
| Albania                  | Europe    |  1982|     71.90369| lifeExp |  70.42000|
| Albania                  | Europe    |  1987|     71.90369| lifeExp |  72.00000|
| Albania                  | Europe    |  1992|     71.90369| lifeExp |  71.58100|
| Albania                  | Europe    |  1997|     71.90369| lifeExp |  72.95000|
| Albania                  | Europe    |  2002|     71.90369| lifeExp |  75.65100|
| Albania                  | Europe    |  2007|     71.90369| lifeExp |  76.42300|
| Algeria                  | Africa    |  1952|     48.86533| lifeExp |  43.07700|
| Algeria                  | Africa    |  1957|     48.86533| lifeExp |  45.68500|
| Algeria                  | Africa    |  1962|     48.86533| lifeExp |  48.30300|
| Algeria                  | Africa    |  1967|     48.86533| lifeExp |  51.40700|
| Algeria                  | Africa    |  1972|     48.86533| lifeExp |  54.51800|
| Algeria                  | Africa    |  1977|     48.86533| lifeExp |  58.01400|
| Algeria                  | Africa    |  1982|     48.86533| lifeExp |  61.36800|
| Algeria                  | Africa    |  1987|     48.86533| lifeExp |  65.79900|
| Algeria                  | Africa    |  1992|     48.86533| lifeExp |  67.74400|
| Algeria                  | Africa    |  1997|     48.86533| lifeExp |  69.15200|
| Algeria                  | Africa    |  2002|     48.86533| lifeExp |  70.99400|
| Algeria                  | Africa    |  2007|     48.86533| lifeExp |  72.30100|
| Angola                   | Africa    |  1952|     48.86533| lifeExp |  30.01500|
| Angola                   | Africa    |  1957|     48.86533| lifeExp |  31.99900|
| Angola                   | Africa    |  1962|     48.86533| lifeExp |  34.00000|
| Angola                   | Africa    |  1967|     48.86533| lifeExp |  35.98500|
| Angola                   | Africa    |  1972|     48.86533| lifeExp |  37.92800|
| Angola                   | Africa    |  1977|     48.86533| lifeExp |  39.48300|
| Angola                   | Africa    |  1982|     48.86533| lifeExp |  39.94200|
| Angola                   | Africa    |  1987|     48.86533| lifeExp |  39.90600|
| Angola                   | Africa    |  1992|     48.86533| lifeExp |  40.64700|
| Angola                   | Africa    |  1997|     48.86533| lifeExp |  40.96300|
| Angola                   | Africa    |  2002|     48.86533| lifeExp |  41.00300|
| Angola                   | Africa    |  2007|     48.86533| lifeExp |  42.73100|
| Argentina                | Americas  |  1952|     64.65874| lifeExp |  62.48500|
| Argentina                | Americas  |  1957|     64.65874| lifeExp |  64.39900|
| Argentina                | Americas  |  1962|     64.65874| lifeExp |  65.14200|
| Argentina                | Americas  |  1967|     64.65874| lifeExp |  65.63400|
| Argentina                | Americas  |  1972|     64.65874| lifeExp |  67.06500|
| Argentina                | Americas  |  1977|     64.65874| lifeExp |  68.48100|
| Argentina                | Americas  |  1982|     64.65874| lifeExp |  69.94200|
| Argentina                | Americas  |  1987|     64.65874| lifeExp |  70.77400|
| Argentina                | Americas  |  1992|     64.65874| lifeExp |  71.86800|
| Argentina                | Americas  |  1997|     64.65874| lifeExp |  73.27500|
| Argentina                | Americas  |  2002|     64.65874| lifeExp |  74.34000|
| Argentina                | Americas  |  2007|     64.65874| lifeExp |  75.32000|
| Australia                | Oceania   |  1952|     74.32621| lifeExp |  69.12000|
| Australia                | Oceania   |  1957|     74.32621| lifeExp |  70.33000|
| Australia                | Oceania   |  1962|     74.32621| lifeExp |  70.93000|
| Australia                | Oceania   |  1967|     74.32621| lifeExp |  71.10000|
| Australia                | Oceania   |  1972|     74.32621| lifeExp |  71.93000|
| Australia                | Oceania   |  1977|     74.32621| lifeExp |  73.49000|
| Australia                | Oceania   |  1982|     74.32621| lifeExp |  74.74000|
| Australia                | Oceania   |  1987|     74.32621| lifeExp |  76.32000|
| Australia                | Oceania   |  1992|     74.32621| lifeExp |  77.56000|
| Australia                | Oceania   |  1997|     74.32621| lifeExp |  78.83000|
| Australia                | Oceania   |  2002|     74.32621| lifeExp |  80.37000|
| Australia                | Oceania   |  2007|     74.32621| lifeExp |  81.23500|
| Austria                  | Europe    |  1952|     71.90369| lifeExp |  66.80000|
| Austria                  | Europe    |  1957|     71.90369| lifeExp |  67.48000|
| Austria                  | Europe    |  1962|     71.90369| lifeExp |  69.54000|
| Austria                  | Europe    |  1967|     71.90369| lifeExp |  70.14000|
| Austria                  | Europe    |  1972|     71.90369| lifeExp |  70.63000|
| Austria                  | Europe    |  1977|     71.90369| lifeExp |  72.17000|
| Austria                  | Europe    |  1982|     71.90369| lifeExp |  73.18000|
| Austria                  | Europe    |  1987|     71.90369| lifeExp |  74.94000|
| Austria                  | Europe    |  1992|     71.90369| lifeExp |  76.04000|
| Austria                  | Europe    |  1997|     71.90369| lifeExp |  77.51000|
| Austria                  | Europe    |  2002|     71.90369| lifeExp |  78.98000|
| Austria                  | Europe    |  2007|     71.90369| lifeExp |  79.82900|
| Bahrain                  | Asia      |  1952|     60.06490| lifeExp |  50.93900|
| Bahrain                  | Asia      |  1957|     60.06490| lifeExp |  53.83200|
| Bahrain                  | Asia      |  1962|     60.06490| lifeExp |  56.92300|
| Bahrain                  | Asia      |  1967|     60.06490| lifeExp |  59.92300|
| Bahrain                  | Asia      |  1972|     60.06490| lifeExp |  63.30000|
| Bahrain                  | Asia      |  1977|     60.06490| lifeExp |  65.59300|
| Bahrain                  | Asia      |  1982|     60.06490| lifeExp |  69.05200|
| Bahrain                  | Asia      |  1987|     60.06490| lifeExp |  70.75000|
| Bahrain                  | Asia      |  1992|     60.06490| lifeExp |  72.60100|
| Bahrain                  | Asia      |  1997|     60.06490| lifeExp |  73.92500|
| Bahrain                  | Asia      |  2002|     60.06490| lifeExp |  74.79500|
| Bahrain                  | Asia      |  2007|     60.06490| lifeExp |  75.63500|
| Bangladesh               | Asia      |  1952|     60.06490| lifeExp |  37.48400|
| Bangladesh               | Asia      |  1957|     60.06490| lifeExp |  39.34800|
| Bangladesh               | Asia      |  1962|     60.06490| lifeExp |  41.21600|
| Bangladesh               | Asia      |  1967|     60.06490| lifeExp |  43.45300|
| Bangladesh               | Asia      |  1972|     60.06490| lifeExp |  45.25200|
| Bangladesh               | Asia      |  1977|     60.06490| lifeExp |  46.92300|
| Bangladesh               | Asia      |  1982|     60.06490| lifeExp |  50.00900|
| Bangladesh               | Asia      |  1987|     60.06490| lifeExp |  52.81900|
| Bangladesh               | Asia      |  1992|     60.06490| lifeExp |  56.01800|
| Bangladesh               | Asia      |  1997|     60.06490| lifeExp |  59.41200|
| Bangladesh               | Asia      |  2002|     60.06490| lifeExp |  62.01300|
| Bangladesh               | Asia      |  2007|     60.06490| lifeExp |  64.06200|
| Belgium                  | Europe    |  1952|     71.90369| lifeExp |  68.00000|
| Belgium                  | Europe    |  1957|     71.90369| lifeExp |  69.24000|
| Belgium                  | Europe    |  1962|     71.90369| lifeExp |  70.25000|
| Belgium                  | Europe    |  1967|     71.90369| lifeExp |  70.94000|
| Belgium                  | Europe    |  1972|     71.90369| lifeExp |  71.44000|
| Belgium                  | Europe    |  1977|     71.90369| lifeExp |  72.80000|
| Belgium                  | Europe    |  1982|     71.90369| lifeExp |  73.93000|
| Belgium                  | Europe    |  1987|     71.90369| lifeExp |  75.35000|
| Belgium                  | Europe    |  1992|     71.90369| lifeExp |  76.46000|
| Belgium                  | Europe    |  1997|     71.90369| lifeExp |  77.53000|
| Belgium                  | Europe    |  2002|     71.90369| lifeExp |  78.32000|
| Belgium                  | Europe    |  2007|     71.90369| lifeExp |  79.44100|
| Benin                    | Africa    |  1952|     48.86533| lifeExp |  38.22300|
| Benin                    | Africa    |  1957|     48.86533| lifeExp |  40.35800|
| Benin                    | Africa    |  1962|     48.86533| lifeExp |  42.61800|
| Benin                    | Africa    |  1967|     48.86533| lifeExp |  44.88500|
| Benin                    | Africa    |  1972|     48.86533| lifeExp |  47.01400|
| Benin                    | Africa    |  1977|     48.86533| lifeExp |  49.19000|
| Benin                    | Africa    |  1982|     48.86533| lifeExp |  50.90400|
| Benin                    | Africa    |  1987|     48.86533| lifeExp |  52.33700|
| Benin                    | Africa    |  1992|     48.86533| lifeExp |  53.91900|
| Benin                    | Africa    |  1997|     48.86533| lifeExp |  54.77700|
| Benin                    | Africa    |  2002|     48.86533| lifeExp |  54.40600|
| Benin                    | Africa    |  2007|     48.86533| lifeExp |  56.72800|
| Bolivia                  | Americas  |  1952|     64.65874| lifeExp |  40.41400|
| Bolivia                  | Americas  |  1957|     64.65874| lifeExp |  41.89000|
| Bolivia                  | Americas  |  1962|     64.65874| lifeExp |  43.42800|
| Bolivia                  | Americas  |  1967|     64.65874| lifeExp |  45.03200|
| Bolivia                  | Americas  |  1972|     64.65874| lifeExp |  46.71400|
| Bolivia                  | Americas  |  1977|     64.65874| lifeExp |  50.02300|
| Bolivia                  | Americas  |  1982|     64.65874| lifeExp |  53.85900|
| Bolivia                  | Americas  |  1987|     64.65874| lifeExp |  57.25100|
| Bolivia                  | Americas  |  1992|     64.65874| lifeExp |  59.95700|
| Bolivia                  | Americas  |  1997|     64.65874| lifeExp |  62.05000|
| Bolivia                  | Americas  |  2002|     64.65874| lifeExp |  63.88300|
| Bolivia                  | Americas  |  2007|     64.65874| lifeExp |  65.55400|
| Bosnia and Herzegovina   | Europe    |  1952|     71.90369| lifeExp |  53.82000|
| Bosnia and Herzegovina   | Europe    |  1957|     71.90369| lifeExp |  58.45000|
| Bosnia and Herzegovina   | Europe    |  1962|     71.90369| lifeExp |  61.93000|
| Bosnia and Herzegovina   | Europe    |  1967|     71.90369| lifeExp |  64.79000|
| Bosnia and Herzegovina   | Europe    |  1972|     71.90369| lifeExp |  67.45000|
| Bosnia and Herzegovina   | Europe    |  1977|     71.90369| lifeExp |  69.86000|
| Bosnia and Herzegovina   | Europe    |  1982|     71.90369| lifeExp |  70.69000|
| Bosnia and Herzegovina   | Europe    |  1987|     71.90369| lifeExp |  71.14000|
| Bosnia and Herzegovina   | Europe    |  1992|     71.90369| lifeExp |  72.17800|
| Bosnia and Herzegovina   | Europe    |  1997|     71.90369| lifeExp |  73.24400|
| Bosnia and Herzegovina   | Europe    |  2002|     71.90369| lifeExp |  74.09000|
| Bosnia and Herzegovina   | Europe    |  2007|     71.90369| lifeExp |  74.85200|
| Botswana                 | Africa    |  1952|     48.86533| lifeExp |  47.62200|
| Botswana                 | Africa    |  1957|     48.86533| lifeExp |  49.61800|
| Botswana                 | Africa    |  1962|     48.86533| lifeExp |  51.52000|
| Botswana                 | Africa    |  1967|     48.86533| lifeExp |  53.29800|
| Botswana                 | Africa    |  1972|     48.86533| lifeExp |  56.02400|
| Botswana                 | Africa    |  1977|     48.86533| lifeExp |  59.31900|
| Botswana                 | Africa    |  1982|     48.86533| lifeExp |  61.48400|
| Botswana                 | Africa    |  1987|     48.86533| lifeExp |  63.62200|
| Botswana                 | Africa    |  1992|     48.86533| lifeExp |  62.74500|
| Botswana                 | Africa    |  1997|     48.86533| lifeExp |  52.55600|
| Botswana                 | Africa    |  2002|     48.86533| lifeExp |  46.63400|
| Botswana                 | Africa    |  2007|     48.86533| lifeExp |  50.72800|
| Brazil                   | Americas  |  1952|     64.65874| lifeExp |  50.91700|
| Brazil                   | Americas  |  1957|     64.65874| lifeExp |  53.28500|
| Brazil                   | Americas  |  1962|     64.65874| lifeExp |  55.66500|
| Brazil                   | Americas  |  1967|     64.65874| lifeExp |  57.63200|
| Brazil                   | Americas  |  1972|     64.65874| lifeExp |  59.50400|
| Brazil                   | Americas  |  1977|     64.65874| lifeExp |  61.48900|
| Brazil                   | Americas  |  1982|     64.65874| lifeExp |  63.33600|
| Brazil                   | Americas  |  1987|     64.65874| lifeExp |  65.20500|
| Brazil                   | Americas  |  1992|     64.65874| lifeExp |  67.05700|
| Brazil                   | Americas  |  1997|     64.65874| lifeExp |  69.38800|
| Brazil                   | Americas  |  2002|     64.65874| lifeExp |  71.00600|
| Brazil                   | Americas  |  2007|     64.65874| lifeExp |  72.39000|
| Bulgaria                 | Europe    |  1952|     71.90369| lifeExp |  59.60000|
| Bulgaria                 | Europe    |  1957|     71.90369| lifeExp |  66.61000|
| Bulgaria                 | Europe    |  1962|     71.90369| lifeExp |  69.51000|
| Bulgaria                 | Europe    |  1967|     71.90369| lifeExp |  70.42000|
| Bulgaria                 | Europe    |  1972|     71.90369| lifeExp |  70.90000|
| Bulgaria                 | Europe    |  1977|     71.90369| lifeExp |  70.81000|
| Bulgaria                 | Europe    |  1982|     71.90369| lifeExp |  71.08000|
| Bulgaria                 | Europe    |  1987|     71.90369| lifeExp |  71.34000|
| Bulgaria                 | Europe    |  1992|     71.90369| lifeExp |  71.19000|
| Bulgaria                 | Europe    |  1997|     71.90369| lifeExp |  70.32000|
| Bulgaria                 | Europe    |  2002|     71.90369| lifeExp |  72.14000|
| Bulgaria                 | Europe    |  2007|     71.90369| lifeExp |  73.00500|
| Burkina Faso             | Africa    |  1952|     48.86533| lifeExp |  31.97500|
| Burkina Faso             | Africa    |  1957|     48.86533| lifeExp |  34.90600|
| Burkina Faso             | Africa    |  1962|     48.86533| lifeExp |  37.81400|
| Burkina Faso             | Africa    |  1967|     48.86533| lifeExp |  40.69700|
| Burkina Faso             | Africa    |  1972|     48.86533| lifeExp |  43.59100|
| Burkina Faso             | Africa    |  1977|     48.86533| lifeExp |  46.13700|
| Burkina Faso             | Africa    |  1982|     48.86533| lifeExp |  48.12200|
| Burkina Faso             | Africa    |  1987|     48.86533| lifeExp |  49.55700|
| Burkina Faso             | Africa    |  1992|     48.86533| lifeExp |  50.26000|
| Burkina Faso             | Africa    |  1997|     48.86533| lifeExp |  50.32400|
| Burkina Faso             | Africa    |  2002|     48.86533| lifeExp |  50.65000|
| Burkina Faso             | Africa    |  2007|     48.86533| lifeExp |  52.29500|
| Burundi                  | Africa    |  1952|     48.86533| lifeExp |  39.03100|
| Burundi                  | Africa    |  1957|     48.86533| lifeExp |  40.53300|
| Burundi                  | Africa    |  1962|     48.86533| lifeExp |  42.04500|
| Burundi                  | Africa    |  1967|     48.86533| lifeExp |  43.54800|
| Burundi                  | Africa    |  1972|     48.86533| lifeExp |  44.05700|
| Burundi                  | Africa    |  1977|     48.86533| lifeExp |  45.91000|
| Burundi                  | Africa    |  1982|     48.86533| lifeExp |  47.47100|
| Burundi                  | Africa    |  1987|     48.86533| lifeExp |  48.21100|
| Burundi                  | Africa    |  1992|     48.86533| lifeExp |  44.73600|
| Burundi                  | Africa    |  1997|     48.86533| lifeExp |  45.32600|
| Burundi                  | Africa    |  2002|     48.86533| lifeExp |  47.36000|
| Burundi                  | Africa    |  2007|     48.86533| lifeExp |  49.58000|
| Cambodia                 | Asia      |  1952|     60.06490| lifeExp |  39.41700|
| Cambodia                 | Asia      |  1957|     60.06490| lifeExp |  41.36600|
| Cambodia                 | Asia      |  1962|     60.06490| lifeExp |  43.41500|
| Cambodia                 | Asia      |  1967|     60.06490| lifeExp |  45.41500|
| Cambodia                 | Asia      |  1972|     60.06490| lifeExp |  40.31700|
| Cambodia                 | Asia      |  1977|     60.06490| lifeExp |  31.22000|
| Cambodia                 | Asia      |  1982|     60.06490| lifeExp |  50.95700|
| Cambodia                 | Asia      |  1987|     60.06490| lifeExp |  53.91400|
| Cambodia                 | Asia      |  1992|     60.06490| lifeExp |  55.80300|
| Cambodia                 | Asia      |  1997|     60.06490| lifeExp |  56.53400|
| Cambodia                 | Asia      |  2002|     60.06490| lifeExp |  56.75200|
| Cambodia                 | Asia      |  2007|     60.06490| lifeExp |  59.72300|
| Cameroon                 | Africa    |  1952|     48.86533| lifeExp |  38.52300|
| Cameroon                 | Africa    |  1957|     48.86533| lifeExp |  40.42800|
| Cameroon                 | Africa    |  1962|     48.86533| lifeExp |  42.64300|
| Cameroon                 | Africa    |  1967|     48.86533| lifeExp |  44.79900|
| Cameroon                 | Africa    |  1972|     48.86533| lifeExp |  47.04900|
| Cameroon                 | Africa    |  1977|     48.86533| lifeExp |  49.35500|
| Cameroon                 | Africa    |  1982|     48.86533| lifeExp |  52.96100|
| Cameroon                 | Africa    |  1987|     48.86533| lifeExp |  54.98500|
| Cameroon                 | Africa    |  1992|     48.86533| lifeExp |  54.31400|
| Cameroon                 | Africa    |  1997|     48.86533| lifeExp |  52.19900|
| Cameroon                 | Africa    |  2002|     48.86533| lifeExp |  49.85600|
| Cameroon                 | Africa    |  2007|     48.86533| lifeExp |  50.43000|
| Canada                   | Americas  |  1952|     64.65874| lifeExp |  68.75000|
| Canada                   | Americas  |  1957|     64.65874| lifeExp |  69.96000|
| Canada                   | Americas  |  1962|     64.65874| lifeExp |  71.30000|
| Canada                   | Americas  |  1967|     64.65874| lifeExp |  72.13000|
| Canada                   | Americas  |  1972|     64.65874| lifeExp |  72.88000|
| Canada                   | Americas  |  1977|     64.65874| lifeExp |  74.21000|
| Canada                   | Americas  |  1982|     64.65874| lifeExp |  75.76000|
| Canada                   | Americas  |  1987|     64.65874| lifeExp |  76.86000|
| Canada                   | Americas  |  1992|     64.65874| lifeExp |  77.95000|
| Canada                   | Americas  |  1997|     64.65874| lifeExp |  78.61000|
| Canada                   | Americas  |  2002|     64.65874| lifeExp |  79.77000|
| Canada                   | Americas  |  2007|     64.65874| lifeExp |  80.65300|
| Central African Republic | Africa    |  1952|     48.86533| lifeExp |  35.46300|
| Central African Republic | Africa    |  1957|     48.86533| lifeExp |  37.46400|
| Central African Republic | Africa    |  1962|     48.86533| lifeExp |  39.47500|
| Central African Republic | Africa    |  1967|     48.86533| lifeExp |  41.47800|
| Central African Republic | Africa    |  1972|     48.86533| lifeExp |  43.45700|
| Central African Republic | Africa    |  1977|     48.86533| lifeExp |  46.77500|
| Central African Republic | Africa    |  1982|     48.86533| lifeExp |  48.29500|
| Central African Republic | Africa    |  1987|     48.86533| lifeExp |  50.48500|
| Central African Republic | Africa    |  1992|     48.86533| lifeExp |  49.39600|
| Central African Republic | Africa    |  1997|     48.86533| lifeExp |  46.06600|
| Central African Republic | Africa    |  2002|     48.86533| lifeExp |  43.30800|
| Central African Republic | Africa    |  2007|     48.86533| lifeExp |  44.74100|
| Chad                     | Africa    |  1952|     48.86533| lifeExp |  38.09200|
| Chad                     | Africa    |  1957|     48.86533| lifeExp |  39.88100|
| Chad                     | Africa    |  1962|     48.86533| lifeExp |  41.71600|
| Chad                     | Africa    |  1967|     48.86533| lifeExp |  43.60100|
| Chad                     | Africa    |  1972|     48.86533| lifeExp |  45.56900|
| Chad                     | Africa    |  1977|     48.86533| lifeExp |  47.38300|
| Chad                     | Africa    |  1982|     48.86533| lifeExp |  49.51700|
| Chad                     | Africa    |  1987|     48.86533| lifeExp |  51.05100|
| Chad                     | Africa    |  1992|     48.86533| lifeExp |  51.72400|
| Chad                     | Africa    |  1997|     48.86533| lifeExp |  51.57300|
| Chad                     | Africa    |  2002|     48.86533| lifeExp |  50.52500|
| Chad                     | Africa    |  2007|     48.86533| lifeExp |  50.65100|
| Chile                    | Americas  |  1952|     64.65874| lifeExp |  54.74500|
| Chile                    | Americas  |  1957|     64.65874| lifeExp |  56.07400|
| Chile                    | Americas  |  1962|     64.65874| lifeExp |  57.92400|
| Chile                    | Americas  |  1967|     64.65874| lifeExp |  60.52300|
| Chile                    | Americas  |  1972|     64.65874| lifeExp |  63.44100|
| Chile                    | Americas  |  1977|     64.65874| lifeExp |  67.05200|
| Chile                    | Americas  |  1982|     64.65874| lifeExp |  70.56500|
| Chile                    | Americas  |  1987|     64.65874| lifeExp |  72.49200|
| Chile                    | Americas  |  1992|     64.65874| lifeExp |  74.12600|
| Chile                    | Americas  |  1997|     64.65874| lifeExp |  75.81600|
| Chile                    | Americas  |  2002|     64.65874| lifeExp |  77.86000|
| Chile                    | Americas  |  2007|     64.65874| lifeExp |  78.55300|
| China                    | Asia      |  1952|     60.06490| lifeExp |  44.00000|
| China                    | Asia      |  1957|     60.06490| lifeExp |  50.54896|
| China                    | Asia      |  1962|     60.06490| lifeExp |  44.50136|
| China                    | Asia      |  1967|     60.06490| lifeExp |  58.38112|
| China                    | Asia      |  1972|     60.06490| lifeExp |  63.11888|
| China                    | Asia      |  1977|     60.06490| lifeExp |  63.96736|
| China                    | Asia      |  1982|     60.06490| lifeExp |  65.52500|
| China                    | Asia      |  1987|     60.06490| lifeExp |  67.27400|
| China                    | Asia      |  1992|     60.06490| lifeExp |  68.69000|
| China                    | Asia      |  1997|     60.06490| lifeExp |  70.42600|
| China                    | Asia      |  2002|     60.06490| lifeExp |  72.02800|
| China                    | Asia      |  2007|     60.06490| lifeExp |  72.96100|
| Colombia                 | Americas  |  1952|     64.65874| lifeExp |  50.64300|
| Colombia                 | Americas  |  1957|     64.65874| lifeExp |  55.11800|
| Colombia                 | Americas  |  1962|     64.65874| lifeExp |  57.86300|
| Colombia                 | Americas  |  1967|     64.65874| lifeExp |  59.96300|
| Colombia                 | Americas  |  1972|     64.65874| lifeExp |  61.62300|
| Colombia                 | Americas  |  1977|     64.65874| lifeExp |  63.83700|
| Colombia                 | Americas  |  1982|     64.65874| lifeExp |  66.65300|
| Colombia                 | Americas  |  1987|     64.65874| lifeExp |  67.76800|
| Colombia                 | Americas  |  1992|     64.65874| lifeExp |  68.42100|
| Colombia                 | Americas  |  1997|     64.65874| lifeExp |  70.31300|
| Colombia                 | Americas  |  2002|     64.65874| lifeExp |  71.68200|
| Colombia                 | Americas  |  2007|     64.65874| lifeExp |  72.88900|
| Comoros                  | Africa    |  1952|     48.86533| lifeExp |  40.71500|
| Comoros                  | Africa    |  1957|     48.86533| lifeExp |  42.46000|
| Comoros                  | Africa    |  1962|     48.86533| lifeExp |  44.46700|
| Comoros                  | Africa    |  1967|     48.86533| lifeExp |  46.47200|
| Comoros                  | Africa    |  1972|     48.86533| lifeExp |  48.94400|
| Comoros                  | Africa    |  1977|     48.86533| lifeExp |  50.93900|
| Comoros                  | Africa    |  1982|     48.86533| lifeExp |  52.93300|
| Comoros                  | Africa    |  1987|     48.86533| lifeExp |  54.92600|
| Comoros                  | Africa    |  1992|     48.86533| lifeExp |  57.93900|
| Comoros                  | Africa    |  1997|     48.86533| lifeExp |  60.66000|
| Comoros                  | Africa    |  2002|     48.86533| lifeExp |  62.97400|
| Comoros                  | Africa    |  2007|     48.86533| lifeExp |  65.15200|
| Congo, Dem. Rep.         | Africa    |  1952|     48.86533| lifeExp |  39.14300|
| Congo, Dem. Rep.         | Africa    |  1957|     48.86533| lifeExp |  40.65200|
| Congo, Dem. Rep.         | Africa    |  1962|     48.86533| lifeExp |  42.12200|
| Congo, Dem. Rep.         | Africa    |  1967|     48.86533| lifeExp |  44.05600|
| Congo, Dem. Rep.         | Africa    |  1972|     48.86533| lifeExp |  45.98900|
| Congo, Dem. Rep.         | Africa    |  1977|     48.86533| lifeExp |  47.80400|
| Congo, Dem. Rep.         | Africa    |  1982|     48.86533| lifeExp |  47.78400|
| Congo, Dem. Rep.         | Africa    |  1987|     48.86533| lifeExp |  47.41200|
| Congo, Dem. Rep.         | Africa    |  1992|     48.86533| lifeExp |  45.54800|
| Congo, Dem. Rep.         | Africa    |  1997|     48.86533| lifeExp |  42.58700|
| Congo, Dem. Rep.         | Africa    |  2002|     48.86533| lifeExp |  44.96600|
| Congo, Dem. Rep.         | Africa    |  2007|     48.86533| lifeExp |  46.46200|
| Congo, Rep.              | Africa    |  1952|     48.86533| lifeExp |  42.11100|
| Congo, Rep.              | Africa    |  1957|     48.86533| lifeExp |  45.05300|
| Congo, Rep.              | Africa    |  1962|     48.86533| lifeExp |  48.43500|
| Congo, Rep.              | Africa    |  1967|     48.86533| lifeExp |  52.04000|
| Congo, Rep.              | Africa    |  1972|     48.86533| lifeExp |  54.90700|
| Congo, Rep.              | Africa    |  1977|     48.86533| lifeExp |  55.62500|
| Congo, Rep.              | Africa    |  1982|     48.86533| lifeExp |  56.69500|
| Congo, Rep.              | Africa    |  1987|     48.86533| lifeExp |  57.47000|
| Congo, Rep.              | Africa    |  1992|     48.86533| lifeExp |  56.43300|
| Congo, Rep.              | Africa    |  1997|     48.86533| lifeExp |  52.96200|
| Congo, Rep.              | Africa    |  2002|     48.86533| lifeExp |  52.97000|
| Congo, Rep.              | Africa    |  2007|     48.86533| lifeExp |  55.32200|
| Costa Rica               | Americas  |  1952|     64.65874| lifeExp |  57.20600|
| Costa Rica               | Americas  |  1957|     64.65874| lifeExp |  60.02600|
| Costa Rica               | Americas  |  1962|     64.65874| lifeExp |  62.84200|
| Costa Rica               | Americas  |  1967|     64.65874| lifeExp |  65.42400|
| Costa Rica               | Americas  |  1972|     64.65874| lifeExp |  67.84900|
| Costa Rica               | Americas  |  1977|     64.65874| lifeExp |  70.75000|
| Costa Rica               | Americas  |  1982|     64.65874| lifeExp |  73.45000|
| Costa Rica               | Americas  |  1987|     64.65874| lifeExp |  74.75200|
| Costa Rica               | Americas  |  1992|     64.65874| lifeExp |  75.71300|
| Costa Rica               | Americas  |  1997|     64.65874| lifeExp |  77.26000|
| Costa Rica               | Americas  |  2002|     64.65874| lifeExp |  78.12300|
| Costa Rica               | Americas  |  2007|     64.65874| lifeExp |  78.78200|
| Cote d'Ivoire            | Africa    |  1952|     48.86533| lifeExp |  40.47700|
| Cote d'Ivoire            | Africa    |  1957|     48.86533| lifeExp |  42.46900|
| Cote d'Ivoire            | Africa    |  1962|     48.86533| lifeExp |  44.93000|
| Cote d'Ivoire            | Africa    |  1967|     48.86533| lifeExp |  47.35000|
| Cote d'Ivoire            | Africa    |  1972|     48.86533| lifeExp |  49.80100|
| Cote d'Ivoire            | Africa    |  1977|     48.86533| lifeExp |  52.37400|
| Cote d'Ivoire            | Africa    |  1982|     48.86533| lifeExp |  53.98300|
| Cote d'Ivoire            | Africa    |  1987|     48.86533| lifeExp |  54.65500|
| Cote d'Ivoire            | Africa    |  1992|     48.86533| lifeExp |  52.04400|
| Cote d'Ivoire            | Africa    |  1997|     48.86533| lifeExp |  47.99100|
| Cote d'Ivoire            | Africa    |  2002|     48.86533| lifeExp |  46.83200|
| Cote d'Ivoire            | Africa    |  2007|     48.86533| lifeExp |  48.32800|
| Croatia                  | Europe    |  1952|     71.90369| lifeExp |  61.21000|
| Croatia                  | Europe    |  1957|     71.90369| lifeExp |  64.77000|
| Croatia                  | Europe    |  1962|     71.90369| lifeExp |  67.13000|
| Croatia                  | Europe    |  1967|     71.90369| lifeExp |  68.50000|
| Croatia                  | Europe    |  1972|     71.90369| lifeExp |  69.61000|
| Croatia                  | Europe    |  1977|     71.90369| lifeExp |  70.64000|
| Croatia                  | Europe    |  1982|     71.90369| lifeExp |  70.46000|
| Croatia                  | Europe    |  1987|     71.90369| lifeExp |  71.52000|
| Croatia                  | Europe    |  1992|     71.90369| lifeExp |  72.52700|
| Croatia                  | Europe    |  1997|     71.90369| lifeExp |  73.68000|
| Croatia                  | Europe    |  2002|     71.90369| lifeExp |  74.87600|
| Croatia                  | Europe    |  2007|     71.90369| lifeExp |  75.74800|
| Cuba                     | Americas  |  1952|     64.65874| lifeExp |  59.42100|
| Cuba                     | Americas  |  1957|     64.65874| lifeExp |  62.32500|
| Cuba                     | Americas  |  1962|     64.65874| lifeExp |  65.24600|
| Cuba                     | Americas  |  1967|     64.65874| lifeExp |  68.29000|
| Cuba                     | Americas  |  1972|     64.65874| lifeExp |  70.72300|
| Cuba                     | Americas  |  1977|     64.65874| lifeExp |  72.64900|
| Cuba                     | Americas  |  1982|     64.65874| lifeExp |  73.71700|
| Cuba                     | Americas  |  1987|     64.65874| lifeExp |  74.17400|
| Cuba                     | Americas  |  1992|     64.65874| lifeExp |  74.41400|
| Cuba                     | Americas  |  1997|     64.65874| lifeExp |  76.15100|
| Cuba                     | Americas  |  2002|     64.65874| lifeExp |  77.15800|
| Cuba                     | Americas  |  2007|     64.65874| lifeExp |  78.27300|
| Czech Republic           | Europe    |  1952|     71.90369| lifeExp |  66.87000|
| Czech Republic           | Europe    |  1957|     71.90369| lifeExp |  69.03000|
| Czech Republic           | Europe    |  1962|     71.90369| lifeExp |  69.90000|
| Czech Republic           | Europe    |  1967|     71.90369| lifeExp |  70.38000|
| Czech Republic           | Europe    |  1972|     71.90369| lifeExp |  70.29000|
| Czech Republic           | Europe    |  1977|     71.90369| lifeExp |  70.71000|
| Czech Republic           | Europe    |  1982|     71.90369| lifeExp |  70.96000|
| Czech Republic           | Europe    |  1987|     71.90369| lifeExp |  71.58000|
| Czech Republic           | Europe    |  1992|     71.90369| lifeExp |  72.40000|
| Czech Republic           | Europe    |  1997|     71.90369| lifeExp |  74.01000|
| Czech Republic           | Europe    |  2002|     71.90369| lifeExp |  75.51000|
| Czech Republic           | Europe    |  2007|     71.90369| lifeExp |  76.48600|
| Denmark                  | Europe    |  1952|     71.90369| lifeExp |  70.78000|
| Denmark                  | Europe    |  1957|     71.90369| lifeExp |  71.81000|
| Denmark                  | Europe    |  1962|     71.90369| lifeExp |  72.35000|
| Denmark                  | Europe    |  1967|     71.90369| lifeExp |  72.96000|
| Denmark                  | Europe    |  1972|     71.90369| lifeExp |  73.47000|
| Denmark                  | Europe    |  1977|     71.90369| lifeExp |  74.69000|
| Denmark                  | Europe    |  1982|     71.90369| lifeExp |  74.63000|
| Denmark                  | Europe    |  1987|     71.90369| lifeExp |  74.80000|
| Denmark                  | Europe    |  1992|     71.90369| lifeExp |  75.33000|
| Denmark                  | Europe    |  1997|     71.90369| lifeExp |  76.11000|
| Denmark                  | Europe    |  2002|     71.90369| lifeExp |  77.18000|
| Denmark                  | Europe    |  2007|     71.90369| lifeExp |  78.33200|
| Djibouti                 | Africa    |  1952|     48.86533| lifeExp |  34.81200|
| Djibouti                 | Africa    |  1957|     48.86533| lifeExp |  37.32800|
| Djibouti                 | Africa    |  1962|     48.86533| lifeExp |  39.69300|
| Djibouti                 | Africa    |  1967|     48.86533| lifeExp |  42.07400|
| Djibouti                 | Africa    |  1972|     48.86533| lifeExp |  44.36600|
| Djibouti                 | Africa    |  1977|     48.86533| lifeExp |  46.51900|
| Djibouti                 | Africa    |  1982|     48.86533| lifeExp |  48.81200|
| Djibouti                 | Africa    |  1987|     48.86533| lifeExp |  50.04000|
| Djibouti                 | Africa    |  1992|     48.86533| lifeExp |  51.60400|
| Djibouti                 | Africa    |  1997|     48.86533| lifeExp |  53.15700|
| Djibouti                 | Africa    |  2002|     48.86533| lifeExp |  53.37300|
| Djibouti                 | Africa    |  2007|     48.86533| lifeExp |  54.79100|
| Dominican Republic       | Americas  |  1952|     64.65874| lifeExp |  45.92800|
| Dominican Republic       | Americas  |  1957|     64.65874| lifeExp |  49.82800|
| Dominican Republic       | Americas  |  1962|     64.65874| lifeExp |  53.45900|
| Dominican Republic       | Americas  |  1967|     64.65874| lifeExp |  56.75100|
| Dominican Republic       | Americas  |  1972|     64.65874| lifeExp |  59.63100|
| Dominican Republic       | Americas  |  1977|     64.65874| lifeExp |  61.78800|
| Dominican Republic       | Americas  |  1982|     64.65874| lifeExp |  63.72700|
| Dominican Republic       | Americas  |  1987|     64.65874| lifeExp |  66.04600|
| Dominican Republic       | Americas  |  1992|     64.65874| lifeExp |  68.45700|
| Dominican Republic       | Americas  |  1997|     64.65874| lifeExp |  69.95700|
| Dominican Republic       | Americas  |  2002|     64.65874| lifeExp |  70.84700|
| Dominican Republic       | Americas  |  2007|     64.65874| lifeExp |  72.23500|
| Ecuador                  | Americas  |  1952|     64.65874| lifeExp |  48.35700|
| Ecuador                  | Americas  |  1957|     64.65874| lifeExp |  51.35600|
| Ecuador                  | Americas  |  1962|     64.65874| lifeExp |  54.64000|
| Ecuador                  | Americas  |  1967|     64.65874| lifeExp |  56.67800|
| Ecuador                  | Americas  |  1972|     64.65874| lifeExp |  58.79600|
| Ecuador                  | Americas  |  1977|     64.65874| lifeExp |  61.31000|
| Ecuador                  | Americas  |  1982|     64.65874| lifeExp |  64.34200|
| Ecuador                  | Americas  |  1987|     64.65874| lifeExp |  67.23100|
| Ecuador                  | Americas  |  1992|     64.65874| lifeExp |  69.61300|
| Ecuador                  | Americas  |  1997|     64.65874| lifeExp |  72.31200|
| Ecuador                  | Americas  |  2002|     64.65874| lifeExp |  74.17300|
| Ecuador                  | Americas  |  2007|     64.65874| lifeExp |  74.99400|
| Egypt                    | Africa    |  1952|     48.86533| lifeExp |  41.89300|
| Egypt                    | Africa    |  1957|     48.86533| lifeExp |  44.44400|
| Egypt                    | Africa    |  1962|     48.86533| lifeExp |  46.99200|
| Egypt                    | Africa    |  1967|     48.86533| lifeExp |  49.29300|
| Egypt                    | Africa    |  1972|     48.86533| lifeExp |  51.13700|
| Egypt                    | Africa    |  1977|     48.86533| lifeExp |  53.31900|
| Egypt                    | Africa    |  1982|     48.86533| lifeExp |  56.00600|
| Egypt                    | Africa    |  1987|     48.86533| lifeExp |  59.79700|
| Egypt                    | Africa    |  1992|     48.86533| lifeExp |  63.67400|
| Egypt                    | Africa    |  1997|     48.86533| lifeExp |  67.21700|
| Egypt                    | Africa    |  2002|     48.86533| lifeExp |  69.80600|
| Egypt                    | Africa    |  2007|     48.86533| lifeExp |  71.33800|
| El Salvador              | Americas  |  1952|     64.65874| lifeExp |  45.26200|
| El Salvador              | Americas  |  1957|     64.65874| lifeExp |  48.57000|
| El Salvador              | Americas  |  1962|     64.65874| lifeExp |  52.30700|
| El Salvador              | Americas  |  1967|     64.65874| lifeExp |  55.85500|
| El Salvador              | Americas  |  1972|     64.65874| lifeExp |  58.20700|
| El Salvador              | Americas  |  1977|     64.65874| lifeExp |  56.69600|
| El Salvador              | Americas  |  1982|     64.65874| lifeExp |  56.60400|
| El Salvador              | Americas  |  1987|     64.65874| lifeExp |  63.15400|
| El Salvador              | Americas  |  1992|     64.65874| lifeExp |  66.79800|
| El Salvador              | Americas  |  1997|     64.65874| lifeExp |  69.53500|
| El Salvador              | Americas  |  2002|     64.65874| lifeExp |  70.73400|
| El Salvador              | Americas  |  2007|     64.65874| lifeExp |  71.87800|
| Equatorial Guinea        | Africa    |  1952|     48.86533| lifeExp |  34.48200|
| Equatorial Guinea        | Africa    |  1957|     48.86533| lifeExp |  35.98300|
| Equatorial Guinea        | Africa    |  1962|     48.86533| lifeExp |  37.48500|
| Equatorial Guinea        | Africa    |  1967|     48.86533| lifeExp |  38.98700|
| Equatorial Guinea        | Africa    |  1972|     48.86533| lifeExp |  40.51600|
| Equatorial Guinea        | Africa    |  1977|     48.86533| lifeExp |  42.02400|
| Equatorial Guinea        | Africa    |  1982|     48.86533| lifeExp |  43.66200|
| Equatorial Guinea        | Africa    |  1987|     48.86533| lifeExp |  45.66400|
| Equatorial Guinea        | Africa    |  1992|     48.86533| lifeExp |  47.54500|
| Equatorial Guinea        | Africa    |  1997|     48.86533| lifeExp |  48.24500|
| Equatorial Guinea        | Africa    |  2002|     48.86533| lifeExp |  49.34800|
| Equatorial Guinea        | Africa    |  2007|     48.86533| lifeExp |  51.57900|
| Eritrea                  | Africa    |  1952|     48.86533| lifeExp |  35.92800|
| Eritrea                  | Africa    |  1957|     48.86533| lifeExp |  38.04700|
| Eritrea                  | Africa    |  1962|     48.86533| lifeExp |  40.15800|
| Eritrea                  | Africa    |  1967|     48.86533| lifeExp |  42.18900|
| Eritrea                  | Africa    |  1972|     48.86533| lifeExp |  44.14200|
| Eritrea                  | Africa    |  1977|     48.86533| lifeExp |  44.53500|
| Eritrea                  | Africa    |  1982|     48.86533| lifeExp |  43.89000|
| Eritrea                  | Africa    |  1987|     48.86533| lifeExp |  46.45300|
| Eritrea                  | Africa    |  1992|     48.86533| lifeExp |  49.99100|
| Eritrea                  | Africa    |  1997|     48.86533| lifeExp |  53.37800|
| Eritrea                  | Africa    |  2002|     48.86533| lifeExp |  55.24000|
| Eritrea                  | Africa    |  2007|     48.86533| lifeExp |  58.04000|
| Ethiopia                 | Africa    |  1952|     48.86533| lifeExp |  34.07800|
| Ethiopia                 | Africa    |  1957|     48.86533| lifeExp |  36.66700|
| Ethiopia                 | Africa    |  1962|     48.86533| lifeExp |  40.05900|
| Ethiopia                 | Africa    |  1967|     48.86533| lifeExp |  42.11500|
| Ethiopia                 | Africa    |  1972|     48.86533| lifeExp |  43.51500|
| Ethiopia                 | Africa    |  1977|     48.86533| lifeExp |  44.51000|
| Ethiopia                 | Africa    |  1982|     48.86533| lifeExp |  44.91600|
| Ethiopia                 | Africa    |  1987|     48.86533| lifeExp |  46.68400|
| Ethiopia                 | Africa    |  1992|     48.86533| lifeExp |  48.09100|
| Ethiopia                 | Africa    |  1997|     48.86533| lifeExp |  49.40200|
| Ethiopia                 | Africa    |  2002|     48.86533| lifeExp |  50.72500|
| Ethiopia                 | Africa    |  2007|     48.86533| lifeExp |  52.94700|
| Finland                  | Europe    |  1952|     71.90369| lifeExp |  66.55000|
| Finland                  | Europe    |  1957|     71.90369| lifeExp |  67.49000|
| Finland                  | Europe    |  1962|     71.90369| lifeExp |  68.75000|
| Finland                  | Europe    |  1967|     71.90369| lifeExp |  69.83000|
| Finland                  | Europe    |  1972|     71.90369| lifeExp |  70.87000|
| Finland                  | Europe    |  1977|     71.90369| lifeExp |  72.52000|
| Finland                  | Europe    |  1982|     71.90369| lifeExp |  74.55000|
| Finland                  | Europe    |  1987|     71.90369| lifeExp |  74.83000|
| Finland                  | Europe    |  1992|     71.90369| lifeExp |  75.70000|
| Finland                  | Europe    |  1997|     71.90369| lifeExp |  77.13000|
| Finland                  | Europe    |  2002|     71.90369| lifeExp |  78.37000|
| Finland                  | Europe    |  2007|     71.90369| lifeExp |  79.31300|
| France                   | Europe    |  1952|     71.90369| lifeExp |  67.41000|
| France                   | Europe    |  1957|     71.90369| lifeExp |  68.93000|
| France                   | Europe    |  1962|     71.90369| lifeExp |  70.51000|
| France                   | Europe    |  1967|     71.90369| lifeExp |  71.55000|
| France                   | Europe    |  1972|     71.90369| lifeExp |  72.38000|
| France                   | Europe    |  1977|     71.90369| lifeExp |  73.83000|
| France                   | Europe    |  1982|     71.90369| lifeExp |  74.89000|
| France                   | Europe    |  1987|     71.90369| lifeExp |  76.34000|
| France                   | Europe    |  1992|     71.90369| lifeExp |  77.46000|
| France                   | Europe    |  1997|     71.90369| lifeExp |  78.64000|
| France                   | Europe    |  2002|     71.90369| lifeExp |  79.59000|
| France                   | Europe    |  2007|     71.90369| lifeExp |  80.65700|
| Gabon                    | Africa    |  1952|     48.86533| lifeExp |  37.00300|
| Gabon                    | Africa    |  1957|     48.86533| lifeExp |  38.99900|
| Gabon                    | Africa    |  1962|     48.86533| lifeExp |  40.48900|
| Gabon                    | Africa    |  1967|     48.86533| lifeExp |  44.59800|
| Gabon                    | Africa    |  1972|     48.86533| lifeExp |  48.69000|
| Gabon                    | Africa    |  1977|     48.86533| lifeExp |  52.79000|
| Gabon                    | Africa    |  1982|     48.86533| lifeExp |  56.56400|
| Gabon                    | Africa    |  1987|     48.86533| lifeExp |  60.19000|
| Gabon                    | Africa    |  1992|     48.86533| lifeExp |  61.36600|
| Gabon                    | Africa    |  1997|     48.86533| lifeExp |  60.46100|
| Gabon                    | Africa    |  2002|     48.86533| lifeExp |  56.76100|
| Gabon                    | Africa    |  2007|     48.86533| lifeExp |  56.73500|
| Gambia                   | Africa    |  1952|     48.86533| lifeExp |  30.00000|
| Gambia                   | Africa    |  1957|     48.86533| lifeExp |  32.06500|
| Gambia                   | Africa    |  1962|     48.86533| lifeExp |  33.89600|
| Gambia                   | Africa    |  1967|     48.86533| lifeExp |  35.85700|
| Gambia                   | Africa    |  1972|     48.86533| lifeExp |  38.30800|
| Gambia                   | Africa    |  1977|     48.86533| lifeExp |  41.84200|
| Gambia                   | Africa    |  1982|     48.86533| lifeExp |  45.58000|
| Gambia                   | Africa    |  1987|     48.86533| lifeExp |  49.26500|
| Gambia                   | Africa    |  1992|     48.86533| lifeExp |  52.64400|
| Gambia                   | Africa    |  1997|     48.86533| lifeExp |  55.86100|
| Gambia                   | Africa    |  2002|     48.86533| lifeExp |  58.04100|
| Gambia                   | Africa    |  2007|     48.86533| lifeExp |  59.44800|
| Germany                  | Europe    |  1952|     71.90369| lifeExp |  67.50000|
| Germany                  | Europe    |  1957|     71.90369| lifeExp |  69.10000|
| Germany                  | Europe    |  1962|     71.90369| lifeExp |  70.30000|
| Germany                  | Europe    |  1967|     71.90369| lifeExp |  70.80000|
| Germany                  | Europe    |  1972|     71.90369| lifeExp |  71.00000|
| Germany                  | Europe    |  1977|     71.90369| lifeExp |  72.50000|
| Germany                  | Europe    |  1982|     71.90369| lifeExp |  73.80000|
| Germany                  | Europe    |  1987|     71.90369| lifeExp |  74.84700|
| Germany                  | Europe    |  1992|     71.90369| lifeExp |  76.07000|
| Germany                  | Europe    |  1997|     71.90369| lifeExp |  77.34000|
| Germany                  | Europe    |  2002|     71.90369| lifeExp |  78.67000|
| Germany                  | Europe    |  2007|     71.90369| lifeExp |  79.40600|
| Ghana                    | Africa    |  1952|     48.86533| lifeExp |  43.14900|
| Ghana                    | Africa    |  1957|     48.86533| lifeExp |  44.77900|
| Ghana                    | Africa    |  1962|     48.86533| lifeExp |  46.45200|
| Ghana                    | Africa    |  1967|     48.86533| lifeExp |  48.07200|
| Ghana                    | Africa    |  1972|     48.86533| lifeExp |  49.87500|
| Ghana                    | Africa    |  1977|     48.86533| lifeExp |  51.75600|
| Ghana                    | Africa    |  1982|     48.86533| lifeExp |  53.74400|
| Ghana                    | Africa    |  1987|     48.86533| lifeExp |  55.72900|
| Ghana                    | Africa    |  1992|     48.86533| lifeExp |  57.50100|
| Ghana                    | Africa    |  1997|     48.86533| lifeExp |  58.55600|
| Ghana                    | Africa    |  2002|     48.86533| lifeExp |  58.45300|
| Ghana                    | Africa    |  2007|     48.86533| lifeExp |  60.02200|
| Greece                   | Europe    |  1952|     71.90369| lifeExp |  65.86000|
| Greece                   | Europe    |  1957|     71.90369| lifeExp |  67.86000|
| Greece                   | Europe    |  1962|     71.90369| lifeExp |  69.51000|
| Greece                   | Europe    |  1967|     71.90369| lifeExp |  71.00000|
| Greece                   | Europe    |  1972|     71.90369| lifeExp |  72.34000|
| Greece                   | Europe    |  1977|     71.90369| lifeExp |  73.68000|
| Greece                   | Europe    |  1982|     71.90369| lifeExp |  75.24000|
| Greece                   | Europe    |  1987|     71.90369| lifeExp |  76.67000|
| Greece                   | Europe    |  1992|     71.90369| lifeExp |  77.03000|
| Greece                   | Europe    |  1997|     71.90369| lifeExp |  77.86900|
| Greece                   | Europe    |  2002|     71.90369| lifeExp |  78.25600|
| Greece                   | Europe    |  2007|     71.90369| lifeExp |  79.48300|
| Guatemala                | Americas  |  1952|     64.65874| lifeExp |  42.02300|
| Guatemala                | Americas  |  1957|     64.65874| lifeExp |  44.14200|
| Guatemala                | Americas  |  1962|     64.65874| lifeExp |  46.95400|
| Guatemala                | Americas  |  1967|     64.65874| lifeExp |  50.01600|
| Guatemala                | Americas  |  1972|     64.65874| lifeExp |  53.73800|
| Guatemala                | Americas  |  1977|     64.65874| lifeExp |  56.02900|
| Guatemala                | Americas  |  1982|     64.65874| lifeExp |  58.13700|
| Guatemala                | Americas  |  1987|     64.65874| lifeExp |  60.78200|
| Guatemala                | Americas  |  1992|     64.65874| lifeExp |  63.37300|
| Guatemala                | Americas  |  1997|     64.65874| lifeExp |  66.32200|
| Guatemala                | Americas  |  2002|     64.65874| lifeExp |  68.97800|
| Guatemala                | Americas  |  2007|     64.65874| lifeExp |  70.25900|
| Guinea                   | Africa    |  1952|     48.86533| lifeExp |  33.60900|
| Guinea                   | Africa    |  1957|     48.86533| lifeExp |  34.55800|
| Guinea                   | Africa    |  1962|     48.86533| lifeExp |  35.75300|
| Guinea                   | Africa    |  1967|     48.86533| lifeExp |  37.19700|
| Guinea                   | Africa    |  1972|     48.86533| lifeExp |  38.84200|
| Guinea                   | Africa    |  1977|     48.86533| lifeExp |  40.76200|
| Guinea                   | Africa    |  1982|     48.86533| lifeExp |  42.89100|
| Guinea                   | Africa    |  1987|     48.86533| lifeExp |  45.55200|
| Guinea                   | Africa    |  1992|     48.86533| lifeExp |  48.57600|
| Guinea                   | Africa    |  1997|     48.86533| lifeExp |  51.45500|
| Guinea                   | Africa    |  2002|     48.86533| lifeExp |  53.67600|
| Guinea                   | Africa    |  2007|     48.86533| lifeExp |  56.00700|
| Guinea-Bissau            | Africa    |  1952|     48.86533| lifeExp |  32.50000|
| Guinea-Bissau            | Africa    |  1957|     48.86533| lifeExp |  33.48900|
| Guinea-Bissau            | Africa    |  1962|     48.86533| lifeExp |  34.48800|
| Guinea-Bissau            | Africa    |  1967|     48.86533| lifeExp |  35.49200|
| Guinea-Bissau            | Africa    |  1972|     48.86533| lifeExp |  36.48600|
| Guinea-Bissau            | Africa    |  1977|     48.86533| lifeExp |  37.46500|
| Guinea-Bissau            | Africa    |  1982|     48.86533| lifeExp |  39.32700|
| Guinea-Bissau            | Africa    |  1987|     48.86533| lifeExp |  41.24500|
| Guinea-Bissau            | Africa    |  1992|     48.86533| lifeExp |  43.26600|
| Guinea-Bissau            | Africa    |  1997|     48.86533| lifeExp |  44.87300|
| Guinea-Bissau            | Africa    |  2002|     48.86533| lifeExp |  45.50400|
| Guinea-Bissau            | Africa    |  2007|     48.86533| lifeExp |  46.38800|
| Haiti                    | Americas  |  1952|     64.65874| lifeExp |  37.57900|
| Haiti                    | Americas  |  1957|     64.65874| lifeExp |  40.69600|
| Haiti                    | Americas  |  1962|     64.65874| lifeExp |  43.59000|
| Haiti                    | Americas  |  1967|     64.65874| lifeExp |  46.24300|
| Haiti                    | Americas  |  1972|     64.65874| lifeExp |  48.04200|
| Haiti                    | Americas  |  1977|     64.65874| lifeExp |  49.92300|
| Haiti                    | Americas  |  1982|     64.65874| lifeExp |  51.46100|
| Haiti                    | Americas  |  1987|     64.65874| lifeExp |  53.63600|
| Haiti                    | Americas  |  1992|     64.65874| lifeExp |  55.08900|
| Haiti                    | Americas  |  1997|     64.65874| lifeExp |  56.67100|
| Haiti                    | Americas  |  2002|     64.65874| lifeExp |  58.13700|
| Haiti                    | Americas  |  2007|     64.65874| lifeExp |  60.91600|
| Honduras                 | Americas  |  1952|     64.65874| lifeExp |  41.91200|
| Honduras                 | Americas  |  1957|     64.65874| lifeExp |  44.66500|
| Honduras                 | Americas  |  1962|     64.65874| lifeExp |  48.04100|
| Honduras                 | Americas  |  1967|     64.65874| lifeExp |  50.92400|
| Honduras                 | Americas  |  1972|     64.65874| lifeExp |  53.88400|
| Honduras                 | Americas  |  1977|     64.65874| lifeExp |  57.40200|
| Honduras                 | Americas  |  1982|     64.65874| lifeExp |  60.90900|
| Honduras                 | Americas  |  1987|     64.65874| lifeExp |  64.49200|
| Honduras                 | Americas  |  1992|     64.65874| lifeExp |  66.39900|
| Honduras                 | Americas  |  1997|     64.65874| lifeExp |  67.65900|
| Honduras                 | Americas  |  2002|     64.65874| lifeExp |  68.56500|
| Honduras                 | Americas  |  2007|     64.65874| lifeExp |  70.19800|
| Hong Kong, China         | Asia      |  1952|     60.06490| lifeExp |  60.96000|
| Hong Kong, China         | Asia      |  1957|     60.06490| lifeExp |  64.75000|
| Hong Kong, China         | Asia      |  1962|     60.06490| lifeExp |  67.65000|
| Hong Kong, China         | Asia      |  1967|     60.06490| lifeExp |  70.00000|
| Hong Kong, China         | Asia      |  1972|     60.06490| lifeExp |  72.00000|
| Hong Kong, China         | Asia      |  1977|     60.06490| lifeExp |  73.60000|
| Hong Kong, China         | Asia      |  1982|     60.06490| lifeExp |  75.45000|
| Hong Kong, China         | Asia      |  1987|     60.06490| lifeExp |  76.20000|
| Hong Kong, China         | Asia      |  1992|     60.06490| lifeExp |  77.60100|
| Hong Kong, China         | Asia      |  1997|     60.06490| lifeExp |  80.00000|
| Hong Kong, China         | Asia      |  2002|     60.06490| lifeExp |  81.49500|
| Hong Kong, China         | Asia      |  2007|     60.06490| lifeExp |  82.20800|
| Hungary                  | Europe    |  1952|     71.90369| lifeExp |  64.03000|
| Hungary                  | Europe    |  1957|     71.90369| lifeExp |  66.41000|
| Hungary                  | Europe    |  1962|     71.90369| lifeExp |  67.96000|
| Hungary                  | Europe    |  1967|     71.90369| lifeExp |  69.50000|
| Hungary                  | Europe    |  1972|     71.90369| lifeExp |  69.76000|
| Hungary                  | Europe    |  1977|     71.90369| lifeExp |  69.95000|
| Hungary                  | Europe    |  1982|     71.90369| lifeExp |  69.39000|
| Hungary                  | Europe    |  1987|     71.90369| lifeExp |  69.58000|
| Hungary                  | Europe    |  1992|     71.90369| lifeExp |  69.17000|
| Hungary                  | Europe    |  1997|     71.90369| lifeExp |  71.04000|
| Hungary                  | Europe    |  2002|     71.90369| lifeExp |  72.59000|
| Hungary                  | Europe    |  2007|     71.90369| lifeExp |  73.33800|
| Iceland                  | Europe    |  1952|     71.90369| lifeExp |  72.49000|
| Iceland                  | Europe    |  1957|     71.90369| lifeExp |  73.47000|
| Iceland                  | Europe    |  1962|     71.90369| lifeExp |  73.68000|
| Iceland                  | Europe    |  1967|     71.90369| lifeExp |  73.73000|
| Iceland                  | Europe    |  1972|     71.90369| lifeExp |  74.46000|
| Iceland                  | Europe    |  1977|     71.90369| lifeExp |  76.11000|
| Iceland                  | Europe    |  1982|     71.90369| lifeExp |  76.99000|
| Iceland                  | Europe    |  1987|     71.90369| lifeExp |  77.23000|
| Iceland                  | Europe    |  1992|     71.90369| lifeExp |  78.77000|
| Iceland                  | Europe    |  1997|     71.90369| lifeExp |  78.95000|
| Iceland                  | Europe    |  2002|     71.90369| lifeExp |  80.50000|
| Iceland                  | Europe    |  2007|     71.90369| lifeExp |  81.75700|
| India                    | Asia      |  1952|     60.06490| lifeExp |  37.37300|
| India                    | Asia      |  1957|     60.06490| lifeExp |  40.24900|
| India                    | Asia      |  1962|     60.06490| lifeExp |  43.60500|
| India                    | Asia      |  1967|     60.06490| lifeExp |  47.19300|
| India                    | Asia      |  1972|     60.06490| lifeExp |  50.65100|
| India                    | Asia      |  1977|     60.06490| lifeExp |  54.20800|
| India                    | Asia      |  1982|     60.06490| lifeExp |  56.59600|
| India                    | Asia      |  1987|     60.06490| lifeExp |  58.55300|
| India                    | Asia      |  1992|     60.06490| lifeExp |  60.22300|
| India                    | Asia      |  1997|     60.06490| lifeExp |  61.76500|
| India                    | Asia      |  2002|     60.06490| lifeExp |  62.87900|
| India                    | Asia      |  2007|     60.06490| lifeExp |  64.69800|
| Indonesia                | Asia      |  1952|     60.06490| lifeExp |  37.46800|
| Indonesia                | Asia      |  1957|     60.06490| lifeExp |  39.91800|
| Indonesia                | Asia      |  1962|     60.06490| lifeExp |  42.51800|
| Indonesia                | Asia      |  1967|     60.06490| lifeExp |  45.96400|
| Indonesia                | Asia      |  1972|     60.06490| lifeExp |  49.20300|
| Indonesia                | Asia      |  1977|     60.06490| lifeExp |  52.70200|
| Indonesia                | Asia      |  1982|     60.06490| lifeExp |  56.15900|
| Indonesia                | Asia      |  1987|     60.06490| lifeExp |  60.13700|
| Indonesia                | Asia      |  1992|     60.06490| lifeExp |  62.68100|
| Indonesia                | Asia      |  1997|     60.06490| lifeExp |  66.04100|
| Indonesia                | Asia      |  2002|     60.06490| lifeExp |  68.58800|
| Indonesia                | Asia      |  2007|     60.06490| lifeExp |  70.65000|
| Iran                     | Asia      |  1952|     60.06490| lifeExp |  44.86900|
| Iran                     | Asia      |  1957|     60.06490| lifeExp |  47.18100|
| Iran                     | Asia      |  1962|     60.06490| lifeExp |  49.32500|
| Iran                     | Asia      |  1967|     60.06490| lifeExp |  52.46900|
| Iran                     | Asia      |  1972|     60.06490| lifeExp |  55.23400|
| Iran                     | Asia      |  1977|     60.06490| lifeExp |  57.70200|
| Iran                     | Asia      |  1982|     60.06490| lifeExp |  59.62000|
| Iran                     | Asia      |  1987|     60.06490| lifeExp |  63.04000|
| Iran                     | Asia      |  1992|     60.06490| lifeExp |  65.74200|
| Iran                     | Asia      |  1997|     60.06490| lifeExp |  68.04200|
| Iran                     | Asia      |  2002|     60.06490| lifeExp |  69.45100|
| Iran                     | Asia      |  2007|     60.06490| lifeExp |  70.96400|
| Iraq                     | Asia      |  1952|     60.06490| lifeExp |  45.32000|
| Iraq                     | Asia      |  1957|     60.06490| lifeExp |  48.43700|
| Iraq                     | Asia      |  1962|     60.06490| lifeExp |  51.45700|
| Iraq                     | Asia      |  1967|     60.06490| lifeExp |  54.45900|
| Iraq                     | Asia      |  1972|     60.06490| lifeExp |  56.95000|
| Iraq                     | Asia      |  1977|     60.06490| lifeExp |  60.41300|
| Iraq                     | Asia      |  1982|     60.06490| lifeExp |  62.03800|
| Iraq                     | Asia      |  1987|     60.06490| lifeExp |  65.04400|
| Iraq                     | Asia      |  1992|     60.06490| lifeExp |  59.46100|
| Iraq                     | Asia      |  1997|     60.06490| lifeExp |  58.81100|
| Iraq                     | Asia      |  2002|     60.06490| lifeExp |  57.04600|
| Iraq                     | Asia      |  2007|     60.06490| lifeExp |  59.54500|
| Ireland                  | Europe    |  1952|     71.90369| lifeExp |  66.91000|
| Ireland                  | Europe    |  1957|     71.90369| lifeExp |  68.90000|
| Ireland                  | Europe    |  1962|     71.90369| lifeExp |  70.29000|
| Ireland                  | Europe    |  1967|     71.90369| lifeExp |  71.08000|
| Ireland                  | Europe    |  1972|     71.90369| lifeExp |  71.28000|
| Ireland                  | Europe    |  1977|     71.90369| lifeExp |  72.03000|
| Ireland                  | Europe    |  1982|     71.90369| lifeExp |  73.10000|
| Ireland                  | Europe    |  1987|     71.90369| lifeExp |  74.36000|
| Ireland                  | Europe    |  1992|     71.90369| lifeExp |  75.46700|
| Ireland                  | Europe    |  1997|     71.90369| lifeExp |  76.12200|
| Ireland                  | Europe    |  2002|     71.90369| lifeExp |  77.78300|
| Ireland                  | Europe    |  2007|     71.90369| lifeExp |  78.88500|
| Israel                   | Asia      |  1952|     60.06490| lifeExp |  65.39000|
| Israel                   | Asia      |  1957|     60.06490| lifeExp |  67.84000|
| Israel                   | Asia      |  1962|     60.06490| lifeExp |  69.39000|
| Israel                   | Asia      |  1967|     60.06490| lifeExp |  70.75000|
| Israel                   | Asia      |  1972|     60.06490| lifeExp |  71.63000|
| Israel                   | Asia      |  1977|     60.06490| lifeExp |  73.06000|
| Israel                   | Asia      |  1982|     60.06490| lifeExp |  74.45000|
| Israel                   | Asia      |  1987|     60.06490| lifeExp |  75.60000|
| Israel                   | Asia      |  1992|     60.06490| lifeExp |  76.93000|
| Israel                   | Asia      |  1997|     60.06490| lifeExp |  78.26900|
| Israel                   | Asia      |  2002|     60.06490| lifeExp |  79.69600|
| Israel                   | Asia      |  2007|     60.06490| lifeExp |  80.74500|
| Italy                    | Europe    |  1952|     71.90369| lifeExp |  65.94000|
| Italy                    | Europe    |  1957|     71.90369| lifeExp |  67.81000|
| Italy                    | Europe    |  1962|     71.90369| lifeExp |  69.24000|
| Italy                    | Europe    |  1967|     71.90369| lifeExp |  71.06000|
| Italy                    | Europe    |  1972|     71.90369| lifeExp |  72.19000|
| Italy                    | Europe    |  1977|     71.90369| lifeExp |  73.48000|
| Italy                    | Europe    |  1982|     71.90369| lifeExp |  74.98000|
| Italy                    | Europe    |  1987|     71.90369| lifeExp |  76.42000|
| Italy                    | Europe    |  1992|     71.90369| lifeExp |  77.44000|
| Italy                    | Europe    |  1997|     71.90369| lifeExp |  78.82000|
| Italy                    | Europe    |  2002|     71.90369| lifeExp |  80.24000|
| Italy                    | Europe    |  2007|     71.90369| lifeExp |  80.54600|
| Jamaica                  | Americas  |  1952|     64.65874| lifeExp |  58.53000|
| Jamaica                  | Americas  |  1957|     64.65874| lifeExp |  62.61000|
| Jamaica                  | Americas  |  1962|     64.65874| lifeExp |  65.61000|
| Jamaica                  | Americas  |  1967|     64.65874| lifeExp |  67.51000|
| Jamaica                  | Americas  |  1972|     64.65874| lifeExp |  69.00000|
| Jamaica                  | Americas  |  1977|     64.65874| lifeExp |  70.11000|
| Jamaica                  | Americas  |  1982|     64.65874| lifeExp |  71.21000|
| Jamaica                  | Americas  |  1987|     64.65874| lifeExp |  71.77000|
| Jamaica                  | Americas  |  1992|     64.65874| lifeExp |  71.76600|
| Jamaica                  | Americas  |  1997|     64.65874| lifeExp |  72.26200|
| Jamaica                  | Americas  |  2002|     64.65874| lifeExp |  72.04700|
| Jamaica                  | Americas  |  2007|     64.65874| lifeExp |  72.56700|
| Japan                    | Asia      |  1952|     60.06490| lifeExp |  63.03000|
| Japan                    | Asia      |  1957|     60.06490| lifeExp |  65.50000|
| Japan                    | Asia      |  1962|     60.06490| lifeExp |  68.73000|
| Japan                    | Asia      |  1967|     60.06490| lifeExp |  71.43000|
| Japan                    | Asia      |  1972|     60.06490| lifeExp |  73.42000|
| Japan                    | Asia      |  1977|     60.06490| lifeExp |  75.38000|
| Japan                    | Asia      |  1982|     60.06490| lifeExp |  77.11000|
| Japan                    | Asia      |  1987|     60.06490| lifeExp |  78.67000|
| Japan                    | Asia      |  1992|     60.06490| lifeExp |  79.36000|
| Japan                    | Asia      |  1997|     60.06490| lifeExp |  80.69000|
| Japan                    | Asia      |  2002|     60.06490| lifeExp |  82.00000|
| Japan                    | Asia      |  2007|     60.06490| lifeExp |  82.60300|
| Jordan                   | Asia      |  1952|     60.06490| lifeExp |  43.15800|
| Jordan                   | Asia      |  1957|     60.06490| lifeExp |  45.66900|
| Jordan                   | Asia      |  1962|     60.06490| lifeExp |  48.12600|
| Jordan                   | Asia      |  1967|     60.06490| lifeExp |  51.62900|
| Jordan                   | Asia      |  1972|     60.06490| lifeExp |  56.52800|
| Jordan                   | Asia      |  1977|     60.06490| lifeExp |  61.13400|
| Jordan                   | Asia      |  1982|     60.06490| lifeExp |  63.73900|
| Jordan                   | Asia      |  1987|     60.06490| lifeExp |  65.86900|
| Jordan                   | Asia      |  1992|     60.06490| lifeExp |  68.01500|
| Jordan                   | Asia      |  1997|     60.06490| lifeExp |  69.77200|
| Jordan                   | Asia      |  2002|     60.06490| lifeExp |  71.26300|
| Jordan                   | Asia      |  2007|     60.06490| lifeExp |  72.53500|
| Kenya                    | Africa    |  1952|     48.86533| lifeExp |  42.27000|
| Kenya                    | Africa    |  1957|     48.86533| lifeExp |  44.68600|
| Kenya                    | Africa    |  1962|     48.86533| lifeExp |  47.94900|
| Kenya                    | Africa    |  1967|     48.86533| lifeExp |  50.65400|
| Kenya                    | Africa    |  1972|     48.86533| lifeExp |  53.55900|
| Kenya                    | Africa    |  1977|     48.86533| lifeExp |  56.15500|
| Kenya                    | Africa    |  1982|     48.86533| lifeExp |  58.76600|
| Kenya                    | Africa    |  1987|     48.86533| lifeExp |  59.33900|
| Kenya                    | Africa    |  1992|     48.86533| lifeExp |  59.28500|
| Kenya                    | Africa    |  1997|     48.86533| lifeExp |  54.40700|
| Kenya                    | Africa    |  2002|     48.86533| lifeExp |  50.99200|
| Kenya                    | Africa    |  2007|     48.86533| lifeExp |  54.11000|
| Korea, Dem. Rep.         | Asia      |  1952|     60.06490| lifeExp |  50.05600|
| Korea, Dem. Rep.         | Asia      |  1957|     60.06490| lifeExp |  54.08100|
| Korea, Dem. Rep.         | Asia      |  1962|     60.06490| lifeExp |  56.65600|
| Korea, Dem. Rep.         | Asia      |  1967|     60.06490| lifeExp |  59.94200|
| Korea, Dem. Rep.         | Asia      |  1972|     60.06490| lifeExp |  63.98300|
| Korea, Dem. Rep.         | Asia      |  1977|     60.06490| lifeExp |  67.15900|
| Korea, Dem. Rep.         | Asia      |  1982|     60.06490| lifeExp |  69.10000|
| Korea, Dem. Rep.         | Asia      |  1987|     60.06490| lifeExp |  70.64700|
| Korea, Dem. Rep.         | Asia      |  1992|     60.06490| lifeExp |  69.97800|
| Korea, Dem. Rep.         | Asia      |  1997|     60.06490| lifeExp |  67.72700|
| Korea, Dem. Rep.         | Asia      |  2002|     60.06490| lifeExp |  66.66200|
| Korea, Dem. Rep.         | Asia      |  2007|     60.06490| lifeExp |  67.29700|
| Korea, Rep.              | Asia      |  1952|     60.06490| lifeExp |  47.45300|
| Korea, Rep.              | Asia      |  1957|     60.06490| lifeExp |  52.68100|
| Korea, Rep.              | Asia      |  1962|     60.06490| lifeExp |  55.29200|
| Korea, Rep.              | Asia      |  1967|     60.06490| lifeExp |  57.71600|
| Korea, Rep.              | Asia      |  1972|     60.06490| lifeExp |  62.61200|
| Korea, Rep.              | Asia      |  1977|     60.06490| lifeExp |  64.76600|
| Korea, Rep.              | Asia      |  1982|     60.06490| lifeExp |  67.12300|
| Korea, Rep.              | Asia      |  1987|     60.06490| lifeExp |  69.81000|
| Korea, Rep.              | Asia      |  1992|     60.06490| lifeExp |  72.24400|
| Korea, Rep.              | Asia      |  1997|     60.06490| lifeExp |  74.64700|
| Korea, Rep.              | Asia      |  2002|     60.06490| lifeExp |  77.04500|
| Korea, Rep.              | Asia      |  2007|     60.06490| lifeExp |  78.62300|
| Kuwait                   | Asia      |  1952|     60.06490| lifeExp |  55.56500|
| Kuwait                   | Asia      |  1957|     60.06490| lifeExp |  58.03300|
| Kuwait                   | Asia      |  1962|     60.06490| lifeExp |  60.47000|
| Kuwait                   | Asia      |  1967|     60.06490| lifeExp |  64.62400|
| Kuwait                   | Asia      |  1972|     60.06490| lifeExp |  67.71200|
| Kuwait                   | Asia      |  1977|     60.06490| lifeExp |  69.34300|
| Kuwait                   | Asia      |  1982|     60.06490| lifeExp |  71.30900|
| Kuwait                   | Asia      |  1987|     60.06490| lifeExp |  74.17400|
| Kuwait                   | Asia      |  1992|     60.06490| lifeExp |  75.19000|
| Kuwait                   | Asia      |  1997|     60.06490| lifeExp |  76.15600|
| Kuwait                   | Asia      |  2002|     60.06490| lifeExp |  76.90400|
| Kuwait                   | Asia      |  2007|     60.06490| lifeExp |  77.58800|
| Lebanon                  | Asia      |  1952|     60.06490| lifeExp |  55.92800|
| Lebanon                  | Asia      |  1957|     60.06490| lifeExp |  59.48900|
| Lebanon                  | Asia      |  1962|     60.06490| lifeExp |  62.09400|
| Lebanon                  | Asia      |  1967|     60.06490| lifeExp |  63.87000|
| Lebanon                  | Asia      |  1972|     60.06490| lifeExp |  65.42100|
| Lebanon                  | Asia      |  1977|     60.06490| lifeExp |  66.09900|
| Lebanon                  | Asia      |  1982|     60.06490| lifeExp |  66.98300|
| Lebanon                  | Asia      |  1987|     60.06490| lifeExp |  67.92600|
| Lebanon                  | Asia      |  1992|     60.06490| lifeExp |  69.29200|
| Lebanon                  | Asia      |  1997|     60.06490| lifeExp |  70.26500|
| Lebanon                  | Asia      |  2002|     60.06490| lifeExp |  71.02800|
| Lebanon                  | Asia      |  2007|     60.06490| lifeExp |  71.99300|
| Lesotho                  | Africa    |  1952|     48.86533| lifeExp |  42.13800|
| Lesotho                  | Africa    |  1957|     48.86533| lifeExp |  45.04700|
| Lesotho                  | Africa    |  1962|     48.86533| lifeExp |  47.74700|
| Lesotho                  | Africa    |  1967|     48.86533| lifeExp |  48.49200|
| Lesotho                  | Africa    |  1972|     48.86533| lifeExp |  49.76700|
| Lesotho                  | Africa    |  1977|     48.86533| lifeExp |  52.20800|
| Lesotho                  | Africa    |  1982|     48.86533| lifeExp |  55.07800|
| Lesotho                  | Africa    |  1987|     48.86533| lifeExp |  57.18000|
| Lesotho                  | Africa    |  1992|     48.86533| lifeExp |  59.68500|
| Lesotho                  | Africa    |  1997|     48.86533| lifeExp |  55.55800|
| Lesotho                  | Africa    |  2002|     48.86533| lifeExp |  44.59300|
| Lesotho                  | Africa    |  2007|     48.86533| lifeExp |  42.59200|
| Liberia                  | Africa    |  1952|     48.86533| lifeExp |  38.48000|
| Liberia                  | Africa    |  1957|     48.86533| lifeExp |  39.48600|
| Liberia                  | Africa    |  1962|     48.86533| lifeExp |  40.50200|
| Liberia                  | Africa    |  1967|     48.86533| lifeExp |  41.53600|
| Liberia                  | Africa    |  1972|     48.86533| lifeExp |  42.61400|
| Liberia                  | Africa    |  1977|     48.86533| lifeExp |  43.76400|
| Liberia                  | Africa    |  1982|     48.86533| lifeExp |  44.85200|
| Liberia                  | Africa    |  1987|     48.86533| lifeExp |  46.02700|
| Liberia                  | Africa    |  1992|     48.86533| lifeExp |  40.80200|
| Liberia                  | Africa    |  1997|     48.86533| lifeExp |  42.22100|
| Liberia                  | Africa    |  2002|     48.86533| lifeExp |  43.75300|
| Liberia                  | Africa    |  2007|     48.86533| lifeExp |  45.67800|
| Libya                    | Africa    |  1952|     48.86533| lifeExp |  42.72300|
| Libya                    | Africa    |  1957|     48.86533| lifeExp |  45.28900|
| Libya                    | Africa    |  1962|     48.86533| lifeExp |  47.80800|
| Libya                    | Africa    |  1967|     48.86533| lifeExp |  50.22700|
| Libya                    | Africa    |  1972|     48.86533| lifeExp |  52.77300|
| Libya                    | Africa    |  1977|     48.86533| lifeExp |  57.44200|
| Libya                    | Africa    |  1982|     48.86533| lifeExp |  62.15500|
| Libya                    | Africa    |  1987|     48.86533| lifeExp |  66.23400|
| Libya                    | Africa    |  1992|     48.86533| lifeExp |  68.75500|
| Libya                    | Africa    |  1997|     48.86533| lifeExp |  71.55500|
| Libya                    | Africa    |  2002|     48.86533| lifeExp |  72.73700|
| Libya                    | Africa    |  2007|     48.86533| lifeExp |  73.95200|
| Madagascar               | Africa    |  1952|     48.86533| lifeExp |  36.68100|
| Madagascar               | Africa    |  1957|     48.86533| lifeExp |  38.86500|
| Madagascar               | Africa    |  1962|     48.86533| lifeExp |  40.84800|
| Madagascar               | Africa    |  1967|     48.86533| lifeExp |  42.88100|
| Madagascar               | Africa    |  1972|     48.86533| lifeExp |  44.85100|
| Madagascar               | Africa    |  1977|     48.86533| lifeExp |  46.88100|
| Madagascar               | Africa    |  1982|     48.86533| lifeExp |  48.96900|
| Madagascar               | Africa    |  1987|     48.86533| lifeExp |  49.35000|
| Madagascar               | Africa    |  1992|     48.86533| lifeExp |  52.21400|
| Madagascar               | Africa    |  1997|     48.86533| lifeExp |  54.97800|
| Madagascar               | Africa    |  2002|     48.86533| lifeExp |  57.28600|
| Madagascar               | Africa    |  2007|     48.86533| lifeExp |  59.44300|
| Malawi                   | Africa    |  1952|     48.86533| lifeExp |  36.25600|
| Malawi                   | Africa    |  1957|     48.86533| lifeExp |  37.20700|
| Malawi                   | Africa    |  1962|     48.86533| lifeExp |  38.41000|
| Malawi                   | Africa    |  1967|     48.86533| lifeExp |  39.48700|
| Malawi                   | Africa    |  1972|     48.86533| lifeExp |  41.76600|
| Malawi                   | Africa    |  1977|     48.86533| lifeExp |  43.76700|
| Malawi                   | Africa    |  1982|     48.86533| lifeExp |  45.64200|
| Malawi                   | Africa    |  1987|     48.86533| lifeExp |  47.45700|
| Malawi                   | Africa    |  1992|     48.86533| lifeExp |  49.42000|
| Malawi                   | Africa    |  1997|     48.86533| lifeExp |  47.49500|
| Malawi                   | Africa    |  2002|     48.86533| lifeExp |  45.00900|
| Malawi                   | Africa    |  2007|     48.86533| lifeExp |  48.30300|
| Malaysia                 | Asia      |  1952|     60.06490| lifeExp |  48.46300|
| Malaysia                 | Asia      |  1957|     60.06490| lifeExp |  52.10200|
| Malaysia                 | Asia      |  1962|     60.06490| lifeExp |  55.73700|
| Malaysia                 | Asia      |  1967|     60.06490| lifeExp |  59.37100|
| Malaysia                 | Asia      |  1972|     60.06490| lifeExp |  63.01000|
| Malaysia                 | Asia      |  1977|     60.06490| lifeExp |  65.25600|
| Malaysia                 | Asia      |  1982|     60.06490| lifeExp |  68.00000|
| Malaysia                 | Asia      |  1987|     60.06490| lifeExp |  69.50000|
| Malaysia                 | Asia      |  1992|     60.06490| lifeExp |  70.69300|
| Malaysia                 | Asia      |  1997|     60.06490| lifeExp |  71.93800|
| Malaysia                 | Asia      |  2002|     60.06490| lifeExp |  73.04400|
| Malaysia                 | Asia      |  2007|     60.06490| lifeExp |  74.24100|
| Mali                     | Africa    |  1952|     48.86533| lifeExp |  33.68500|
| Mali                     | Africa    |  1957|     48.86533| lifeExp |  35.30700|
| Mali                     | Africa    |  1962|     48.86533| lifeExp |  36.93600|
| Mali                     | Africa    |  1967|     48.86533| lifeExp |  38.48700|
| Mali                     | Africa    |  1972|     48.86533| lifeExp |  39.97700|
| Mali                     | Africa    |  1977|     48.86533| lifeExp |  41.71400|
| Mali                     | Africa    |  1982|     48.86533| lifeExp |  43.91600|
| Mali                     | Africa    |  1987|     48.86533| lifeExp |  46.36400|
| Mali                     | Africa    |  1992|     48.86533| lifeExp |  48.38800|
| Mali                     | Africa    |  1997|     48.86533| lifeExp |  49.90300|
| Mali                     | Africa    |  2002|     48.86533| lifeExp |  51.81800|
| Mali                     | Africa    |  2007|     48.86533| lifeExp |  54.46700|
| Mauritania               | Africa    |  1952|     48.86533| lifeExp |  40.54300|
| Mauritania               | Africa    |  1957|     48.86533| lifeExp |  42.33800|
| Mauritania               | Africa    |  1962|     48.86533| lifeExp |  44.24800|
| Mauritania               | Africa    |  1967|     48.86533| lifeExp |  46.28900|
| Mauritania               | Africa    |  1972|     48.86533| lifeExp |  48.43700|
| Mauritania               | Africa    |  1977|     48.86533| lifeExp |  50.85200|
| Mauritania               | Africa    |  1982|     48.86533| lifeExp |  53.59900|
| Mauritania               | Africa    |  1987|     48.86533| lifeExp |  56.14500|
| Mauritania               | Africa    |  1992|     48.86533| lifeExp |  58.33300|
| Mauritania               | Africa    |  1997|     48.86533| lifeExp |  60.43000|
| Mauritania               | Africa    |  2002|     48.86533| lifeExp |  62.24700|
| Mauritania               | Africa    |  2007|     48.86533| lifeExp |  64.16400|
| Mauritius                | Africa    |  1952|     48.86533| lifeExp |  50.98600|
| Mauritius                | Africa    |  1957|     48.86533| lifeExp |  58.08900|
| Mauritius                | Africa    |  1962|     48.86533| lifeExp |  60.24600|
| Mauritius                | Africa    |  1967|     48.86533| lifeExp |  61.55700|
| Mauritius                | Africa    |  1972|     48.86533| lifeExp |  62.94400|
| Mauritius                | Africa    |  1977|     48.86533| lifeExp |  64.93000|
| Mauritius                | Africa    |  1982|     48.86533| lifeExp |  66.71100|
| Mauritius                | Africa    |  1987|     48.86533| lifeExp |  68.74000|
| Mauritius                | Africa    |  1992|     48.86533| lifeExp |  69.74500|
| Mauritius                | Africa    |  1997|     48.86533| lifeExp |  70.73600|
| Mauritius                | Africa    |  2002|     48.86533| lifeExp |  71.95400|
| Mauritius                | Africa    |  2007|     48.86533| lifeExp |  72.80100|
| Mexico                   | Americas  |  1952|     64.65874| lifeExp |  50.78900|
| Mexico                   | Americas  |  1957|     64.65874| lifeExp |  55.19000|
| Mexico                   | Americas  |  1962|     64.65874| lifeExp |  58.29900|
| Mexico                   | Americas  |  1967|     64.65874| lifeExp |  60.11000|
| Mexico                   | Americas  |  1972|     64.65874| lifeExp |  62.36100|
| Mexico                   | Americas  |  1977|     64.65874| lifeExp |  65.03200|
| Mexico                   | Americas  |  1982|     64.65874| lifeExp |  67.40500|
| Mexico                   | Americas  |  1987|     64.65874| lifeExp |  69.49800|
| Mexico                   | Americas  |  1992|     64.65874| lifeExp |  71.45500|
| Mexico                   | Americas  |  1997|     64.65874| lifeExp |  73.67000|
| Mexico                   | Americas  |  2002|     64.65874| lifeExp |  74.90200|
| Mexico                   | Americas  |  2007|     64.65874| lifeExp |  76.19500|
| Mongolia                 | Asia      |  1952|     60.06490| lifeExp |  42.24400|
| Mongolia                 | Asia      |  1957|     60.06490| lifeExp |  45.24800|
| Mongolia                 | Asia      |  1962|     60.06490| lifeExp |  48.25100|
| Mongolia                 | Asia      |  1967|     60.06490| lifeExp |  51.25300|
| Mongolia                 | Asia      |  1972|     60.06490| lifeExp |  53.75400|
| Mongolia                 | Asia      |  1977|     60.06490| lifeExp |  55.49100|
| Mongolia                 | Asia      |  1982|     60.06490| lifeExp |  57.48900|
| Mongolia                 | Asia      |  1987|     60.06490| lifeExp |  60.22200|
| Mongolia                 | Asia      |  1992|     60.06490| lifeExp |  61.27100|
| Mongolia                 | Asia      |  1997|     60.06490| lifeExp |  63.62500|
| Mongolia                 | Asia      |  2002|     60.06490| lifeExp |  65.03300|
| Mongolia                 | Asia      |  2007|     60.06490| lifeExp |  66.80300|
| Montenegro               | Europe    |  1952|     71.90369| lifeExp |  59.16400|
| Montenegro               | Europe    |  1957|     71.90369| lifeExp |  61.44800|
| Montenegro               | Europe    |  1962|     71.90369| lifeExp |  63.72800|
| Montenegro               | Europe    |  1967|     71.90369| lifeExp |  67.17800|
| Montenegro               | Europe    |  1972|     71.90369| lifeExp |  70.63600|
| Montenegro               | Europe    |  1977|     71.90369| lifeExp |  73.06600|
| Montenegro               | Europe    |  1982|     71.90369| lifeExp |  74.10100|
| Montenegro               | Europe    |  1987|     71.90369| lifeExp |  74.86500|
| Montenegro               | Europe    |  1992|     71.90369| lifeExp |  75.43500|
| Montenegro               | Europe    |  1997|     71.90369| lifeExp |  75.44500|
| Montenegro               | Europe    |  2002|     71.90369| lifeExp |  73.98100|
| Montenegro               | Europe    |  2007|     71.90369| lifeExp |  74.54300|
| Morocco                  | Africa    |  1952|     48.86533| lifeExp |  42.87300|
| Morocco                  | Africa    |  1957|     48.86533| lifeExp |  45.42300|
| Morocco                  | Africa    |  1962|     48.86533| lifeExp |  47.92400|
| Morocco                  | Africa    |  1967|     48.86533| lifeExp |  50.33500|
| Morocco                  | Africa    |  1972|     48.86533| lifeExp |  52.86200|
| Morocco                  | Africa    |  1977|     48.86533| lifeExp |  55.73000|
| Morocco                  | Africa    |  1982|     48.86533| lifeExp |  59.65000|
| Morocco                  | Africa    |  1987|     48.86533| lifeExp |  62.67700|
| Morocco                  | Africa    |  1992|     48.86533| lifeExp |  65.39300|
| Morocco                  | Africa    |  1997|     48.86533| lifeExp |  67.66000|
| Morocco                  | Africa    |  2002|     48.86533| lifeExp |  69.61500|
| Morocco                  | Africa    |  2007|     48.86533| lifeExp |  71.16400|
| Mozambique               | Africa    |  1952|     48.86533| lifeExp |  31.28600|
| Mozambique               | Africa    |  1957|     48.86533| lifeExp |  33.77900|
| Mozambique               | Africa    |  1962|     48.86533| lifeExp |  36.16100|
| Mozambique               | Africa    |  1967|     48.86533| lifeExp |  38.11300|
| Mozambique               | Africa    |  1972|     48.86533| lifeExp |  40.32800|
| Mozambique               | Africa    |  1977|     48.86533| lifeExp |  42.49500|
| Mozambique               | Africa    |  1982|     48.86533| lifeExp |  42.79500|
| Mozambique               | Africa    |  1987|     48.86533| lifeExp |  42.86100|
| Mozambique               | Africa    |  1992|     48.86533| lifeExp |  44.28400|
| Mozambique               | Africa    |  1997|     48.86533| lifeExp |  46.34400|
| Mozambique               | Africa    |  2002|     48.86533| lifeExp |  44.02600|
| Mozambique               | Africa    |  2007|     48.86533| lifeExp |  42.08200|
| Myanmar                  | Asia      |  1952|     60.06490| lifeExp |  36.31900|
| Myanmar                  | Asia      |  1957|     60.06490| lifeExp |  41.90500|
| Myanmar                  | Asia      |  1962|     60.06490| lifeExp |  45.10800|
| Myanmar                  | Asia      |  1967|     60.06490| lifeExp |  49.37900|
| Myanmar                  | Asia      |  1972|     60.06490| lifeExp |  53.07000|
| Myanmar                  | Asia      |  1977|     60.06490| lifeExp |  56.05900|
| Myanmar                  | Asia      |  1982|     60.06490| lifeExp |  58.05600|
| Myanmar                  | Asia      |  1987|     60.06490| lifeExp |  58.33900|
| Myanmar                  | Asia      |  1992|     60.06490| lifeExp |  59.32000|
| Myanmar                  | Asia      |  1997|     60.06490| lifeExp |  60.32800|
| Myanmar                  | Asia      |  2002|     60.06490| lifeExp |  59.90800|
| Myanmar                  | Asia      |  2007|     60.06490| lifeExp |  62.06900|
| Namibia                  | Africa    |  1952|     48.86533| lifeExp |  41.72500|
| Namibia                  | Africa    |  1957|     48.86533| lifeExp |  45.22600|
| Namibia                  | Africa    |  1962|     48.86533| lifeExp |  48.38600|
| Namibia                  | Africa    |  1967|     48.86533| lifeExp |  51.15900|
| Namibia                  | Africa    |  1972|     48.86533| lifeExp |  53.86700|
| Namibia                  | Africa    |  1977|     48.86533| lifeExp |  56.43700|
| Namibia                  | Africa    |  1982|     48.86533| lifeExp |  58.96800|
| Namibia                  | Africa    |  1987|     48.86533| lifeExp |  60.83500|
| Namibia                  | Africa    |  1992|     48.86533| lifeExp |  61.99900|
| Namibia                  | Africa    |  1997|     48.86533| lifeExp |  58.90900|
| Namibia                  | Africa    |  2002|     48.86533| lifeExp |  51.47900|
| Namibia                  | Africa    |  2007|     48.86533| lifeExp |  52.90600|
| Nepal                    | Asia      |  1952|     60.06490| lifeExp |  36.15700|
| Nepal                    | Asia      |  1957|     60.06490| lifeExp |  37.68600|
| Nepal                    | Asia      |  1962|     60.06490| lifeExp |  39.39300|
| Nepal                    | Asia      |  1967|     60.06490| lifeExp |  41.47200|
| Nepal                    | Asia      |  1972|     60.06490| lifeExp |  43.97100|
| Nepal                    | Asia      |  1977|     60.06490| lifeExp |  46.74800|
| Nepal                    | Asia      |  1982|     60.06490| lifeExp |  49.59400|
| Nepal                    | Asia      |  1987|     60.06490| lifeExp |  52.53700|
| Nepal                    | Asia      |  1992|     60.06490| lifeExp |  55.72700|
| Nepal                    | Asia      |  1997|     60.06490| lifeExp |  59.42600|
| Nepal                    | Asia      |  2002|     60.06490| lifeExp |  61.34000|
| Nepal                    | Asia      |  2007|     60.06490| lifeExp |  63.78500|
| Netherlands              | Europe    |  1952|     71.90369| lifeExp |  72.13000|
| Netherlands              | Europe    |  1957|     71.90369| lifeExp |  72.99000|
| Netherlands              | Europe    |  1962|     71.90369| lifeExp |  73.23000|
| Netherlands              | Europe    |  1967|     71.90369| lifeExp |  73.82000|
| Netherlands              | Europe    |  1972|     71.90369| lifeExp |  73.75000|
| Netherlands              | Europe    |  1977|     71.90369| lifeExp |  75.24000|
| Netherlands              | Europe    |  1982|     71.90369| lifeExp |  76.05000|
| Netherlands              | Europe    |  1987|     71.90369| lifeExp |  76.83000|
| Netherlands              | Europe    |  1992|     71.90369| lifeExp |  77.42000|
| Netherlands              | Europe    |  1997|     71.90369| lifeExp |  78.03000|
| Netherlands              | Europe    |  2002|     71.90369| lifeExp |  78.53000|
| Netherlands              | Europe    |  2007|     71.90369| lifeExp |  79.76200|
| New Zealand              | Oceania   |  1952|     74.32621| lifeExp |  69.39000|
| New Zealand              | Oceania   |  1957|     74.32621| lifeExp |  70.26000|
| New Zealand              | Oceania   |  1962|     74.32621| lifeExp |  71.24000|
| New Zealand              | Oceania   |  1967|     74.32621| lifeExp |  71.52000|
| New Zealand              | Oceania   |  1972|     74.32621| lifeExp |  71.89000|
| New Zealand              | Oceania   |  1977|     74.32621| lifeExp |  72.22000|
| New Zealand              | Oceania   |  1982|     74.32621| lifeExp |  73.84000|
| New Zealand              | Oceania   |  1987|     74.32621| lifeExp |  74.32000|
| New Zealand              | Oceania   |  1992|     74.32621| lifeExp |  76.33000|
| New Zealand              | Oceania   |  1997|     74.32621| lifeExp |  77.55000|
| New Zealand              | Oceania   |  2002|     74.32621| lifeExp |  79.11000|
| New Zealand              | Oceania   |  2007|     74.32621| lifeExp |  80.20400|
| Nicaragua                | Americas  |  1952|     64.65874| lifeExp |  42.31400|
| Nicaragua                | Americas  |  1957|     64.65874| lifeExp |  45.43200|
| Nicaragua                | Americas  |  1962|     64.65874| lifeExp |  48.63200|
| Nicaragua                | Americas  |  1967|     64.65874| lifeExp |  51.88400|
| Nicaragua                | Americas  |  1972|     64.65874| lifeExp |  55.15100|
| Nicaragua                | Americas  |  1977|     64.65874| lifeExp |  57.47000|
| Nicaragua                | Americas  |  1982|     64.65874| lifeExp |  59.29800|
| Nicaragua                | Americas  |  1987|     64.65874| lifeExp |  62.00800|
| Nicaragua                | Americas  |  1992|     64.65874| lifeExp |  65.84300|
| Nicaragua                | Americas  |  1997|     64.65874| lifeExp |  68.42600|
| Nicaragua                | Americas  |  2002|     64.65874| lifeExp |  70.83600|
| Nicaragua                | Americas  |  2007|     64.65874| lifeExp |  72.89900|
| Niger                    | Africa    |  1952|     48.86533| lifeExp |  37.44400|
| Niger                    | Africa    |  1957|     48.86533| lifeExp |  38.59800|
| Niger                    | Africa    |  1962|     48.86533| lifeExp |  39.48700|
| Niger                    | Africa    |  1967|     48.86533| lifeExp |  40.11800|
| Niger                    | Africa    |  1972|     48.86533| lifeExp |  40.54600|
| Niger                    | Africa    |  1977|     48.86533| lifeExp |  41.29100|
| Niger                    | Africa    |  1982|     48.86533| lifeExp |  42.59800|
| Niger                    | Africa    |  1987|     48.86533| lifeExp |  44.55500|
| Niger                    | Africa    |  1992|     48.86533| lifeExp |  47.39100|
| Niger                    | Africa    |  1997|     48.86533| lifeExp |  51.31300|
| Niger                    | Africa    |  2002|     48.86533| lifeExp |  54.49600|
| Niger                    | Africa    |  2007|     48.86533| lifeExp |  56.86700|
| Nigeria                  | Africa    |  1952|     48.86533| lifeExp |  36.32400|
| Nigeria                  | Africa    |  1957|     48.86533| lifeExp |  37.80200|
| Nigeria                  | Africa    |  1962|     48.86533| lifeExp |  39.36000|
| Nigeria                  | Africa    |  1967|     48.86533| lifeExp |  41.04000|
| Nigeria                  | Africa    |  1972|     48.86533| lifeExp |  42.82100|
| Nigeria                  | Africa    |  1977|     48.86533| lifeExp |  44.51400|
| Nigeria                  | Africa    |  1982|     48.86533| lifeExp |  45.82600|
| Nigeria                  | Africa    |  1987|     48.86533| lifeExp |  46.88600|
| Nigeria                  | Africa    |  1992|     48.86533| lifeExp |  47.47200|
| Nigeria                  | Africa    |  1997|     48.86533| lifeExp |  47.46400|
| Nigeria                  | Africa    |  2002|     48.86533| lifeExp |  46.60800|
| Nigeria                  | Africa    |  2007|     48.86533| lifeExp |  46.85900|
| Norway                   | Europe    |  1952|     71.90369| lifeExp |  72.67000|
| Norway                   | Europe    |  1957|     71.90369| lifeExp |  73.44000|
| Norway                   | Europe    |  1962|     71.90369| lifeExp |  73.47000|
| Norway                   | Europe    |  1967|     71.90369| lifeExp |  74.08000|
| Norway                   | Europe    |  1972|     71.90369| lifeExp |  74.34000|
| Norway                   | Europe    |  1977|     71.90369| lifeExp |  75.37000|
| Norway                   | Europe    |  1982|     71.90369| lifeExp |  75.97000|
| Norway                   | Europe    |  1987|     71.90369| lifeExp |  75.89000|
| Norway                   | Europe    |  1992|     71.90369| lifeExp |  77.32000|
| Norway                   | Europe    |  1997|     71.90369| lifeExp |  78.32000|
| Norway                   | Europe    |  2002|     71.90369| lifeExp |  79.05000|
| Norway                   | Europe    |  2007|     71.90369| lifeExp |  80.19600|
| Oman                     | Asia      |  1952|     60.06490| lifeExp |  37.57800|
| Oman                     | Asia      |  1957|     60.06490| lifeExp |  40.08000|
| Oman                     | Asia      |  1962|     60.06490| lifeExp |  43.16500|
| Oman                     | Asia      |  1967|     60.06490| lifeExp |  46.98800|
| Oman                     | Asia      |  1972|     60.06490| lifeExp |  52.14300|
| Oman                     | Asia      |  1977|     60.06490| lifeExp |  57.36700|
| Oman                     | Asia      |  1982|     60.06490| lifeExp |  62.72800|
| Oman                     | Asia      |  1987|     60.06490| lifeExp |  67.73400|
| Oman                     | Asia      |  1992|     60.06490| lifeExp |  71.19700|
| Oman                     | Asia      |  1997|     60.06490| lifeExp |  72.49900|
| Oman                     | Asia      |  2002|     60.06490| lifeExp |  74.19300|
| Oman                     | Asia      |  2007|     60.06490| lifeExp |  75.64000|
| Pakistan                 | Asia      |  1952|     60.06490| lifeExp |  43.43600|
| Pakistan                 | Asia      |  1957|     60.06490| lifeExp |  45.55700|
| Pakistan                 | Asia      |  1962|     60.06490| lifeExp |  47.67000|
| Pakistan                 | Asia      |  1967|     60.06490| lifeExp |  49.80000|
| Pakistan                 | Asia      |  1972|     60.06490| lifeExp |  51.92900|
| Pakistan                 | Asia      |  1977|     60.06490| lifeExp |  54.04300|
| Pakistan                 | Asia      |  1982|     60.06490| lifeExp |  56.15800|
| Pakistan                 | Asia      |  1987|     60.06490| lifeExp |  58.24500|
| Pakistan                 | Asia      |  1992|     60.06490| lifeExp |  60.83800|
| Pakistan                 | Asia      |  1997|     60.06490| lifeExp |  61.81800|
| Pakistan                 | Asia      |  2002|     60.06490| lifeExp |  63.61000|
| Pakistan                 | Asia      |  2007|     60.06490| lifeExp |  65.48300|
| Panama                   | Americas  |  1952|     64.65874| lifeExp |  55.19100|
| Panama                   | Americas  |  1957|     64.65874| lifeExp |  59.20100|
| Panama                   | Americas  |  1962|     64.65874| lifeExp |  61.81700|
| Panama                   | Americas  |  1967|     64.65874| lifeExp |  64.07100|
| Panama                   | Americas  |  1972|     64.65874| lifeExp |  66.21600|
| Panama                   | Americas  |  1977|     64.65874| lifeExp |  68.68100|
| Panama                   | Americas  |  1982|     64.65874| lifeExp |  70.47200|
| Panama                   | Americas  |  1987|     64.65874| lifeExp |  71.52300|
| Panama                   | Americas  |  1992|     64.65874| lifeExp |  72.46200|
| Panama                   | Americas  |  1997|     64.65874| lifeExp |  73.73800|
| Panama                   | Americas  |  2002|     64.65874| lifeExp |  74.71200|
| Panama                   | Americas  |  2007|     64.65874| lifeExp |  75.53700|
| Paraguay                 | Americas  |  1952|     64.65874| lifeExp |  62.64900|
| Paraguay                 | Americas  |  1957|     64.65874| lifeExp |  63.19600|
| Paraguay                 | Americas  |  1962|     64.65874| lifeExp |  64.36100|
| Paraguay                 | Americas  |  1967|     64.65874| lifeExp |  64.95100|
| Paraguay                 | Americas  |  1972|     64.65874| lifeExp |  65.81500|
| Paraguay                 | Americas  |  1977|     64.65874| lifeExp |  66.35300|
| Paraguay                 | Americas  |  1982|     64.65874| lifeExp |  66.87400|
| Paraguay                 | Americas  |  1987|     64.65874| lifeExp |  67.37800|
| Paraguay                 | Americas  |  1992|     64.65874| lifeExp |  68.22500|
| Paraguay                 | Americas  |  1997|     64.65874| lifeExp |  69.40000|
| Paraguay                 | Americas  |  2002|     64.65874| lifeExp |  70.75500|
| Paraguay                 | Americas  |  2007|     64.65874| lifeExp |  71.75200|
| Peru                     | Americas  |  1952|     64.65874| lifeExp |  43.90200|
| Peru                     | Americas  |  1957|     64.65874| lifeExp |  46.26300|
| Peru                     | Americas  |  1962|     64.65874| lifeExp |  49.09600|
| Peru                     | Americas  |  1967|     64.65874| lifeExp |  51.44500|
| Peru                     | Americas  |  1972|     64.65874| lifeExp |  55.44800|
| Peru                     | Americas  |  1977|     64.65874| lifeExp |  58.44700|
| Peru                     | Americas  |  1982|     64.65874| lifeExp |  61.40600|
| Peru                     | Americas  |  1987|     64.65874| lifeExp |  64.13400|
| Peru                     | Americas  |  1992|     64.65874| lifeExp |  66.45800|
| Peru                     | Americas  |  1997|     64.65874| lifeExp |  68.38600|
| Peru                     | Americas  |  2002|     64.65874| lifeExp |  69.90600|
| Peru                     | Americas  |  2007|     64.65874| lifeExp |  71.42100|
| Philippines              | Asia      |  1952|     60.06490| lifeExp |  47.75200|
| Philippines              | Asia      |  1957|     60.06490| lifeExp |  51.33400|
| Philippines              | Asia      |  1962|     60.06490| lifeExp |  54.75700|
| Philippines              | Asia      |  1967|     60.06490| lifeExp |  56.39300|
| Philippines              | Asia      |  1972|     60.06490| lifeExp |  58.06500|
| Philippines              | Asia      |  1977|     60.06490| lifeExp |  60.06000|
| Philippines              | Asia      |  1982|     60.06490| lifeExp |  62.08200|
| Philippines              | Asia      |  1987|     60.06490| lifeExp |  64.15100|
| Philippines              | Asia      |  1992|     60.06490| lifeExp |  66.45800|
| Philippines              | Asia      |  1997|     60.06490| lifeExp |  68.56400|
| Philippines              | Asia      |  2002|     60.06490| lifeExp |  70.30300|
| Philippines              | Asia      |  2007|     60.06490| lifeExp |  71.68800|
| Poland                   | Europe    |  1952|     71.90369| lifeExp |  61.31000|
| Poland                   | Europe    |  1957|     71.90369| lifeExp |  65.77000|
| Poland                   | Europe    |  1962|     71.90369| lifeExp |  67.64000|
| Poland                   | Europe    |  1967|     71.90369| lifeExp |  69.61000|
| Poland                   | Europe    |  1972|     71.90369| lifeExp |  70.85000|
| Poland                   | Europe    |  1977|     71.90369| lifeExp |  70.67000|
| Poland                   | Europe    |  1982|     71.90369| lifeExp |  71.32000|
| Poland                   | Europe    |  1987|     71.90369| lifeExp |  70.98000|
| Poland                   | Europe    |  1992|     71.90369| lifeExp |  70.99000|
| Poland                   | Europe    |  1997|     71.90369| lifeExp |  72.75000|
| Poland                   | Europe    |  2002|     71.90369| lifeExp |  74.67000|
| Poland                   | Europe    |  2007|     71.90369| lifeExp |  75.56300|
| Portugal                 | Europe    |  1952|     71.90369| lifeExp |  59.82000|
| Portugal                 | Europe    |  1957|     71.90369| lifeExp |  61.51000|
| Portugal                 | Europe    |  1962|     71.90369| lifeExp |  64.39000|
| Portugal                 | Europe    |  1967|     71.90369| lifeExp |  66.60000|
| Portugal                 | Europe    |  1972|     71.90369| lifeExp |  69.26000|
| Portugal                 | Europe    |  1977|     71.90369| lifeExp |  70.41000|
| Portugal                 | Europe    |  1982|     71.90369| lifeExp |  72.77000|
| Portugal                 | Europe    |  1987|     71.90369| lifeExp |  74.06000|
| Portugal                 | Europe    |  1992|     71.90369| lifeExp |  74.86000|
| Portugal                 | Europe    |  1997|     71.90369| lifeExp |  75.97000|
| Portugal                 | Europe    |  2002|     71.90369| lifeExp |  77.29000|
| Portugal                 | Europe    |  2007|     71.90369| lifeExp |  78.09800|
| Puerto Rico              | Americas  |  1952|     64.65874| lifeExp |  64.28000|
| Puerto Rico              | Americas  |  1957|     64.65874| lifeExp |  68.54000|
| Puerto Rico              | Americas  |  1962|     64.65874| lifeExp |  69.62000|
| Puerto Rico              | Americas  |  1967|     64.65874| lifeExp |  71.10000|
| Puerto Rico              | Americas  |  1972|     64.65874| lifeExp |  72.16000|
| Puerto Rico              | Americas  |  1977|     64.65874| lifeExp |  73.44000|
| Puerto Rico              | Americas  |  1982|     64.65874| lifeExp |  73.75000|
| Puerto Rico              | Americas  |  1987|     64.65874| lifeExp |  74.63000|
| Puerto Rico              | Americas  |  1992|     64.65874| lifeExp |  73.91100|
| Puerto Rico              | Americas  |  1997|     64.65874| lifeExp |  74.91700|
| Puerto Rico              | Americas  |  2002|     64.65874| lifeExp |  77.77800|
| Puerto Rico              | Americas  |  2007|     64.65874| lifeExp |  78.74600|
| Reunion                  | Africa    |  1952|     48.86533| lifeExp |  52.72400|
| Reunion                  | Africa    |  1957|     48.86533| lifeExp |  55.09000|
| Reunion                  | Africa    |  1962|     48.86533| lifeExp |  57.66600|
| Reunion                  | Africa    |  1967|     48.86533| lifeExp |  60.54200|
| Reunion                  | Africa    |  1972|     48.86533| lifeExp |  64.27400|
| Reunion                  | Africa    |  1977|     48.86533| lifeExp |  67.06400|
| Reunion                  | Africa    |  1982|     48.86533| lifeExp |  69.88500|
| Reunion                  | Africa    |  1987|     48.86533| lifeExp |  71.91300|
| Reunion                  | Africa    |  1992|     48.86533| lifeExp |  73.61500|
| Reunion                  | Africa    |  1997|     48.86533| lifeExp |  74.77200|
| Reunion                  | Africa    |  2002|     48.86533| lifeExp |  75.74400|
| Reunion                  | Africa    |  2007|     48.86533| lifeExp |  76.44200|
| Romania                  | Europe    |  1952|     71.90369| lifeExp |  61.05000|
| Romania                  | Europe    |  1957|     71.90369| lifeExp |  64.10000|
| Romania                  | Europe    |  1962|     71.90369| lifeExp |  66.80000|
| Romania                  | Europe    |  1967|     71.90369| lifeExp |  66.80000|
| Romania                  | Europe    |  1972|     71.90369| lifeExp |  69.21000|
| Romania                  | Europe    |  1977|     71.90369| lifeExp |  69.46000|
| Romania                  | Europe    |  1982|     71.90369| lifeExp |  69.66000|
| Romania                  | Europe    |  1987|     71.90369| lifeExp |  69.53000|
| Romania                  | Europe    |  1992|     71.90369| lifeExp |  69.36000|
| Romania                  | Europe    |  1997|     71.90369| lifeExp |  69.72000|
| Romania                  | Europe    |  2002|     71.90369| lifeExp |  71.32200|
| Romania                  | Europe    |  2007|     71.90369| lifeExp |  72.47600|
| Rwanda                   | Africa    |  1952|     48.86533| lifeExp |  40.00000|
| Rwanda                   | Africa    |  1957|     48.86533| lifeExp |  41.50000|
| Rwanda                   | Africa    |  1962|     48.86533| lifeExp |  43.00000|
| Rwanda                   | Africa    |  1967|     48.86533| lifeExp |  44.10000|
| Rwanda                   | Africa    |  1972|     48.86533| lifeExp |  44.60000|
| Rwanda                   | Africa    |  1977|     48.86533| lifeExp |  45.00000|
| Rwanda                   | Africa    |  1982|     48.86533| lifeExp |  46.21800|
| Rwanda                   | Africa    |  1987|     48.86533| lifeExp |  44.02000|
| Rwanda                   | Africa    |  1992|     48.86533| lifeExp |  23.59900|
| Rwanda                   | Africa    |  1997|     48.86533| lifeExp |  36.08700|
| Rwanda                   | Africa    |  2002|     48.86533| lifeExp |  43.41300|
| Rwanda                   | Africa    |  2007|     48.86533| lifeExp |  46.24200|
| Sao Tome and Principe    | Africa    |  1952|     48.86533| lifeExp |  46.47100|
| Sao Tome and Principe    | Africa    |  1957|     48.86533| lifeExp |  48.94500|
| Sao Tome and Principe    | Africa    |  1962|     48.86533| lifeExp |  51.89300|
| Sao Tome and Principe    | Africa    |  1967|     48.86533| lifeExp |  54.42500|
| Sao Tome and Principe    | Africa    |  1972|     48.86533| lifeExp |  56.48000|
| Sao Tome and Principe    | Africa    |  1977|     48.86533| lifeExp |  58.55000|
| Sao Tome and Principe    | Africa    |  1982|     48.86533| lifeExp |  60.35100|
| Sao Tome and Principe    | Africa    |  1987|     48.86533| lifeExp |  61.72800|
| Sao Tome and Principe    | Africa    |  1992|     48.86533| lifeExp |  62.74200|
| Sao Tome and Principe    | Africa    |  1997|     48.86533| lifeExp |  63.30600|
| Sao Tome and Principe    | Africa    |  2002|     48.86533| lifeExp |  64.33700|
| Sao Tome and Principe    | Africa    |  2007|     48.86533| lifeExp |  65.52800|
| Saudi Arabia             | Asia      |  1952|     60.06490| lifeExp |  39.87500|
| Saudi Arabia             | Asia      |  1957|     60.06490| lifeExp |  42.86800|
| Saudi Arabia             | Asia      |  1962|     60.06490| lifeExp |  45.91400|
| Saudi Arabia             | Asia      |  1967|     60.06490| lifeExp |  49.90100|
| Saudi Arabia             | Asia      |  1972|     60.06490| lifeExp |  53.88600|
| Saudi Arabia             | Asia      |  1977|     60.06490| lifeExp |  58.69000|
| Saudi Arabia             | Asia      |  1982|     60.06490| lifeExp |  63.01200|
| Saudi Arabia             | Asia      |  1987|     60.06490| lifeExp |  66.29500|
| Saudi Arabia             | Asia      |  1992|     60.06490| lifeExp |  68.76800|
| Saudi Arabia             | Asia      |  1997|     60.06490| lifeExp |  70.53300|
| Saudi Arabia             | Asia      |  2002|     60.06490| lifeExp |  71.62600|
| Saudi Arabia             | Asia      |  2007|     60.06490| lifeExp |  72.77700|
| Senegal                  | Africa    |  1952|     48.86533| lifeExp |  37.27800|
| Senegal                  | Africa    |  1957|     48.86533| lifeExp |  39.32900|
| Senegal                  | Africa    |  1962|     48.86533| lifeExp |  41.45400|
| Senegal                  | Africa    |  1967|     48.86533| lifeExp |  43.56300|
| Senegal                  | Africa    |  1972|     48.86533| lifeExp |  45.81500|
| Senegal                  | Africa    |  1977|     48.86533| lifeExp |  48.87900|
| Senegal                  | Africa    |  1982|     48.86533| lifeExp |  52.37900|
| Senegal                  | Africa    |  1987|     48.86533| lifeExp |  55.76900|
| Senegal                  | Africa    |  1992|     48.86533| lifeExp |  58.19600|
| Senegal                  | Africa    |  1997|     48.86533| lifeExp |  60.18700|
| Senegal                  | Africa    |  2002|     48.86533| lifeExp |  61.60000|
| Senegal                  | Africa    |  2007|     48.86533| lifeExp |  63.06200|
| Serbia                   | Europe    |  1952|     71.90369| lifeExp |  57.99600|
| Serbia                   | Europe    |  1957|     71.90369| lifeExp |  61.68500|
| Serbia                   | Europe    |  1962|     71.90369| lifeExp |  64.53100|
| Serbia                   | Europe    |  1967|     71.90369| lifeExp |  66.91400|
| Serbia                   | Europe    |  1972|     71.90369| lifeExp |  68.70000|
| Serbia                   | Europe    |  1977|     71.90369| lifeExp |  70.30000|
| Serbia                   | Europe    |  1982|     71.90369| lifeExp |  70.16200|
| Serbia                   | Europe    |  1987|     71.90369| lifeExp |  71.21800|
| Serbia                   | Europe    |  1992|     71.90369| lifeExp |  71.65900|
| Serbia                   | Europe    |  1997|     71.90369| lifeExp |  72.23200|
| Serbia                   | Europe    |  2002|     71.90369| lifeExp |  73.21300|
| Serbia                   | Europe    |  2007|     71.90369| lifeExp |  74.00200|
| Sierra Leone             | Africa    |  1952|     48.86533| lifeExp |  30.33100|
| Sierra Leone             | Africa    |  1957|     48.86533| lifeExp |  31.57000|
| Sierra Leone             | Africa    |  1962|     48.86533| lifeExp |  32.76700|
| Sierra Leone             | Africa    |  1967|     48.86533| lifeExp |  34.11300|
| Sierra Leone             | Africa    |  1972|     48.86533| lifeExp |  35.40000|
| Sierra Leone             | Africa    |  1977|     48.86533| lifeExp |  36.78800|
| Sierra Leone             | Africa    |  1982|     48.86533| lifeExp |  38.44500|
| Sierra Leone             | Africa    |  1987|     48.86533| lifeExp |  40.00600|
| Sierra Leone             | Africa    |  1992|     48.86533| lifeExp |  38.33300|
| Sierra Leone             | Africa    |  1997|     48.86533| lifeExp |  39.89700|
| Sierra Leone             | Africa    |  2002|     48.86533| lifeExp |  41.01200|
| Sierra Leone             | Africa    |  2007|     48.86533| lifeExp |  42.56800|
| Singapore                | Asia      |  1952|     60.06490| lifeExp |  60.39600|
| Singapore                | Asia      |  1957|     60.06490| lifeExp |  63.17900|
| Singapore                | Asia      |  1962|     60.06490| lifeExp |  65.79800|
| Singapore                | Asia      |  1967|     60.06490| lifeExp |  67.94600|
| Singapore                | Asia      |  1972|     60.06490| lifeExp |  69.52100|
| Singapore                | Asia      |  1977|     60.06490| lifeExp |  70.79500|
| Singapore                | Asia      |  1982|     60.06490| lifeExp |  71.76000|
| Singapore                | Asia      |  1987|     60.06490| lifeExp |  73.56000|
| Singapore                | Asia      |  1992|     60.06490| lifeExp |  75.78800|
| Singapore                | Asia      |  1997|     60.06490| lifeExp |  77.15800|
| Singapore                | Asia      |  2002|     60.06490| lifeExp |  78.77000|
| Singapore                | Asia      |  2007|     60.06490| lifeExp |  79.97200|
| Slovak Republic          | Europe    |  1952|     71.90369| lifeExp |  64.36000|
| Slovak Republic          | Europe    |  1957|     71.90369| lifeExp |  67.45000|
| Slovak Republic          | Europe    |  1962|     71.90369| lifeExp |  70.33000|
| Slovak Republic          | Europe    |  1967|     71.90369| lifeExp |  70.98000|
| Slovak Republic          | Europe    |  1972|     71.90369| lifeExp |  70.35000|
| Slovak Republic          | Europe    |  1977|     71.90369| lifeExp |  70.45000|
| Slovak Republic          | Europe    |  1982|     71.90369| lifeExp |  70.80000|
| Slovak Republic          | Europe    |  1987|     71.90369| lifeExp |  71.08000|
| Slovak Republic          | Europe    |  1992|     71.90369| lifeExp |  71.38000|
| Slovak Republic          | Europe    |  1997|     71.90369| lifeExp |  72.71000|
| Slovak Republic          | Europe    |  2002|     71.90369| lifeExp |  73.80000|
| Slovak Republic          | Europe    |  2007|     71.90369| lifeExp |  74.66300|
| Slovenia                 | Europe    |  1952|     71.90369| lifeExp |  65.57000|
| Slovenia                 | Europe    |  1957|     71.90369| lifeExp |  67.85000|
| Slovenia                 | Europe    |  1962|     71.90369| lifeExp |  69.15000|
| Slovenia                 | Europe    |  1967|     71.90369| lifeExp |  69.18000|
| Slovenia                 | Europe    |  1972|     71.90369| lifeExp |  69.82000|
| Slovenia                 | Europe    |  1977|     71.90369| lifeExp |  70.97000|
| Slovenia                 | Europe    |  1982|     71.90369| lifeExp |  71.06300|
| Slovenia                 | Europe    |  1987|     71.90369| lifeExp |  72.25000|
| Slovenia                 | Europe    |  1992|     71.90369| lifeExp |  73.64000|
| Slovenia                 | Europe    |  1997|     71.90369| lifeExp |  75.13000|
| Slovenia                 | Europe    |  2002|     71.90369| lifeExp |  76.66000|
| Slovenia                 | Europe    |  2007|     71.90369| lifeExp |  77.92600|
| Somalia                  | Africa    |  1952|     48.86533| lifeExp |  32.97800|
| Somalia                  | Africa    |  1957|     48.86533| lifeExp |  34.97700|
| Somalia                  | Africa    |  1962|     48.86533| lifeExp |  36.98100|
| Somalia                  | Africa    |  1967|     48.86533| lifeExp |  38.97700|
| Somalia                  | Africa    |  1972|     48.86533| lifeExp |  40.97300|
| Somalia                  | Africa    |  1977|     48.86533| lifeExp |  41.97400|
| Somalia                  | Africa    |  1982|     48.86533| lifeExp |  42.95500|
| Somalia                  | Africa    |  1987|     48.86533| lifeExp |  44.50100|
| Somalia                  | Africa    |  1992|     48.86533| lifeExp |  39.65800|
| Somalia                  | Africa    |  1997|     48.86533| lifeExp |  43.79500|
| Somalia                  | Africa    |  2002|     48.86533| lifeExp |  45.93600|
| Somalia                  | Africa    |  2007|     48.86533| lifeExp |  48.15900|
| South Africa             | Africa    |  1952|     48.86533| lifeExp |  45.00900|
| South Africa             | Africa    |  1957|     48.86533| lifeExp |  47.98500|
| South Africa             | Africa    |  1962|     48.86533| lifeExp |  49.95100|
| South Africa             | Africa    |  1967|     48.86533| lifeExp |  51.92700|
| South Africa             | Africa    |  1972|     48.86533| lifeExp |  53.69600|
| South Africa             | Africa    |  1977|     48.86533| lifeExp |  55.52700|
| South Africa             | Africa    |  1982|     48.86533| lifeExp |  58.16100|
| South Africa             | Africa    |  1987|     48.86533| lifeExp |  60.83400|
| South Africa             | Africa    |  1992|     48.86533| lifeExp |  61.88800|
| South Africa             | Africa    |  1997|     48.86533| lifeExp |  60.23600|
| South Africa             | Africa    |  2002|     48.86533| lifeExp |  53.36500|
| South Africa             | Africa    |  2007|     48.86533| lifeExp |  49.33900|
| Spain                    | Europe    |  1952|     71.90369| lifeExp |  64.94000|
| Spain                    | Europe    |  1957|     71.90369| lifeExp |  66.66000|
| Spain                    | Europe    |  1962|     71.90369| lifeExp |  69.69000|
| Spain                    | Europe    |  1967|     71.90369| lifeExp |  71.44000|
| Spain                    | Europe    |  1972|     71.90369| lifeExp |  73.06000|
| Spain                    | Europe    |  1977|     71.90369| lifeExp |  74.39000|
| Spain                    | Europe    |  1982|     71.90369| lifeExp |  76.30000|
| Spain                    | Europe    |  1987|     71.90369| lifeExp |  76.90000|
| Spain                    | Europe    |  1992|     71.90369| lifeExp |  77.57000|
| Spain                    | Europe    |  1997|     71.90369| lifeExp |  78.77000|
| Spain                    | Europe    |  2002|     71.90369| lifeExp |  79.78000|
| Spain                    | Europe    |  2007|     71.90369| lifeExp |  80.94100|
| Sri Lanka                | Asia      |  1952|     60.06490| lifeExp |  57.59300|
| Sri Lanka                | Asia      |  1957|     60.06490| lifeExp |  61.45600|
| Sri Lanka                | Asia      |  1962|     60.06490| lifeExp |  62.19200|
| Sri Lanka                | Asia      |  1967|     60.06490| lifeExp |  64.26600|
| Sri Lanka                | Asia      |  1972|     60.06490| lifeExp |  65.04200|
| Sri Lanka                | Asia      |  1977|     60.06490| lifeExp |  65.94900|
| Sri Lanka                | Asia      |  1982|     60.06490| lifeExp |  68.75700|
| Sri Lanka                | Asia      |  1987|     60.06490| lifeExp |  69.01100|
| Sri Lanka                | Asia      |  1992|     60.06490| lifeExp |  70.37900|
| Sri Lanka                | Asia      |  1997|     60.06490| lifeExp |  70.45700|
| Sri Lanka                | Asia      |  2002|     60.06490| lifeExp |  70.81500|
| Sri Lanka                | Asia      |  2007|     60.06490| lifeExp |  72.39600|
| Sudan                    | Africa    |  1952|     48.86533| lifeExp |  38.63500|
| Sudan                    | Africa    |  1957|     48.86533| lifeExp |  39.62400|
| Sudan                    | Africa    |  1962|     48.86533| lifeExp |  40.87000|
| Sudan                    | Africa    |  1967|     48.86533| lifeExp |  42.85800|
| Sudan                    | Africa    |  1972|     48.86533| lifeExp |  45.08300|
| Sudan                    | Africa    |  1977|     48.86533| lifeExp |  47.80000|
| Sudan                    | Africa    |  1982|     48.86533| lifeExp |  50.33800|
| Sudan                    | Africa    |  1987|     48.86533| lifeExp |  51.74400|
| Sudan                    | Africa    |  1992|     48.86533| lifeExp |  53.55600|
| Sudan                    | Africa    |  1997|     48.86533| lifeExp |  55.37300|
| Sudan                    | Africa    |  2002|     48.86533| lifeExp |  56.36900|
| Sudan                    | Africa    |  2007|     48.86533| lifeExp |  58.55600|
| Swaziland                | Africa    |  1952|     48.86533| lifeExp |  41.40700|
| Swaziland                | Africa    |  1957|     48.86533| lifeExp |  43.42400|
| Swaziland                | Africa    |  1962|     48.86533| lifeExp |  44.99200|
| Swaziland                | Africa    |  1967|     48.86533| lifeExp |  46.63300|
| Swaziland                | Africa    |  1972|     48.86533| lifeExp |  49.55200|
| Swaziland                | Africa    |  1977|     48.86533| lifeExp |  52.53700|
| Swaziland                | Africa    |  1982|     48.86533| lifeExp |  55.56100|
| Swaziland                | Africa    |  1987|     48.86533| lifeExp |  57.67800|
| Swaziland                | Africa    |  1992|     48.86533| lifeExp |  58.47400|
| Swaziland                | Africa    |  1997|     48.86533| lifeExp |  54.28900|
| Swaziland                | Africa    |  2002|     48.86533| lifeExp |  43.86900|
| Swaziland                | Africa    |  2007|     48.86533| lifeExp |  39.61300|
| Sweden                   | Europe    |  1952|     71.90369| lifeExp |  71.86000|
| Sweden                   | Europe    |  1957|     71.90369| lifeExp |  72.49000|
| Sweden                   | Europe    |  1962|     71.90369| lifeExp |  73.37000|
| Sweden                   | Europe    |  1967|     71.90369| lifeExp |  74.16000|
| Sweden                   | Europe    |  1972|     71.90369| lifeExp |  74.72000|
| Sweden                   | Europe    |  1977|     71.90369| lifeExp |  75.44000|
| Sweden                   | Europe    |  1982|     71.90369| lifeExp |  76.42000|
| Sweden                   | Europe    |  1987|     71.90369| lifeExp |  77.19000|
| Sweden                   | Europe    |  1992|     71.90369| lifeExp |  78.16000|
| Sweden                   | Europe    |  1997|     71.90369| lifeExp |  79.39000|
| Sweden                   | Europe    |  2002|     71.90369| lifeExp |  80.04000|
| Sweden                   | Europe    |  2007|     71.90369| lifeExp |  80.88400|
| Switzerland              | Europe    |  1952|     71.90369| lifeExp |  69.62000|
| Switzerland              | Europe    |  1957|     71.90369| lifeExp |  70.56000|
| Switzerland              | Europe    |  1962|     71.90369| lifeExp |  71.32000|
| Switzerland              | Europe    |  1967|     71.90369| lifeExp |  72.77000|
| Switzerland              | Europe    |  1972|     71.90369| lifeExp |  73.78000|
| Switzerland              | Europe    |  1977|     71.90369| lifeExp |  75.39000|
| Switzerland              | Europe    |  1982|     71.90369| lifeExp |  76.21000|
| Switzerland              | Europe    |  1987|     71.90369| lifeExp |  77.41000|
| Switzerland              | Europe    |  1992|     71.90369| lifeExp |  78.03000|
| Switzerland              | Europe    |  1997|     71.90369| lifeExp |  79.37000|
| Switzerland              | Europe    |  2002|     71.90369| lifeExp |  80.62000|
| Switzerland              | Europe    |  2007|     71.90369| lifeExp |  81.70100|
| Syria                    | Asia      |  1952|     60.06490| lifeExp |  45.88300|
| Syria                    | Asia      |  1957|     60.06490| lifeExp |  48.28400|
| Syria                    | Asia      |  1962|     60.06490| lifeExp |  50.30500|
| Syria                    | Asia      |  1967|     60.06490| lifeExp |  53.65500|
| Syria                    | Asia      |  1972|     60.06490| lifeExp |  57.29600|
| Syria                    | Asia      |  1977|     60.06490| lifeExp |  61.19500|
| Syria                    | Asia      |  1982|     60.06490| lifeExp |  64.59000|
| Syria                    | Asia      |  1987|     60.06490| lifeExp |  66.97400|
| Syria                    | Asia      |  1992|     60.06490| lifeExp |  69.24900|
| Syria                    | Asia      |  1997|     60.06490| lifeExp |  71.52700|
| Syria                    | Asia      |  2002|     60.06490| lifeExp |  73.05300|
| Syria                    | Asia      |  2007|     60.06490| lifeExp |  74.14300|
| Taiwan                   | Asia      |  1952|     60.06490| lifeExp |  58.50000|
| Taiwan                   | Asia      |  1957|     60.06490| lifeExp |  62.40000|
| Taiwan                   | Asia      |  1962|     60.06490| lifeExp |  65.20000|
| Taiwan                   | Asia      |  1967|     60.06490| lifeExp |  67.50000|
| Taiwan                   | Asia      |  1972|     60.06490| lifeExp |  69.39000|
| Taiwan                   | Asia      |  1977|     60.06490| lifeExp |  70.59000|
| Taiwan                   | Asia      |  1982|     60.06490| lifeExp |  72.16000|
| Taiwan                   | Asia      |  1987|     60.06490| lifeExp |  73.40000|
| Taiwan                   | Asia      |  1992|     60.06490| lifeExp |  74.26000|
| Taiwan                   | Asia      |  1997|     60.06490| lifeExp |  75.25000|
| Taiwan                   | Asia      |  2002|     60.06490| lifeExp |  76.99000|
| Taiwan                   | Asia      |  2007|     60.06490| lifeExp |  78.40000|
| Tanzania                 | Africa    |  1952|     48.86533| lifeExp |  41.21500|
| Tanzania                 | Africa    |  1957|     48.86533| lifeExp |  42.97400|
| Tanzania                 | Africa    |  1962|     48.86533| lifeExp |  44.24600|
| Tanzania                 | Africa    |  1967|     48.86533| lifeExp |  45.75700|
| Tanzania                 | Africa    |  1972|     48.86533| lifeExp |  47.62000|
| Tanzania                 | Africa    |  1977|     48.86533| lifeExp |  49.91900|
| Tanzania                 | Africa    |  1982|     48.86533| lifeExp |  50.60800|
| Tanzania                 | Africa    |  1987|     48.86533| lifeExp |  51.53500|
| Tanzania                 | Africa    |  1992|     48.86533| lifeExp |  50.44000|
| Tanzania                 | Africa    |  1997|     48.86533| lifeExp |  48.46600|
| Tanzania                 | Africa    |  2002|     48.86533| lifeExp |  49.65100|
| Tanzania                 | Africa    |  2007|     48.86533| lifeExp |  52.51700|
| Thailand                 | Asia      |  1952|     60.06490| lifeExp |  50.84800|
| Thailand                 | Asia      |  1957|     60.06490| lifeExp |  53.63000|
| Thailand                 | Asia      |  1962|     60.06490| lifeExp |  56.06100|
| Thailand                 | Asia      |  1967|     60.06490| lifeExp |  58.28500|
| Thailand                 | Asia      |  1972|     60.06490| lifeExp |  60.40500|
| Thailand                 | Asia      |  1977|     60.06490| lifeExp |  62.49400|
| Thailand                 | Asia      |  1982|     60.06490| lifeExp |  64.59700|
| Thailand                 | Asia      |  1987|     60.06490| lifeExp |  66.08400|
| Thailand                 | Asia      |  1992|     60.06490| lifeExp |  67.29800|
| Thailand                 | Asia      |  1997|     60.06490| lifeExp |  67.52100|
| Thailand                 | Asia      |  2002|     60.06490| lifeExp |  68.56400|
| Thailand                 | Asia      |  2007|     60.06490| lifeExp |  70.61600|
| Togo                     | Africa    |  1952|     48.86533| lifeExp |  38.59600|
| Togo                     | Africa    |  1957|     48.86533| lifeExp |  41.20800|
| Togo                     | Africa    |  1962|     48.86533| lifeExp |  43.92200|
| Togo                     | Africa    |  1967|     48.86533| lifeExp |  46.76900|
| Togo                     | Africa    |  1972|     48.86533| lifeExp |  49.75900|
| Togo                     | Africa    |  1977|     48.86533| lifeExp |  52.88700|
| Togo                     | Africa    |  1982|     48.86533| lifeExp |  55.47100|
| Togo                     | Africa    |  1987|     48.86533| lifeExp |  56.94100|
| Togo                     | Africa    |  1992|     48.86533| lifeExp |  58.06100|
| Togo                     | Africa    |  1997|     48.86533| lifeExp |  58.39000|
| Togo                     | Africa    |  2002|     48.86533| lifeExp |  57.56100|
| Togo                     | Africa    |  2007|     48.86533| lifeExp |  58.42000|
| Trinidad and Tobago      | Americas  |  1952|     64.65874| lifeExp |  59.10000|
| Trinidad and Tobago      | Americas  |  1957|     64.65874| lifeExp |  61.80000|
| Trinidad and Tobago      | Americas  |  1962|     64.65874| lifeExp |  64.90000|
| Trinidad and Tobago      | Americas  |  1967|     64.65874| lifeExp |  65.40000|
| Trinidad and Tobago      | Americas  |  1972|     64.65874| lifeExp |  65.90000|
| Trinidad and Tobago      | Americas  |  1977|     64.65874| lifeExp |  68.30000|
| Trinidad and Tobago      | Americas  |  1982|     64.65874| lifeExp |  68.83200|
| Trinidad and Tobago      | Americas  |  1987|     64.65874| lifeExp |  69.58200|
| Trinidad and Tobago      | Americas  |  1992|     64.65874| lifeExp |  69.86200|
| Trinidad and Tobago      | Americas  |  1997|     64.65874| lifeExp |  69.46500|
| Trinidad and Tobago      | Americas  |  2002|     64.65874| lifeExp |  68.97600|
| Trinidad and Tobago      | Americas  |  2007|     64.65874| lifeExp |  69.81900|
| Tunisia                  | Africa    |  1952|     48.86533| lifeExp |  44.60000|
| Tunisia                  | Africa    |  1957|     48.86533| lifeExp |  47.10000|
| Tunisia                  | Africa    |  1962|     48.86533| lifeExp |  49.57900|
| Tunisia                  | Africa    |  1967|     48.86533| lifeExp |  52.05300|
| Tunisia                  | Africa    |  1972|     48.86533| lifeExp |  55.60200|
| Tunisia                  | Africa    |  1977|     48.86533| lifeExp |  59.83700|
| Tunisia                  | Africa    |  1982|     48.86533| lifeExp |  64.04800|
| Tunisia                  | Africa    |  1987|     48.86533| lifeExp |  66.89400|
| Tunisia                  | Africa    |  1992|     48.86533| lifeExp |  70.00100|
| Tunisia                  | Africa    |  1997|     48.86533| lifeExp |  71.97300|
| Tunisia                  | Africa    |  2002|     48.86533| lifeExp |  73.04200|
| Tunisia                  | Africa    |  2007|     48.86533| lifeExp |  73.92300|
| Turkey                   | Europe    |  1952|     71.90369| lifeExp |  43.58500|
| Turkey                   | Europe    |  1957|     71.90369| lifeExp |  48.07900|
| Turkey                   | Europe    |  1962|     71.90369| lifeExp |  52.09800|
| Turkey                   | Europe    |  1967|     71.90369| lifeExp |  54.33600|
| Turkey                   | Europe    |  1972|     71.90369| lifeExp |  57.00500|
| Turkey                   | Europe    |  1977|     71.90369| lifeExp |  59.50700|
| Turkey                   | Europe    |  1982|     71.90369| lifeExp |  61.03600|
| Turkey                   | Europe    |  1987|     71.90369| lifeExp |  63.10800|
| Turkey                   | Europe    |  1992|     71.90369| lifeExp |  66.14600|
| Turkey                   | Europe    |  1997|     71.90369| lifeExp |  68.83500|
| Turkey                   | Europe    |  2002|     71.90369| lifeExp |  70.84500|
| Turkey                   | Europe    |  2007|     71.90369| lifeExp |  71.77700|
| Uganda                   | Africa    |  1952|     48.86533| lifeExp |  39.97800|
| Uganda                   | Africa    |  1957|     48.86533| lifeExp |  42.57100|
| Uganda                   | Africa    |  1962|     48.86533| lifeExp |  45.34400|
| Uganda                   | Africa    |  1967|     48.86533| lifeExp |  48.05100|
| Uganda                   | Africa    |  1972|     48.86533| lifeExp |  51.01600|
| Uganda                   | Africa    |  1977|     48.86533| lifeExp |  50.35000|
| Uganda                   | Africa    |  1982|     48.86533| lifeExp |  49.84900|
| Uganda                   | Africa    |  1987|     48.86533| lifeExp |  51.50900|
| Uganda                   | Africa    |  1992|     48.86533| lifeExp |  48.82500|
| Uganda                   | Africa    |  1997|     48.86533| lifeExp |  44.57800|
| Uganda                   | Africa    |  2002|     48.86533| lifeExp |  47.81300|
| Uganda                   | Africa    |  2007|     48.86533| lifeExp |  51.54200|
| United Kingdom           | Europe    |  1952|     71.90369| lifeExp |  69.18000|
| United Kingdom           | Europe    |  1957|     71.90369| lifeExp |  70.42000|
| United Kingdom           | Europe    |  1962|     71.90369| lifeExp |  70.76000|
| United Kingdom           | Europe    |  1967|     71.90369| lifeExp |  71.36000|
| United Kingdom           | Europe    |  1972|     71.90369| lifeExp |  72.01000|
| United Kingdom           | Europe    |  1977|     71.90369| lifeExp |  72.76000|
| United Kingdom           | Europe    |  1982|     71.90369| lifeExp |  74.04000|
| United Kingdom           | Europe    |  1987|     71.90369| lifeExp |  75.00700|
| United Kingdom           | Europe    |  1992|     71.90369| lifeExp |  76.42000|
| United Kingdom           | Europe    |  1997|     71.90369| lifeExp |  77.21800|
| United Kingdom           | Europe    |  2002|     71.90369| lifeExp |  78.47100|
| United Kingdom           | Europe    |  2007|     71.90369| lifeExp |  79.42500|
| United States            | Americas  |  1952|     64.65874| lifeExp |  68.44000|
| United States            | Americas  |  1957|     64.65874| lifeExp |  69.49000|
| United States            | Americas  |  1962|     64.65874| lifeExp |  70.21000|
| United States            | Americas  |  1967|     64.65874| lifeExp |  70.76000|
| United States            | Americas  |  1972|     64.65874| lifeExp |  71.34000|
| United States            | Americas  |  1977|     64.65874| lifeExp |  73.38000|
| United States            | Americas  |  1982|     64.65874| lifeExp |  74.65000|
| United States            | Americas  |  1987|     64.65874| lifeExp |  75.02000|
| United States            | Americas  |  1992|     64.65874| lifeExp |  76.09000|
| United States            | Americas  |  1997|     64.65874| lifeExp |  76.81000|
| United States            | Americas  |  2002|     64.65874| lifeExp |  77.31000|
| United States            | Americas  |  2007|     64.65874| lifeExp |  78.24200|
| Uruguay                  | Americas  |  1952|     64.65874| lifeExp |  66.07100|
| Uruguay                  | Americas  |  1957|     64.65874| lifeExp |  67.04400|
| Uruguay                  | Americas  |  1962|     64.65874| lifeExp |  68.25300|
| Uruguay                  | Americas  |  1967|     64.65874| lifeExp |  68.46800|
| Uruguay                  | Americas  |  1972|     64.65874| lifeExp |  68.67300|
| Uruguay                  | Americas  |  1977|     64.65874| lifeExp |  69.48100|
| Uruguay                  | Americas  |  1982|     64.65874| lifeExp |  70.80500|
| Uruguay                  | Americas  |  1987|     64.65874| lifeExp |  71.91800|
| Uruguay                  | Americas  |  1992|     64.65874| lifeExp |  72.75200|
| Uruguay                  | Americas  |  1997|     64.65874| lifeExp |  74.22300|
| Uruguay                  | Americas  |  2002|     64.65874| lifeExp |  75.30700|
| Uruguay                  | Americas  |  2007|     64.65874| lifeExp |  76.38400|
| Venezuela                | Americas  |  1952|     64.65874| lifeExp |  55.08800|
| Venezuela                | Americas  |  1957|     64.65874| lifeExp |  57.90700|
| Venezuela                | Americas  |  1962|     64.65874| lifeExp |  60.77000|
| Venezuela                | Americas  |  1967|     64.65874| lifeExp |  63.47900|
| Venezuela                | Americas  |  1972|     64.65874| lifeExp |  65.71200|
| Venezuela                | Americas  |  1977|     64.65874| lifeExp |  67.45600|
| Venezuela                | Americas  |  1982|     64.65874| lifeExp |  68.55700|
| Venezuela                | Americas  |  1987|     64.65874| lifeExp |  70.19000|
| Venezuela                | Americas  |  1992|     64.65874| lifeExp |  71.15000|
| Venezuela                | Americas  |  1997|     64.65874| lifeExp |  72.14600|
| Venezuela                | Americas  |  2002|     64.65874| lifeExp |  72.76600|
| Venezuela                | Americas  |  2007|     64.65874| lifeExp |  73.74700|
| Vietnam                  | Asia      |  1952|     60.06490| lifeExp |  40.41200|
| Vietnam                  | Asia      |  1957|     60.06490| lifeExp |  42.88700|
| Vietnam                  | Asia      |  1962|     60.06490| lifeExp |  45.36300|
| Vietnam                  | Asia      |  1967|     60.06490| lifeExp |  47.83800|
| Vietnam                  | Asia      |  1972|     60.06490| lifeExp |  50.25400|
| Vietnam                  | Asia      |  1977|     60.06490| lifeExp |  55.76400|
| Vietnam                  | Asia      |  1982|     60.06490| lifeExp |  58.81600|
| Vietnam                  | Asia      |  1987|     60.06490| lifeExp |  62.82000|
| Vietnam                  | Asia      |  1992|     60.06490| lifeExp |  67.66200|
| Vietnam                  | Asia      |  1997|     60.06490| lifeExp |  70.67200|
| Vietnam                  | Asia      |  2002|     60.06490| lifeExp |  73.01700|
| Vietnam                  | Asia      |  2007|     60.06490| lifeExp |  74.24900|
| West Bank and Gaza       | Asia      |  1952|     60.06490| lifeExp |  43.16000|
| West Bank and Gaza       | Asia      |  1957|     60.06490| lifeExp |  45.67100|
| West Bank and Gaza       | Asia      |  1962|     60.06490| lifeExp |  48.12700|
| West Bank and Gaza       | Asia      |  1967|     60.06490| lifeExp |  51.63100|
| West Bank and Gaza       | Asia      |  1972|     60.06490| lifeExp |  56.53200|
| West Bank and Gaza       | Asia      |  1977|     60.06490| lifeExp |  60.76500|
| West Bank and Gaza       | Asia      |  1982|     60.06490| lifeExp |  64.40600|
| West Bank and Gaza       | Asia      |  1987|     60.06490| lifeExp |  67.04600|
| West Bank and Gaza       | Asia      |  1992|     60.06490| lifeExp |  69.71800|
| West Bank and Gaza       | Asia      |  1997|     60.06490| lifeExp |  71.09600|
| West Bank and Gaza       | Asia      |  2002|     60.06490| lifeExp |  72.37000|
| West Bank and Gaza       | Asia      |  2007|     60.06490| lifeExp |  73.42200|
| Yemen, Rep.              | Asia      |  1952|     60.06490| lifeExp |  32.54800|
| Yemen, Rep.              | Asia      |  1957|     60.06490| lifeExp |  33.97000|
| Yemen, Rep.              | Asia      |  1962|     60.06490| lifeExp |  35.18000|
| Yemen, Rep.              | Asia      |  1967|     60.06490| lifeExp |  36.98400|
| Yemen, Rep.              | Asia      |  1972|     60.06490| lifeExp |  39.84800|
| Yemen, Rep.              | Asia      |  1977|     60.06490| lifeExp |  44.17500|
| Yemen, Rep.              | Asia      |  1982|     60.06490| lifeExp |  49.11300|
| Yemen, Rep.              | Asia      |  1987|     60.06490| lifeExp |  52.92200|
| Yemen, Rep.              | Asia      |  1992|     60.06490| lifeExp |  55.59900|
| Yemen, Rep.              | Asia      |  1997|     60.06490| lifeExp |  58.02000|
| Yemen, Rep.              | Asia      |  2002|     60.06490| lifeExp |  60.30800|
| Yemen, Rep.              | Asia      |  2007|     60.06490| lifeExp |  62.69800|
| Zambia                   | Africa    |  1952|     48.86533| lifeExp |  42.03800|
| Zambia                   | Africa    |  1957|     48.86533| lifeExp |  44.07700|
| Zambia                   | Africa    |  1962|     48.86533| lifeExp |  46.02300|
| Zambia                   | Africa    |  1967|     48.86533| lifeExp |  47.76800|
| Zambia                   | Africa    |  1972|     48.86533| lifeExp |  50.10700|
| Zambia                   | Africa    |  1977|     48.86533| lifeExp |  51.38600|
| Zambia                   | Africa    |  1982|     48.86533| lifeExp |  51.82100|
| Zambia                   | Africa    |  1987|     48.86533| lifeExp |  50.82100|
| Zambia                   | Africa    |  1992|     48.86533| lifeExp |  46.10000|
| Zambia                   | Africa    |  1997|     48.86533| lifeExp |  40.23800|
| Zambia                   | Africa    |  2002|     48.86533| lifeExp |  39.19300|
| Zambia                   | Africa    |  2007|     48.86533| lifeExp |  42.38400|
| Zimbabwe                 | Africa    |  1952|     48.86533| lifeExp |  48.45100|
| Zimbabwe                 | Africa    |  1957|     48.86533| lifeExp |  50.46900|
| Zimbabwe                 | Africa    |  1962|     48.86533| lifeExp |  52.35800|
| Zimbabwe                 | Africa    |  1967|     48.86533| lifeExp |  53.99500|
| Zimbabwe                 | Africa    |  1972|     48.86533| lifeExp |  55.63500|
| Zimbabwe                 | Africa    |  1977|     48.86533| lifeExp |  57.67400|
| Zimbabwe                 | Africa    |  1982|     48.86533| lifeExp |  60.36300|
| Zimbabwe                 | Africa    |  1987|     48.86533| lifeExp |  62.35100|
| Zimbabwe                 | Africa    |  1992|     48.86533| lifeExp |  60.37700|
| Zimbabwe                 | Africa    |  1997|     48.86533| lifeExp |  46.80900|
| Zimbabwe                 | Africa    |  2002|     48.86533| lifeExp |  39.98900|
| Zimbabwe                 | Africa    |  2007|     48.86533| lifeExp |  43.48700|

-   Inner Join. *Note: the countries not from our previously mentioned list in WDI will have NA instead of the values.*

``` r
td.ij <- inner_join(td.gapminder,td.wdi,by="country")
```

    ## Warning: Column `country` joining factor and character vector, coercing
    ## into character vector

``` r
knitr::kable(td.ij)
```

| country       | continent |  year.x|  meanLifeExp| measure |   value|  NY.GDP.PCAP.KD|  year.y|
|:--------------|:----------|-------:|------------:|:--------|-------:|---------------:|-------:|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       50231.885|    2016|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       50109.875|    2015|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       50067.043|    2014|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       49355.097|    2013|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       48724.246|    2012|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       48456.965|    2011|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       47447.476|    2010|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       46543.792|    2009|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       48510.568|    2008|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       48552.696|    2007|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       48035.036|    2006|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       47181.562|    2005|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       46170.920|    2004|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       45239.811|    2003|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       44883.828|    2002|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       43964.955|    2001|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       43638.283|    2000|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       41856.046|    1999|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       40131.702|    1998|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       38967.953|    1997|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       37765.732|    1996|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       37569.468|    1995|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       36893.982|    1994|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       35648.478|    1993|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       35108.519|    1992|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       35231.021|    1991|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       36489.266|    1990|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       36981.279|    1989|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       36791.760|    1988|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       35689.034|    1987|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       34737.275|    1986|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       34345.614|    1985|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       33099.374|    1984|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       31549.802|    1983|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       31060.645|    1982|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       32477.296|    1981|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       31769.783|    1980|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       31502.044|    1979|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       30651.633|    1978|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       29783.268|    1977|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       29128.014|    1976|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       28057.048|    1975|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       28080.941|    1974|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       27571.293|    1973|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       26216.591|    1972|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       25262.441|    1971|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       24629.216|    1970|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       24188.426|    1969|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       23294.302|    1968|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       22482.650|    1967|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       22242.419|    1966|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       21260.632|    1965|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       20301.660|    1964|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       19389.156|    1963|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       18780.564|    1962|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       17861.936|    1961|
| Canada        | Americas  |    1952|     64.65874| lifeExp |  68.750|       17664.205|    1960|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       50231.885|    2016|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       50109.875|    2015|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       50067.043|    2014|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       49355.097|    2013|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       48724.246|    2012|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       48456.965|    2011|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       47447.476|    2010|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       46543.792|    2009|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       48510.568|    2008|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       48552.696|    2007|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       48035.036|    2006|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       47181.562|    2005|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       46170.920|    2004|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       45239.811|    2003|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       44883.828|    2002|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       43964.955|    2001|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       43638.283|    2000|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       41856.046|    1999|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       40131.702|    1998|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       38967.953|    1997|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       37765.732|    1996|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       37569.468|    1995|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       36893.982|    1994|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       35648.478|    1993|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       35108.519|    1992|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       35231.021|    1991|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       36489.266|    1990|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       36981.279|    1989|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       36791.760|    1988|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       35689.034|    1987|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       34737.275|    1986|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       34345.614|    1985|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       33099.374|    1984|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       31549.802|    1983|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       31060.645|    1982|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       32477.296|    1981|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       31769.783|    1980|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       31502.044|    1979|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       30651.633|    1978|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       29783.268|    1977|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       29128.014|    1976|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       28057.048|    1975|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       28080.941|    1974|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       27571.293|    1973|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       26216.591|    1972|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       25262.441|    1971|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       24629.216|    1970|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       24188.426|    1969|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       23294.302|    1968|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       22482.650|    1967|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       22242.419|    1966|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       21260.632|    1965|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       20301.660|    1964|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       19389.156|    1963|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       18780.564|    1962|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       17861.936|    1961|
| Canada        | Americas  |    1957|     64.65874| lifeExp |  69.960|       17664.205|    1960|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       50231.885|    2016|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       50109.875|    2015|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       50067.043|    2014|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       49355.097|    2013|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       48724.246|    2012|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       48456.965|    2011|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       47447.476|    2010|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       46543.792|    2009|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       48510.568|    2008|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       48552.696|    2007|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       48035.036|    2006|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       47181.562|    2005|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       46170.920|    2004|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       45239.811|    2003|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       44883.828|    2002|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       43964.955|    2001|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       43638.283|    2000|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       41856.046|    1999|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       40131.702|    1998|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       38967.953|    1997|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       37765.732|    1996|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       37569.468|    1995|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       36893.982|    1994|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       35648.478|    1993|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       35108.519|    1992|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       35231.021|    1991|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       36489.266|    1990|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       36981.279|    1989|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       36791.760|    1988|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       35689.034|    1987|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       34737.275|    1986|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       34345.614|    1985|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       33099.374|    1984|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       31549.802|    1983|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       31060.645|    1982|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       32477.296|    1981|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       31769.783|    1980|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       31502.044|    1979|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       30651.633|    1978|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       29783.268|    1977|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       29128.014|    1976|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       28057.048|    1975|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       28080.941|    1974|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       27571.293|    1973|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       26216.591|    1972|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       25262.441|    1971|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       24629.216|    1970|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       24188.426|    1969|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       23294.302|    1968|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       22482.650|    1967|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       22242.419|    1966|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       21260.632|    1965|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       20301.660|    1964|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       19389.156|    1963|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       18780.564|    1962|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       17861.936|    1961|
| Canada        | Americas  |    1962|     64.65874| lifeExp |  71.300|       17664.205|    1960|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       50231.885|    2016|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       50109.875|    2015|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       50067.043|    2014|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       49355.097|    2013|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       48724.246|    2012|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       48456.965|    2011|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       47447.476|    2010|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       46543.792|    2009|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       48510.568|    2008|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       48552.696|    2007|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       48035.036|    2006|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       47181.562|    2005|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       46170.920|    2004|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       45239.811|    2003|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       44883.828|    2002|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       43964.955|    2001|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       43638.283|    2000|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       41856.046|    1999|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       40131.702|    1998|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       38967.953|    1997|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       37765.732|    1996|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       37569.468|    1995|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       36893.982|    1994|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       35648.478|    1993|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       35108.519|    1992|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       35231.021|    1991|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       36489.266|    1990|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       36981.279|    1989|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       36791.760|    1988|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       35689.034|    1987|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       34737.275|    1986|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       34345.614|    1985|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       33099.374|    1984|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       31549.802|    1983|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       31060.645|    1982|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       32477.296|    1981|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       31769.783|    1980|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       31502.044|    1979|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       30651.633|    1978|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       29783.268|    1977|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       29128.014|    1976|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       28057.048|    1975|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       28080.941|    1974|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       27571.293|    1973|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       26216.591|    1972|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       25262.441|    1971|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       24629.216|    1970|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       24188.426|    1969|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       23294.302|    1968|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       22482.650|    1967|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       22242.419|    1966|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       21260.632|    1965|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       20301.660|    1964|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       19389.156|    1963|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       18780.564|    1962|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       17861.936|    1961|
| Canada        | Americas  |    1967|     64.65874| lifeExp |  72.130|       17664.205|    1960|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       50231.885|    2016|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       50109.875|    2015|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       50067.043|    2014|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       49355.097|    2013|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       48724.246|    2012|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       48456.965|    2011|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       47447.476|    2010|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       46543.792|    2009|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       48510.568|    2008|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       48552.696|    2007|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       48035.036|    2006|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       47181.562|    2005|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       46170.920|    2004|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       45239.811|    2003|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       44883.828|    2002|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       43964.955|    2001|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       43638.283|    2000|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       41856.046|    1999|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       40131.702|    1998|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       38967.953|    1997|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       37765.732|    1996|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       37569.468|    1995|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       36893.982|    1994|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       35648.478|    1993|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       35108.519|    1992|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       35231.021|    1991|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       36489.266|    1990|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       36981.279|    1989|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       36791.760|    1988|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       35689.034|    1987|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       34737.275|    1986|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       34345.614|    1985|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       33099.374|    1984|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       31549.802|    1983|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       31060.645|    1982|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       32477.296|    1981|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       31769.783|    1980|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       31502.044|    1979|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       30651.633|    1978|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       29783.268|    1977|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       29128.014|    1976|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       28057.048|    1975|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       28080.941|    1974|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       27571.293|    1973|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       26216.591|    1972|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       25262.441|    1971|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       24629.216|    1970|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       24188.426|    1969|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       23294.302|    1968|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       22482.650|    1967|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       22242.419|    1966|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       21260.632|    1965|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       20301.660|    1964|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       19389.156|    1963|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       18780.564|    1962|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       17861.936|    1961|
| Canada        | Americas  |    1972|     64.65874| lifeExp |  72.880|       17664.205|    1960|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       50231.885|    2016|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       50109.875|    2015|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       50067.043|    2014|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       49355.097|    2013|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       48724.246|    2012|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       48456.965|    2011|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       47447.476|    2010|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       46543.792|    2009|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       48510.568|    2008|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       48552.696|    2007|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       48035.036|    2006|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       47181.562|    2005|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       46170.920|    2004|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       45239.811|    2003|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       44883.828|    2002|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       43964.955|    2001|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       43638.283|    2000|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       41856.046|    1999|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       40131.702|    1998|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       38967.953|    1997|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       37765.732|    1996|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       37569.468|    1995|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       36893.982|    1994|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       35648.478|    1993|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       35108.519|    1992|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       35231.021|    1991|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       36489.266|    1990|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       36981.279|    1989|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       36791.760|    1988|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       35689.034|    1987|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       34737.275|    1986|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       34345.614|    1985|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       33099.374|    1984|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       31549.802|    1983|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       31060.645|    1982|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       32477.296|    1981|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       31769.783|    1980|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       31502.044|    1979|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       30651.633|    1978|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       29783.268|    1977|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       29128.014|    1976|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       28057.048|    1975|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       28080.941|    1974|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       27571.293|    1973|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       26216.591|    1972|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       25262.441|    1971|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       24629.216|    1970|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       24188.426|    1969|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       23294.302|    1968|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       22482.650|    1967|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       22242.419|    1966|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       21260.632|    1965|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       20301.660|    1964|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       19389.156|    1963|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       18780.564|    1962|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       17861.936|    1961|
| Canada        | Americas  |    1977|     64.65874| lifeExp |  74.210|       17664.205|    1960|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       50231.885|    2016|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       50109.875|    2015|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       50067.043|    2014|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       49355.097|    2013|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       48724.246|    2012|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       48456.965|    2011|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       47447.476|    2010|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       46543.792|    2009|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       48510.568|    2008|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       48552.696|    2007|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       48035.036|    2006|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       47181.562|    2005|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       46170.920|    2004|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       45239.811|    2003|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       44883.828|    2002|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       43964.955|    2001|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       43638.283|    2000|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       41856.046|    1999|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       40131.702|    1998|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       38967.953|    1997|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       37765.732|    1996|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       37569.468|    1995|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       36893.982|    1994|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       35648.478|    1993|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       35108.519|    1992|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       35231.021|    1991|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       36489.266|    1990|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       36981.279|    1989|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       36791.760|    1988|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       35689.034|    1987|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       34737.275|    1986|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       34345.614|    1985|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       33099.374|    1984|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       31549.802|    1983|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       31060.645|    1982|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       32477.296|    1981|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       31769.783|    1980|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       31502.044|    1979|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       30651.633|    1978|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       29783.268|    1977|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       29128.014|    1976|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       28057.048|    1975|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       28080.941|    1974|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       27571.293|    1973|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       26216.591|    1972|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       25262.441|    1971|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       24629.216|    1970|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       24188.426|    1969|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       23294.302|    1968|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       22482.650|    1967|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       22242.419|    1966|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       21260.632|    1965|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       20301.660|    1964|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       19389.156|    1963|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       18780.564|    1962|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       17861.936|    1961|
| Canada        | Americas  |    1982|     64.65874| lifeExp |  75.760|       17664.205|    1960|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       50231.885|    2016|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       50109.875|    2015|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       50067.043|    2014|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       49355.097|    2013|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       48724.246|    2012|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       48456.965|    2011|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       47447.476|    2010|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       46543.792|    2009|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       48510.568|    2008|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       48552.696|    2007|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       48035.036|    2006|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       47181.562|    2005|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       46170.920|    2004|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       45239.811|    2003|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       44883.828|    2002|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       43964.955|    2001|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       43638.283|    2000|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       41856.046|    1999|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       40131.702|    1998|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       38967.953|    1997|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       37765.732|    1996|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       37569.468|    1995|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       36893.982|    1994|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       35648.478|    1993|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       35108.519|    1992|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       35231.021|    1991|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       36489.266|    1990|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       36981.279|    1989|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       36791.760|    1988|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       35689.034|    1987|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       34737.275|    1986|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       34345.614|    1985|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       33099.374|    1984|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       31549.802|    1983|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       31060.645|    1982|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       32477.296|    1981|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       31769.783|    1980|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       31502.044|    1979|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       30651.633|    1978|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       29783.268|    1977|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       29128.014|    1976|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       28057.048|    1975|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       28080.941|    1974|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       27571.293|    1973|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       26216.591|    1972|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       25262.441|    1971|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       24629.216|    1970|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       24188.426|    1969|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       23294.302|    1968|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       22482.650|    1967|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       22242.419|    1966|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       21260.632|    1965|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       20301.660|    1964|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       19389.156|    1963|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       18780.564|    1962|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       17861.936|    1961|
| Canada        | Americas  |    1987|     64.65874| lifeExp |  76.860|       17664.205|    1960|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       50231.885|    2016|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       50109.875|    2015|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       50067.043|    2014|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       49355.097|    2013|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       48724.246|    2012|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       48456.965|    2011|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       47447.476|    2010|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       46543.792|    2009|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       48510.568|    2008|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       48552.696|    2007|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       48035.036|    2006|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       47181.562|    2005|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       46170.920|    2004|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       45239.811|    2003|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       44883.828|    2002|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       43964.955|    2001|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       43638.283|    2000|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       41856.046|    1999|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       40131.702|    1998|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       38967.953|    1997|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       37765.732|    1996|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       37569.468|    1995|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       36893.982|    1994|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       35648.478|    1993|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       35108.519|    1992|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       35231.021|    1991|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       36489.266|    1990|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       36981.279|    1989|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       36791.760|    1988|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       35689.034|    1987|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       34737.275|    1986|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       34345.614|    1985|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       33099.374|    1984|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       31549.802|    1983|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       31060.645|    1982|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       32477.296|    1981|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       31769.783|    1980|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       31502.044|    1979|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       30651.633|    1978|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       29783.268|    1977|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       29128.014|    1976|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       28057.048|    1975|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       28080.941|    1974|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       27571.293|    1973|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       26216.591|    1972|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       25262.441|    1971|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       24629.216|    1970|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       24188.426|    1969|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       23294.302|    1968|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       22482.650|    1967|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       22242.419|    1966|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       21260.632|    1965|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       20301.660|    1964|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       19389.156|    1963|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       18780.564|    1962|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       17861.936|    1961|
| Canada        | Americas  |    1992|     64.65874| lifeExp |  77.950|       17664.205|    1960|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       50231.885|    2016|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       50109.875|    2015|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       50067.043|    2014|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       49355.097|    2013|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       48724.246|    2012|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       48456.965|    2011|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       47447.476|    2010|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       46543.792|    2009|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       48510.568|    2008|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       48552.696|    2007|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       48035.036|    2006|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       47181.562|    2005|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       46170.920|    2004|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       45239.811|    2003|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       44883.828|    2002|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       43964.955|    2001|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       43638.283|    2000|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       41856.046|    1999|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       40131.702|    1998|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       38967.953|    1997|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       37765.732|    1996|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       37569.468|    1995|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       36893.982|    1994|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       35648.478|    1993|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       35108.519|    1992|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       35231.021|    1991|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       36489.266|    1990|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       36981.279|    1989|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       36791.760|    1988|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       35689.034|    1987|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       34737.275|    1986|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       34345.614|    1985|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       33099.374|    1984|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       31549.802|    1983|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       31060.645|    1982|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       32477.296|    1981|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       31769.783|    1980|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       31502.044|    1979|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       30651.633|    1978|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       29783.268|    1977|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       29128.014|    1976|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       28057.048|    1975|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       28080.941|    1974|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       27571.293|    1973|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       26216.591|    1972|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       25262.441|    1971|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       24629.216|    1970|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       24188.426|    1969|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       23294.302|    1968|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       22482.650|    1967|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       22242.419|    1966|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       21260.632|    1965|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       20301.660|    1964|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       19389.156|    1963|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       18780.564|    1962|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       17861.936|    1961|
| Canada        | Americas  |    1997|     64.65874| lifeExp |  78.610|       17664.205|    1960|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       50231.885|    2016|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       50109.875|    2015|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       50067.043|    2014|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       49355.097|    2013|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       48724.246|    2012|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       48456.965|    2011|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       47447.476|    2010|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       46543.792|    2009|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       48510.568|    2008|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       48552.696|    2007|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       48035.036|    2006|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       47181.562|    2005|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       46170.920|    2004|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       45239.811|    2003|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       44883.828|    2002|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       43964.955|    2001|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       43638.283|    2000|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       41856.046|    1999|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       40131.702|    1998|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       38967.953|    1997|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       37765.732|    1996|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       37569.468|    1995|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       36893.982|    1994|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       35648.478|    1993|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       35108.519|    1992|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       35231.021|    1991|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       36489.266|    1990|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       36981.279|    1989|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       36791.760|    1988|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       35689.034|    1987|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       34737.275|    1986|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       34345.614|    1985|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       33099.374|    1984|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       31549.802|    1983|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       31060.645|    1982|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       32477.296|    1981|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       31769.783|    1980|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       31502.044|    1979|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       30651.633|    1978|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       29783.268|    1977|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       29128.014|    1976|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       28057.048|    1975|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       28080.941|    1974|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       27571.293|    1973|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       26216.591|    1972|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       25262.441|    1971|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       24629.216|    1970|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       24188.426|    1969|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       23294.302|    1968|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       22482.650|    1967|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       22242.419|    1966|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       21260.632|    1965|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       20301.660|    1964|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       19389.156|    1963|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       18780.564|    1962|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       17861.936|    1961|
| Canada        | Americas  |    2002|     64.65874| lifeExp |  79.770|       17664.205|    1960|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       50231.885|    2016|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       50109.875|    2015|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       50067.043|    2014|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       49355.097|    2013|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       48724.246|    2012|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       48456.965|    2011|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       47447.476|    2010|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       46543.792|    2009|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       48510.568|    2008|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       48552.696|    2007|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       48035.036|    2006|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       47181.562|    2005|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       46170.920|    2004|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       45239.811|    2003|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       44883.828|    2002|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       43964.955|    2001|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       43638.283|    2000|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       41856.046|    1999|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       40131.702|    1998|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       38967.953|    1997|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       37765.732|    1996|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       37569.468|    1995|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       36893.982|    1994|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       35648.478|    1993|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       35108.519|    1992|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       35231.021|    1991|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       36489.266|    1990|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       36981.279|    1989|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       36791.760|    1988|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       35689.034|    1987|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       34737.275|    1986|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       34345.614|    1985|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       33099.374|    1984|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       31549.802|    1983|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       31060.645|    1982|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       32477.296|    1981|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       31769.783|    1980|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       31502.044|    1979|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       30651.633|    1978|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       29783.268|    1977|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       29128.014|    1976|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       28057.048|    1975|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       28080.941|    1974|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       27571.293|    1973|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       26216.591|    1972|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       25262.441|    1971|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       24629.216|    1970|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       24188.426|    1969|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       23294.302|    1968|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       22482.650|    1967|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       22242.419|    1966|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       21260.632|    1965|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       20301.660|    1964|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       19389.156|    1963|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       18780.564|    1962|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       17861.936|    1961|
| Canada        | Americas  |    2007|     64.65874| lifeExp |  80.653|       17664.205|    1960|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       15019.633|    2016|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       14907.116|    2015|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       14701.954|    2014|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       14551.044|    2013|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       14109.143|    2012|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       13518.765|    2011|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       12860.178|    2010|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       12268.441|    2009|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       12588.691|    2008|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       12285.048|    2007|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       11833.952|    2006|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       11249.868|    2005|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       10754.307|    2004|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|       10141.732|    2003|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        9852.834|    2002|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        9666.476|    2001|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        9469.110|    2000|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        9100.999|    1999|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        9254.795|    1998|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        8987.620|    1997|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        8479.875|    1996|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        8051.487|    1995|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        7498.852|    1994|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        7247.054|    1993|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        6904.330|    1992|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        6309.458|    1991|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        5947.765|    1990|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        5851.483|    1989|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        5413.325|    1988|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        5128.959|    1987|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4899.422|    1986|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4726.906|    1985|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4618.748|    1984|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4507.428|    1983|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4819.762|    1982|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        5499.996|    1981|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        5242.330|    1980|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4928.701|    1979|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4615.077|    1978|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4350.497|    1977|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4000.223|    1976|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        3913.965|    1975|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4568.019|    1974|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4537.196|    1973|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4861.117|    1972|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        5000.596|    1971|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4656.624|    1970|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4663.498|    1969|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4579.301|    1968|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4514.601|    1967|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4451.645|    1966|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4089.777|    1965|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4140.772|    1964|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        4127.319|    1963|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        3986.723|    1962|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        3918.367|    1961|
| Chile         | Americas  |    1952|     64.65874| lifeExp |  54.745|        3806.806|    1960|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       15019.633|    2016|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       14907.116|    2015|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       14701.954|    2014|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       14551.044|    2013|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       14109.143|    2012|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       13518.765|    2011|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       12860.178|    2010|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       12268.441|    2009|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       12588.691|    2008|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       12285.048|    2007|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       11833.952|    2006|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       11249.868|    2005|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       10754.307|    2004|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|       10141.732|    2003|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        9852.834|    2002|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        9666.476|    2001|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        9469.110|    2000|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        9100.999|    1999|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        9254.795|    1998|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        8987.620|    1997|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        8479.875|    1996|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        8051.487|    1995|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        7498.852|    1994|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        7247.054|    1993|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        6904.330|    1992|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        6309.458|    1991|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        5947.765|    1990|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        5851.483|    1989|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        5413.325|    1988|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        5128.959|    1987|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4899.422|    1986|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4726.906|    1985|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4618.748|    1984|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4507.428|    1983|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4819.762|    1982|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        5499.996|    1981|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        5242.330|    1980|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4928.701|    1979|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4615.077|    1978|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4350.497|    1977|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4000.223|    1976|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        3913.965|    1975|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4568.019|    1974|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4537.196|    1973|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4861.117|    1972|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        5000.596|    1971|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4656.624|    1970|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4663.498|    1969|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4579.301|    1968|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4514.601|    1967|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4451.645|    1966|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4089.777|    1965|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4140.772|    1964|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        4127.319|    1963|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        3986.723|    1962|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        3918.367|    1961|
| Chile         | Americas  |    1957|     64.65874| lifeExp |  56.074|        3806.806|    1960|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       15019.633|    2016|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       14907.116|    2015|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       14701.954|    2014|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       14551.044|    2013|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       14109.143|    2012|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       13518.765|    2011|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       12860.178|    2010|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       12268.441|    2009|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       12588.691|    2008|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       12285.048|    2007|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       11833.952|    2006|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       11249.868|    2005|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       10754.307|    2004|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|       10141.732|    2003|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        9852.834|    2002|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        9666.476|    2001|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        9469.110|    2000|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        9100.999|    1999|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        9254.795|    1998|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        8987.620|    1997|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        8479.875|    1996|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        8051.487|    1995|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        7498.852|    1994|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        7247.054|    1993|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        6904.330|    1992|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        6309.458|    1991|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        5947.765|    1990|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        5851.483|    1989|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        5413.325|    1988|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        5128.959|    1987|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4899.422|    1986|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4726.906|    1985|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4618.748|    1984|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4507.428|    1983|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4819.762|    1982|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        5499.996|    1981|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        5242.330|    1980|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4928.701|    1979|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4615.077|    1978|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4350.497|    1977|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4000.223|    1976|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        3913.965|    1975|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4568.019|    1974|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4537.196|    1973|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4861.117|    1972|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        5000.596|    1971|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4656.624|    1970|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4663.498|    1969|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4579.301|    1968|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4514.601|    1967|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4451.645|    1966|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4089.777|    1965|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4140.772|    1964|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        4127.319|    1963|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        3986.723|    1962|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        3918.367|    1961|
| Chile         | Americas  |    1962|     64.65874| lifeExp |  57.924|        3806.806|    1960|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       15019.633|    2016|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       14907.116|    2015|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       14701.954|    2014|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       14551.044|    2013|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       14109.143|    2012|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       13518.765|    2011|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       12860.178|    2010|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       12268.441|    2009|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       12588.691|    2008|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       12285.048|    2007|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       11833.952|    2006|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       11249.868|    2005|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       10754.307|    2004|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|       10141.732|    2003|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        9852.834|    2002|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        9666.476|    2001|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        9469.110|    2000|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        9100.999|    1999|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        9254.795|    1998|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        8987.620|    1997|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        8479.875|    1996|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        8051.487|    1995|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        7498.852|    1994|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        7247.054|    1993|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        6904.330|    1992|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        6309.458|    1991|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        5947.765|    1990|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        5851.483|    1989|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        5413.325|    1988|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        5128.959|    1987|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4899.422|    1986|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4726.906|    1985|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4618.748|    1984|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4507.428|    1983|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4819.762|    1982|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        5499.996|    1981|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        5242.330|    1980|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4928.701|    1979|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4615.077|    1978|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4350.497|    1977|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4000.223|    1976|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        3913.965|    1975|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4568.019|    1974|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4537.196|    1973|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4861.117|    1972|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        5000.596|    1971|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4656.624|    1970|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4663.498|    1969|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4579.301|    1968|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4514.601|    1967|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4451.645|    1966|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4089.777|    1965|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4140.772|    1964|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        4127.319|    1963|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        3986.723|    1962|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        3918.367|    1961|
| Chile         | Americas  |    1967|     64.65874| lifeExp |  60.523|        3806.806|    1960|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       15019.633|    2016|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       14907.116|    2015|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       14701.954|    2014|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       14551.044|    2013|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       14109.143|    2012|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       13518.765|    2011|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       12860.178|    2010|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       12268.441|    2009|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       12588.691|    2008|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       12285.048|    2007|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       11833.952|    2006|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       11249.868|    2005|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       10754.307|    2004|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|       10141.732|    2003|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        9852.834|    2002|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        9666.476|    2001|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        9469.110|    2000|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        9100.999|    1999|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        9254.795|    1998|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        8987.620|    1997|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        8479.875|    1996|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        8051.487|    1995|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        7498.852|    1994|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        7247.054|    1993|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        6904.330|    1992|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        6309.458|    1991|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        5947.765|    1990|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        5851.483|    1989|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        5413.325|    1988|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        5128.959|    1987|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4899.422|    1986|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4726.906|    1985|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4618.748|    1984|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4507.428|    1983|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4819.762|    1982|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        5499.996|    1981|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        5242.330|    1980|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4928.701|    1979|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4615.077|    1978|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4350.497|    1977|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4000.223|    1976|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        3913.965|    1975|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4568.019|    1974|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4537.196|    1973|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4861.117|    1972|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        5000.596|    1971|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4656.624|    1970|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4663.498|    1969|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4579.301|    1968|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4514.601|    1967|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4451.645|    1966|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4089.777|    1965|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4140.772|    1964|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        4127.319|    1963|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        3986.723|    1962|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        3918.367|    1961|
| Chile         | Americas  |    1972|     64.65874| lifeExp |  63.441|        3806.806|    1960|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       15019.633|    2016|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       14907.116|    2015|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       14701.954|    2014|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       14551.044|    2013|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       14109.143|    2012|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       13518.765|    2011|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       12860.178|    2010|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       12268.441|    2009|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       12588.691|    2008|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       12285.048|    2007|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       11833.952|    2006|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       11249.868|    2005|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       10754.307|    2004|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|       10141.732|    2003|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        9852.834|    2002|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        9666.476|    2001|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        9469.110|    2000|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        9100.999|    1999|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        9254.795|    1998|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        8987.620|    1997|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        8479.875|    1996|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        8051.487|    1995|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        7498.852|    1994|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        7247.054|    1993|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        6904.330|    1992|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        6309.458|    1991|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        5947.765|    1990|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        5851.483|    1989|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        5413.325|    1988|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        5128.959|    1987|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4899.422|    1986|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4726.906|    1985|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4618.748|    1984|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4507.428|    1983|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4819.762|    1982|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        5499.996|    1981|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        5242.330|    1980|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4928.701|    1979|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4615.077|    1978|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4350.497|    1977|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4000.223|    1976|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        3913.965|    1975|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4568.019|    1974|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4537.196|    1973|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4861.117|    1972|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        5000.596|    1971|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4656.624|    1970|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4663.498|    1969|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4579.301|    1968|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4514.601|    1967|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4451.645|    1966|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4089.777|    1965|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4140.772|    1964|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        4127.319|    1963|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        3986.723|    1962|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        3918.367|    1961|
| Chile         | Americas  |    1977|     64.65874| lifeExp |  67.052|        3806.806|    1960|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       15019.633|    2016|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       14907.116|    2015|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       14701.954|    2014|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       14551.044|    2013|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       14109.143|    2012|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       13518.765|    2011|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       12860.178|    2010|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       12268.441|    2009|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       12588.691|    2008|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       12285.048|    2007|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       11833.952|    2006|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       11249.868|    2005|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       10754.307|    2004|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|       10141.732|    2003|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        9852.834|    2002|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        9666.476|    2001|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        9469.110|    2000|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        9100.999|    1999|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        9254.795|    1998|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        8987.620|    1997|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        8479.875|    1996|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        8051.487|    1995|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        7498.852|    1994|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        7247.054|    1993|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        6904.330|    1992|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        6309.458|    1991|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        5947.765|    1990|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        5851.483|    1989|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        5413.325|    1988|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        5128.959|    1987|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4899.422|    1986|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4726.906|    1985|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4618.748|    1984|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4507.428|    1983|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4819.762|    1982|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        5499.996|    1981|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        5242.330|    1980|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4928.701|    1979|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4615.077|    1978|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4350.497|    1977|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4000.223|    1976|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        3913.965|    1975|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4568.019|    1974|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4537.196|    1973|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4861.117|    1972|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        5000.596|    1971|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4656.624|    1970|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4663.498|    1969|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4579.301|    1968|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4514.601|    1967|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4451.645|    1966|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4089.777|    1965|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4140.772|    1964|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        4127.319|    1963|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        3986.723|    1962|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        3918.367|    1961|
| Chile         | Americas  |    1982|     64.65874| lifeExp |  70.565|        3806.806|    1960|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       15019.633|    2016|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       14907.116|    2015|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       14701.954|    2014|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       14551.044|    2013|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       14109.143|    2012|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       13518.765|    2011|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       12860.178|    2010|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       12268.441|    2009|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       12588.691|    2008|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       12285.048|    2007|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       11833.952|    2006|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       11249.868|    2005|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       10754.307|    2004|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|       10141.732|    2003|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        9852.834|    2002|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        9666.476|    2001|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        9469.110|    2000|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        9100.999|    1999|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        9254.795|    1998|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        8987.620|    1997|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        8479.875|    1996|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        8051.487|    1995|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        7498.852|    1994|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        7247.054|    1993|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        6904.330|    1992|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        6309.458|    1991|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        5947.765|    1990|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        5851.483|    1989|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        5413.325|    1988|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        5128.959|    1987|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4899.422|    1986|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4726.906|    1985|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4618.748|    1984|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4507.428|    1983|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4819.762|    1982|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        5499.996|    1981|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        5242.330|    1980|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4928.701|    1979|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4615.077|    1978|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4350.497|    1977|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4000.223|    1976|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        3913.965|    1975|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4568.019|    1974|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4537.196|    1973|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4861.117|    1972|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        5000.596|    1971|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4656.624|    1970|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4663.498|    1969|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4579.301|    1968|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4514.601|    1967|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4451.645|    1966|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4089.777|    1965|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4140.772|    1964|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        4127.319|    1963|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        3986.723|    1962|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        3918.367|    1961|
| Chile         | Americas  |    1987|     64.65874| lifeExp |  72.492|        3806.806|    1960|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       15019.633|    2016|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       14907.116|    2015|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       14701.954|    2014|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       14551.044|    2013|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       14109.143|    2012|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       13518.765|    2011|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       12860.178|    2010|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       12268.441|    2009|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       12588.691|    2008|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       12285.048|    2007|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       11833.952|    2006|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       11249.868|    2005|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       10754.307|    2004|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|       10141.732|    2003|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        9852.834|    2002|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        9666.476|    2001|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        9469.110|    2000|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        9100.999|    1999|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        9254.795|    1998|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        8987.620|    1997|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        8479.875|    1996|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        8051.487|    1995|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        7498.852|    1994|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        7247.054|    1993|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        6904.330|    1992|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        6309.458|    1991|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        5947.765|    1990|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        5851.483|    1989|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        5413.325|    1988|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        5128.959|    1987|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4899.422|    1986|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4726.906|    1985|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4618.748|    1984|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4507.428|    1983|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4819.762|    1982|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        5499.996|    1981|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        5242.330|    1980|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4928.701|    1979|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4615.077|    1978|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4350.497|    1977|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4000.223|    1976|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        3913.965|    1975|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4568.019|    1974|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4537.196|    1973|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4861.117|    1972|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        5000.596|    1971|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4656.624|    1970|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4663.498|    1969|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4579.301|    1968|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4514.601|    1967|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4451.645|    1966|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4089.777|    1965|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4140.772|    1964|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        4127.319|    1963|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        3986.723|    1962|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        3918.367|    1961|
| Chile         | Americas  |    1992|     64.65874| lifeExp |  74.126|        3806.806|    1960|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       15019.633|    2016|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       14907.116|    2015|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       14701.954|    2014|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       14551.044|    2013|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       14109.143|    2012|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       13518.765|    2011|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       12860.178|    2010|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       12268.441|    2009|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       12588.691|    2008|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       12285.048|    2007|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       11833.952|    2006|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       11249.868|    2005|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       10754.307|    2004|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|       10141.732|    2003|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        9852.834|    2002|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        9666.476|    2001|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        9469.110|    2000|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        9100.999|    1999|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        9254.795|    1998|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        8987.620|    1997|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        8479.875|    1996|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        8051.487|    1995|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        7498.852|    1994|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        7247.054|    1993|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        6904.330|    1992|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        6309.458|    1991|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        5947.765|    1990|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        5851.483|    1989|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        5413.325|    1988|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        5128.959|    1987|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4899.422|    1986|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4726.906|    1985|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4618.748|    1984|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4507.428|    1983|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4819.762|    1982|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        5499.996|    1981|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        5242.330|    1980|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4928.701|    1979|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4615.077|    1978|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4350.497|    1977|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4000.223|    1976|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        3913.965|    1975|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4568.019|    1974|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4537.196|    1973|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4861.117|    1972|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        5000.596|    1971|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4656.624|    1970|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4663.498|    1969|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4579.301|    1968|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4514.601|    1967|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4451.645|    1966|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4089.777|    1965|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4140.772|    1964|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        4127.319|    1963|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        3986.723|    1962|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        3918.367|    1961|
| Chile         | Americas  |    1997|     64.65874| lifeExp |  75.816|        3806.806|    1960|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       15019.633|    2016|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       14907.116|    2015|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       14701.954|    2014|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       14551.044|    2013|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       14109.143|    2012|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       13518.765|    2011|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       12860.178|    2010|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       12268.441|    2009|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       12588.691|    2008|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       12285.048|    2007|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       11833.952|    2006|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       11249.868|    2005|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       10754.307|    2004|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|       10141.732|    2003|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        9852.834|    2002|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        9666.476|    2001|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        9469.110|    2000|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        9100.999|    1999|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        9254.795|    1998|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        8987.620|    1997|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        8479.875|    1996|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        8051.487|    1995|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        7498.852|    1994|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        7247.054|    1993|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        6904.330|    1992|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        6309.458|    1991|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        5947.765|    1990|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        5851.483|    1989|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        5413.325|    1988|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        5128.959|    1987|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4899.422|    1986|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4726.906|    1985|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4618.748|    1984|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4507.428|    1983|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4819.762|    1982|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        5499.996|    1981|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        5242.330|    1980|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4928.701|    1979|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4615.077|    1978|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4350.497|    1977|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4000.223|    1976|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        3913.965|    1975|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4568.019|    1974|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4537.196|    1973|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4861.117|    1972|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        5000.596|    1971|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4656.624|    1970|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4663.498|    1969|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4579.301|    1968|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4514.601|    1967|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4451.645|    1966|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4089.777|    1965|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4140.772|    1964|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        4127.319|    1963|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        3986.723|    1962|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        3918.367|    1961|
| Chile         | Americas  |    2002|     64.65874| lifeExp |  77.860|        3806.806|    1960|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       15019.633|    2016|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       14907.116|    2015|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       14701.954|    2014|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       14551.044|    2013|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       14109.143|    2012|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       13518.765|    2011|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       12860.178|    2010|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       12268.441|    2009|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       12588.691|    2008|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       12285.048|    2007|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       11833.952|    2006|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       11249.868|    2005|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       10754.307|    2004|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|       10141.732|    2003|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        9852.834|    2002|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        9666.476|    2001|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        9469.110|    2000|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        9100.999|    1999|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        9254.795|    1998|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        8987.620|    1997|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        8479.875|    1996|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        8051.487|    1995|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        7498.852|    1994|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        7247.054|    1993|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        6904.330|    1992|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        6309.458|    1991|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        5947.765|    1990|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        5851.483|    1989|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        5413.325|    1988|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        5128.959|    1987|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4899.422|    1986|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4726.906|    1985|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4618.748|    1984|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4507.428|    1983|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4819.762|    1982|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        5499.996|    1981|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        5242.330|    1980|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4928.701|    1979|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4615.077|    1978|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4350.497|    1977|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4000.223|    1976|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        3913.965|    1975|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4568.019|    1974|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4537.196|    1973|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4861.117|    1972|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        5000.596|    1971|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4656.624|    1970|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4663.498|    1969|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4579.301|    1968|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4514.601|    1967|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4451.645|    1966|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4089.777|    1965|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4140.772|    1964|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        4127.319|    1963|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        3986.723|    1962|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        3918.367|    1961|
| Chile         | Americas  |    2007|     64.65874| lifeExp |  78.553|        3806.806|    1960|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       14840.387|    2016|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       14518.837|    2015|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       14042.281|    2014|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13459.746|    2013|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13144.446|    2012|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13289.707|    2011|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13025.534|    2010|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       12908.723|    2009|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13794.138|    2008|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13648.642|    2007|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13566.688|    2006|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       13042.687|    2005|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       12470.217|    2004|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       11849.519|    2003|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       11380.028|    2002|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       10858.695|    2001|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|       10439.807|    2000|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        9992.793|    1999|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        9655.087|    1998|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        9242.704|    1997|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        8928.924|    1996|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        8913.102|    1995|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        8770.070|    1994|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        8507.349|    1993|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        8546.892|    1992|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|        8813.613|    1991|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1990|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1989|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1988|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1987|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1986|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1985|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1984|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1983|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1982|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1981|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1980|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1979|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1978|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1977|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1976|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1975|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1974|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1973|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1972|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1971|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1970|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1969|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1968|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1967|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1966|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1965|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1964|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1963|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1962|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1961|
| Hungary       | Europe    |    1952|     71.90369| lifeExp |  64.030|              NA|    1960|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       14840.387|    2016|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       14518.837|    2015|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       14042.281|    2014|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13459.746|    2013|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13144.446|    2012|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13289.707|    2011|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13025.534|    2010|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       12908.723|    2009|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13794.138|    2008|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13648.642|    2007|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13566.688|    2006|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       13042.687|    2005|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       12470.217|    2004|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       11849.519|    2003|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       11380.028|    2002|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       10858.695|    2001|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|       10439.807|    2000|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        9992.793|    1999|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        9655.087|    1998|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        9242.704|    1997|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        8928.924|    1996|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        8913.102|    1995|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        8770.070|    1994|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        8507.349|    1993|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        8546.892|    1992|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|        8813.613|    1991|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1990|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1989|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1988|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1987|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1986|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1985|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1984|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1983|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1982|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1981|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1980|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1979|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1978|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1977|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1976|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1975|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1974|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1973|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1972|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1971|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1970|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1969|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1968|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1967|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1966|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1965|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1964|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1963|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1962|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1961|
| Hungary       | Europe    |    1957|     71.90369| lifeExp |  66.410|              NA|    1960|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       14840.387|    2016|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       14518.837|    2015|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       14042.281|    2014|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13459.746|    2013|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13144.446|    2012|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13289.707|    2011|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13025.534|    2010|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       12908.723|    2009|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13794.138|    2008|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13648.642|    2007|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13566.688|    2006|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       13042.687|    2005|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       12470.217|    2004|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       11849.519|    2003|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       11380.028|    2002|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       10858.695|    2001|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|       10439.807|    2000|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        9992.793|    1999|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        9655.087|    1998|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        9242.704|    1997|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        8928.924|    1996|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        8913.102|    1995|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        8770.070|    1994|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        8507.349|    1993|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        8546.892|    1992|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|        8813.613|    1991|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1990|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1989|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1988|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1987|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1986|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1985|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1984|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1983|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1982|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1981|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1980|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1979|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1978|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1977|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1976|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1975|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1974|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1973|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1972|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1971|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1970|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1969|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1968|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1967|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1966|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1965|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1964|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1963|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1962|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1961|
| Hungary       | Europe    |    1962|     71.90369| lifeExp |  67.960|              NA|    1960|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       14840.387|    2016|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       14518.837|    2015|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       14042.281|    2014|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13459.746|    2013|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13144.446|    2012|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13289.707|    2011|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13025.534|    2010|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       12908.723|    2009|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13794.138|    2008|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13648.642|    2007|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13566.688|    2006|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       13042.687|    2005|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       12470.217|    2004|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       11849.519|    2003|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       11380.028|    2002|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       10858.695|    2001|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|       10439.807|    2000|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        9992.793|    1999|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        9655.087|    1998|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        9242.704|    1997|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        8928.924|    1996|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        8913.102|    1995|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        8770.070|    1994|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        8507.349|    1993|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        8546.892|    1992|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|        8813.613|    1991|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1990|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1989|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1988|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1987|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1986|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1985|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1984|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1983|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1982|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1981|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1980|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1979|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1978|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1977|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1976|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1975|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1974|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1973|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1972|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1971|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1970|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1969|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1968|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1967|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1966|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1965|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1964|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1963|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1962|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1961|
| Hungary       | Europe    |    1967|     71.90369| lifeExp |  69.500|              NA|    1960|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       14840.387|    2016|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       14518.837|    2015|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       14042.281|    2014|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13459.746|    2013|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13144.446|    2012|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13289.707|    2011|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13025.534|    2010|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       12908.723|    2009|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13794.138|    2008|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13648.642|    2007|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13566.688|    2006|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       13042.687|    2005|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       12470.217|    2004|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       11849.519|    2003|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       11380.028|    2002|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       10858.695|    2001|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|       10439.807|    2000|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        9992.793|    1999|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        9655.087|    1998|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        9242.704|    1997|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        8928.924|    1996|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        8913.102|    1995|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        8770.070|    1994|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        8507.349|    1993|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        8546.892|    1992|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|        8813.613|    1991|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1990|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1989|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1988|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1987|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1986|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1985|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1984|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1983|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1982|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1981|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1980|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1979|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1978|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1977|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1976|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1975|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1974|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1973|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1972|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1971|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1970|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1969|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1968|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1967|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1966|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1965|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1964|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1963|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1962|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1961|
| Hungary       | Europe    |    1972|     71.90369| lifeExp |  69.760|              NA|    1960|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       14840.387|    2016|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       14518.837|    2015|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       14042.281|    2014|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13459.746|    2013|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13144.446|    2012|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13289.707|    2011|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13025.534|    2010|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       12908.723|    2009|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13794.138|    2008|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13648.642|    2007|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13566.688|    2006|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       13042.687|    2005|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       12470.217|    2004|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       11849.519|    2003|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       11380.028|    2002|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       10858.695|    2001|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|       10439.807|    2000|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        9992.793|    1999|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        9655.087|    1998|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        9242.704|    1997|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        8928.924|    1996|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        8913.102|    1995|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        8770.070|    1994|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        8507.349|    1993|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        8546.892|    1992|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|        8813.613|    1991|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1990|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1989|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1988|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1987|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1986|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1985|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1984|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1983|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1982|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1981|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1980|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1979|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1978|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1977|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1976|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1975|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1974|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1973|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1972|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1971|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1970|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1969|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1968|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1967|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1966|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1965|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1964|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1963|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1962|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1961|
| Hungary       | Europe    |    1977|     71.90369| lifeExp |  69.950|              NA|    1960|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       14840.387|    2016|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       14518.837|    2015|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       14042.281|    2014|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13459.746|    2013|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13144.446|    2012|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13289.707|    2011|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13025.534|    2010|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       12908.723|    2009|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13794.138|    2008|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13648.642|    2007|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13566.688|    2006|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       13042.687|    2005|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       12470.217|    2004|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       11849.519|    2003|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       11380.028|    2002|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       10858.695|    2001|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|       10439.807|    2000|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        9992.793|    1999|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        9655.087|    1998|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        9242.704|    1997|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        8928.924|    1996|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        8913.102|    1995|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        8770.070|    1994|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        8507.349|    1993|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        8546.892|    1992|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|        8813.613|    1991|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1990|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1989|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1988|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1987|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1986|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1985|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1984|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1983|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1982|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1981|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1980|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1979|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1978|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1977|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1976|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1975|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1974|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1973|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1972|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1971|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1970|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1969|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1968|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1967|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1966|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1965|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1964|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1963|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1962|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1961|
| Hungary       | Europe    |    1982|     71.90369| lifeExp |  69.390|              NA|    1960|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       14840.387|    2016|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       14518.837|    2015|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       14042.281|    2014|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13459.746|    2013|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13144.446|    2012|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13289.707|    2011|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13025.534|    2010|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       12908.723|    2009|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13794.138|    2008|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13648.642|    2007|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13566.688|    2006|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       13042.687|    2005|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       12470.217|    2004|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       11849.519|    2003|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       11380.028|    2002|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       10858.695|    2001|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|       10439.807|    2000|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        9992.793|    1999|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        9655.087|    1998|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        9242.704|    1997|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        8928.924|    1996|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        8913.102|    1995|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        8770.070|    1994|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        8507.349|    1993|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        8546.892|    1992|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|        8813.613|    1991|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1990|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1989|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1988|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1987|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1986|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1985|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1984|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1983|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1982|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1981|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1980|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1979|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1978|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1977|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1976|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1975|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1974|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1973|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1972|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1971|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1970|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1969|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1968|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1967|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1966|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1965|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1964|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1963|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1962|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1961|
| Hungary       | Europe    |    1987|     71.90369| lifeExp |  69.580|              NA|    1960|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       14840.387|    2016|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       14518.837|    2015|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       14042.281|    2014|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13459.746|    2013|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13144.446|    2012|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13289.707|    2011|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13025.534|    2010|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       12908.723|    2009|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13794.138|    2008|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13648.642|    2007|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13566.688|    2006|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       13042.687|    2005|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       12470.217|    2004|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       11849.519|    2003|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       11380.028|    2002|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       10858.695|    2001|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|       10439.807|    2000|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        9992.793|    1999|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        9655.087|    1998|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        9242.704|    1997|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        8928.924|    1996|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        8913.102|    1995|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        8770.070|    1994|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        8507.349|    1993|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        8546.892|    1992|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|        8813.613|    1991|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1990|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1989|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1988|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1987|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1986|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1985|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1984|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1983|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1982|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1981|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1980|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1979|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1978|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1977|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1976|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1975|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1974|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1973|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1972|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1971|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1970|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1969|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1968|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1967|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1966|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1965|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1964|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1963|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1962|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1961|
| Hungary       | Europe    |    1992|     71.90369| lifeExp |  69.170|              NA|    1960|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       14840.387|    2016|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       14518.837|    2015|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       14042.281|    2014|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13459.746|    2013|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13144.446|    2012|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13289.707|    2011|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13025.534|    2010|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       12908.723|    2009|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13794.138|    2008|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13648.642|    2007|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13566.688|    2006|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       13042.687|    2005|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       12470.217|    2004|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       11849.519|    2003|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       11380.028|    2002|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       10858.695|    2001|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|       10439.807|    2000|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        9992.793|    1999|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        9655.087|    1998|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        9242.704|    1997|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        8928.924|    1996|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        8913.102|    1995|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        8770.070|    1994|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        8507.349|    1993|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        8546.892|    1992|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|        8813.613|    1991|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1990|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1989|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1988|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1987|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1986|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1985|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1984|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1983|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1982|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1981|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1980|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1979|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1978|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1977|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1976|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1975|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1974|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1973|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1972|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1971|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1970|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1969|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1968|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1967|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1966|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1965|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1964|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1963|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1962|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1961|
| Hungary       | Europe    |    1997|     71.90369| lifeExp |  71.040|              NA|    1960|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       14840.387|    2016|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       14518.837|    2015|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       14042.281|    2014|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13459.746|    2013|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13144.446|    2012|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13289.707|    2011|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13025.534|    2010|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       12908.723|    2009|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13794.138|    2008|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13648.642|    2007|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13566.688|    2006|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       13042.687|    2005|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       12470.217|    2004|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       11849.519|    2003|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       11380.028|    2002|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       10858.695|    2001|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|       10439.807|    2000|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        9992.793|    1999|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        9655.087|    1998|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        9242.704|    1997|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        8928.924|    1996|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        8913.102|    1995|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        8770.070|    1994|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        8507.349|    1993|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        8546.892|    1992|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|        8813.613|    1991|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1990|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1989|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1988|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1987|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1986|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1985|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1984|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1983|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1982|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1981|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1980|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1979|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1978|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1977|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1976|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1975|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1974|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1973|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1972|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1971|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1970|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1969|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1968|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1967|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1966|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1965|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1964|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1963|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1962|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1961|
| Hungary       | Europe    |    2002|     71.90369| lifeExp |  72.590|              NA|    1960|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       14840.387|    2016|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       14518.837|    2015|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       14042.281|    2014|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13459.746|    2013|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13144.446|    2012|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13289.707|    2011|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13025.534|    2010|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       12908.723|    2009|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13794.138|    2008|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13648.642|    2007|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13566.688|    2006|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       13042.687|    2005|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       12470.217|    2004|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       11849.519|    2003|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       11380.028|    2002|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       10858.695|    2001|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|       10439.807|    2000|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        9992.793|    1999|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        9655.087|    1998|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        9242.704|    1997|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        8928.924|    1996|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        8913.102|    1995|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        8770.070|    1994|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        8507.349|    1993|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        8546.892|    1992|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|        8813.613|    1991|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1990|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1989|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1988|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1987|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1986|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1985|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1984|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1983|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1982|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1981|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1980|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1979|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1978|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1977|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1976|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1975|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1974|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1973|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1972|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1971|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1970|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1969|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1968|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1967|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1966|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1965|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1964|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1963|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1962|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1961|
| Hungary       | Europe    |    2007|     71.90369| lifeExp |  73.338|              NA|    1960|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9707.136|    2016|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9612.965|    2015|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9492.551|    2014|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9409.965|    2013|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9414.906|    2012|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9183.328|    2011|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8959.581|    2010|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8657.836|    2009|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9232.197|    2008|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9253.318|    2007|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        9108.065|    2006|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8808.564|    2005|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8667.289|    2004|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8416.904|    2003|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8401.016|    2002|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8494.839|    2001|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8659.797|    2000|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8340.564|    1999|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        8245.494|    1998|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7999.858|    1997|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7603.709|    1996|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7307.177|    1995|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7896.121|    1994|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7685.217|    1993|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7532.608|    1992|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7415.506|    1991|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7257.931|    1990|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7044.825|    1989|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        6893.916|    1988|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        6942.826|    1987|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        6951.816|    1986|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7369.866|    1985|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7333.353|    1984|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7228.939|    1983|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7711.239|    1982|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7935.986|    1981|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7467.538|    1980|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        7003.035|    1979|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        6545.368|    1978|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        6165.411|    1977|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        6127.206|    1976|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        6036.819|    1975|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        5881.256|    1974|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        5735.520|    1973|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        5490.266|    1972|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        5238.981|    1971|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        5212.902|    1970|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        5050.561|    1969|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        5036.374|    1968|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        4744.742|    1967|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        4620.520|    1966|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        4490.494|    1965|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        4324.486|    1964|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        3986.441|    1963|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        3804.548|    1962|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        3750.841|    1961|
| Mexico        | Americas  |    1952|     64.65874| lifeExp |  50.789|        3686.395|    1960|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9707.136|    2016|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9612.965|    2015|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9492.551|    2014|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9409.965|    2013|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9414.906|    2012|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9183.328|    2011|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8959.581|    2010|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8657.836|    2009|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9232.197|    2008|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9253.318|    2007|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        9108.065|    2006|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8808.564|    2005|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8667.289|    2004|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8416.904|    2003|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8401.016|    2002|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8494.839|    2001|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8659.797|    2000|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8340.564|    1999|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        8245.494|    1998|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7999.858|    1997|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7603.709|    1996|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7307.177|    1995|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7896.121|    1994|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7685.217|    1993|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7532.608|    1992|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7415.506|    1991|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7257.931|    1990|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7044.825|    1989|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        6893.916|    1988|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        6942.826|    1987|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        6951.816|    1986|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7369.866|    1985|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7333.353|    1984|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7228.939|    1983|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7711.239|    1982|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7935.986|    1981|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7467.538|    1980|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        7003.035|    1979|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        6545.368|    1978|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        6165.411|    1977|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        6127.206|    1976|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        6036.819|    1975|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        5881.256|    1974|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        5735.520|    1973|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        5490.266|    1972|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        5238.981|    1971|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        5212.902|    1970|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        5050.561|    1969|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        5036.374|    1968|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        4744.742|    1967|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        4620.520|    1966|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        4490.494|    1965|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        4324.486|    1964|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        3986.441|    1963|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        3804.548|    1962|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        3750.841|    1961|
| Mexico        | Americas  |    1957|     64.65874| lifeExp |  55.190|        3686.395|    1960|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9707.136|    2016|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9612.965|    2015|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9492.551|    2014|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9409.965|    2013|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9414.906|    2012|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9183.328|    2011|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8959.581|    2010|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8657.836|    2009|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9232.197|    2008|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9253.318|    2007|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        9108.065|    2006|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8808.564|    2005|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8667.289|    2004|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8416.904|    2003|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8401.016|    2002|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8494.839|    2001|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8659.797|    2000|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8340.564|    1999|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        8245.494|    1998|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7999.858|    1997|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7603.709|    1996|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7307.177|    1995|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7896.121|    1994|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7685.217|    1993|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7532.608|    1992|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7415.506|    1991|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7257.931|    1990|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7044.825|    1989|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        6893.916|    1988|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        6942.826|    1987|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        6951.816|    1986|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7369.866|    1985|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7333.353|    1984|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7228.939|    1983|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7711.239|    1982|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7935.986|    1981|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7467.538|    1980|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        7003.035|    1979|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        6545.368|    1978|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        6165.411|    1977|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        6127.206|    1976|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        6036.819|    1975|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        5881.256|    1974|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        5735.520|    1973|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        5490.266|    1972|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        5238.981|    1971|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        5212.902|    1970|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        5050.561|    1969|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        5036.374|    1968|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        4744.742|    1967|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        4620.520|    1966|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        4490.494|    1965|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        4324.486|    1964|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        3986.441|    1963|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        3804.548|    1962|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        3750.841|    1961|
| Mexico        | Americas  |    1962|     64.65874| lifeExp |  58.299|        3686.395|    1960|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9707.136|    2016|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9612.965|    2015|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9492.551|    2014|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9409.965|    2013|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9414.906|    2012|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9183.328|    2011|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8959.581|    2010|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8657.836|    2009|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9232.197|    2008|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9253.318|    2007|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        9108.065|    2006|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8808.564|    2005|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8667.289|    2004|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8416.904|    2003|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8401.016|    2002|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8494.839|    2001|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8659.797|    2000|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8340.564|    1999|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        8245.494|    1998|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7999.858|    1997|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7603.709|    1996|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7307.177|    1995|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7896.121|    1994|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7685.217|    1993|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7532.608|    1992|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7415.506|    1991|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7257.931|    1990|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7044.825|    1989|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        6893.916|    1988|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        6942.826|    1987|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        6951.816|    1986|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7369.866|    1985|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7333.353|    1984|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7228.939|    1983|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7711.239|    1982|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7935.986|    1981|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7467.538|    1980|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        7003.035|    1979|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        6545.368|    1978|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        6165.411|    1977|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        6127.206|    1976|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        6036.819|    1975|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        5881.256|    1974|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        5735.520|    1973|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        5490.266|    1972|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        5238.981|    1971|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        5212.902|    1970|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        5050.561|    1969|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        5036.374|    1968|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        4744.742|    1967|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        4620.520|    1966|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        4490.494|    1965|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        4324.486|    1964|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        3986.441|    1963|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        3804.548|    1962|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        3750.841|    1961|
| Mexico        | Americas  |    1967|     64.65874| lifeExp |  60.110|        3686.395|    1960|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9707.136|    2016|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9612.965|    2015|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9492.551|    2014|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9409.965|    2013|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9414.906|    2012|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9183.328|    2011|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8959.581|    2010|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8657.836|    2009|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9232.197|    2008|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9253.318|    2007|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        9108.065|    2006|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8808.564|    2005|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8667.289|    2004|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8416.904|    2003|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8401.016|    2002|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8494.839|    2001|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8659.797|    2000|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8340.564|    1999|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        8245.494|    1998|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7999.858|    1997|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7603.709|    1996|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7307.177|    1995|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7896.121|    1994|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7685.217|    1993|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7532.608|    1992|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7415.506|    1991|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7257.931|    1990|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7044.825|    1989|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        6893.916|    1988|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        6942.826|    1987|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        6951.816|    1986|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7369.866|    1985|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7333.353|    1984|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7228.939|    1983|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7711.239|    1982|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7935.986|    1981|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7467.538|    1980|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        7003.035|    1979|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        6545.368|    1978|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        6165.411|    1977|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        6127.206|    1976|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        6036.819|    1975|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        5881.256|    1974|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        5735.520|    1973|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        5490.266|    1972|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        5238.981|    1971|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        5212.902|    1970|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        5050.561|    1969|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        5036.374|    1968|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        4744.742|    1967|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        4620.520|    1966|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        4490.494|    1965|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        4324.486|    1964|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        3986.441|    1963|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        3804.548|    1962|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        3750.841|    1961|
| Mexico        | Americas  |    1972|     64.65874| lifeExp |  62.361|        3686.395|    1960|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9707.136|    2016|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9612.965|    2015|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9492.551|    2014|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9409.965|    2013|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9414.906|    2012|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9183.328|    2011|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8959.581|    2010|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8657.836|    2009|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9232.197|    2008|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9253.318|    2007|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        9108.065|    2006|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8808.564|    2005|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8667.289|    2004|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8416.904|    2003|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8401.016|    2002|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8494.839|    2001|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8659.797|    2000|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8340.564|    1999|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        8245.494|    1998|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7999.858|    1997|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7603.709|    1996|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7307.177|    1995|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7896.121|    1994|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7685.217|    1993|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7532.608|    1992|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7415.506|    1991|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7257.931|    1990|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7044.825|    1989|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        6893.916|    1988|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        6942.826|    1987|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        6951.816|    1986|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7369.866|    1985|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7333.353|    1984|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7228.939|    1983|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7711.239|    1982|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7935.986|    1981|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7467.538|    1980|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        7003.035|    1979|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        6545.368|    1978|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        6165.411|    1977|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        6127.206|    1976|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        6036.819|    1975|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        5881.256|    1974|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        5735.520|    1973|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        5490.266|    1972|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        5238.981|    1971|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        5212.902|    1970|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        5050.561|    1969|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        5036.374|    1968|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        4744.742|    1967|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        4620.520|    1966|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        4490.494|    1965|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        4324.486|    1964|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        3986.441|    1963|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        3804.548|    1962|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        3750.841|    1961|
| Mexico        | Americas  |    1977|     64.65874| lifeExp |  65.032|        3686.395|    1960|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9707.136|    2016|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9612.965|    2015|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9492.551|    2014|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9409.965|    2013|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9414.906|    2012|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9183.328|    2011|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8959.581|    2010|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8657.836|    2009|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9232.197|    2008|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9253.318|    2007|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        9108.065|    2006|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8808.564|    2005|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8667.289|    2004|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8416.904|    2003|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8401.016|    2002|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8494.839|    2001|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8659.797|    2000|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8340.564|    1999|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        8245.494|    1998|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7999.858|    1997|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7603.709|    1996|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7307.177|    1995|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7896.121|    1994|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7685.217|    1993|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7532.608|    1992|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7415.506|    1991|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7257.931|    1990|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7044.825|    1989|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        6893.916|    1988|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        6942.826|    1987|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        6951.816|    1986|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7369.866|    1985|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7333.353|    1984|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7228.939|    1983|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7711.239|    1982|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7935.986|    1981|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7467.538|    1980|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        7003.035|    1979|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        6545.368|    1978|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        6165.411|    1977|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        6127.206|    1976|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        6036.819|    1975|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        5881.256|    1974|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        5735.520|    1973|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        5490.266|    1972|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        5238.981|    1971|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        5212.902|    1970|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        5050.561|    1969|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        5036.374|    1968|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        4744.742|    1967|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        4620.520|    1966|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        4490.494|    1965|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        4324.486|    1964|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        3986.441|    1963|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        3804.548|    1962|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        3750.841|    1961|
| Mexico        | Americas  |    1982|     64.65874| lifeExp |  67.405|        3686.395|    1960|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9707.136|    2016|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9612.965|    2015|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9492.551|    2014|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9409.965|    2013|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9414.906|    2012|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9183.328|    2011|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8959.581|    2010|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8657.836|    2009|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9232.197|    2008|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9253.318|    2007|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        9108.065|    2006|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8808.564|    2005|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8667.289|    2004|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8416.904|    2003|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8401.016|    2002|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8494.839|    2001|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8659.797|    2000|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8340.564|    1999|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        8245.494|    1998|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7999.858|    1997|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7603.709|    1996|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7307.177|    1995|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7896.121|    1994|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7685.217|    1993|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7532.608|    1992|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7415.506|    1991|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7257.931|    1990|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7044.825|    1989|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        6893.916|    1988|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        6942.826|    1987|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        6951.816|    1986|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7369.866|    1985|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7333.353|    1984|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7228.939|    1983|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7711.239|    1982|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7935.986|    1981|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7467.538|    1980|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        7003.035|    1979|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        6545.368|    1978|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        6165.411|    1977|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        6127.206|    1976|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        6036.819|    1975|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        5881.256|    1974|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        5735.520|    1973|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        5490.266|    1972|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        5238.981|    1971|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        5212.902|    1970|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        5050.561|    1969|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        5036.374|    1968|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        4744.742|    1967|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        4620.520|    1966|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        4490.494|    1965|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        4324.486|    1964|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        3986.441|    1963|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        3804.548|    1962|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        3750.841|    1961|
| Mexico        | Americas  |    1987|     64.65874| lifeExp |  69.498|        3686.395|    1960|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9707.136|    2016|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9612.965|    2015|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9492.551|    2014|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9409.965|    2013|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9414.906|    2012|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9183.328|    2011|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8959.581|    2010|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8657.836|    2009|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9232.197|    2008|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9253.318|    2007|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        9108.065|    2006|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8808.564|    2005|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8667.289|    2004|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8416.904|    2003|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8401.016|    2002|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8494.839|    2001|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8659.797|    2000|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8340.564|    1999|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        8245.494|    1998|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7999.858|    1997|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7603.709|    1996|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7307.177|    1995|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7896.121|    1994|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7685.217|    1993|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7532.608|    1992|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7415.506|    1991|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7257.931|    1990|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7044.825|    1989|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        6893.916|    1988|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        6942.826|    1987|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        6951.816|    1986|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7369.866|    1985|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7333.353|    1984|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7228.939|    1983|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7711.239|    1982|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7935.986|    1981|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7467.538|    1980|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        7003.035|    1979|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        6545.368|    1978|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        6165.411|    1977|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        6127.206|    1976|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        6036.819|    1975|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        5881.256|    1974|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        5735.520|    1973|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        5490.266|    1972|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        5238.981|    1971|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        5212.902|    1970|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        5050.561|    1969|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        5036.374|    1968|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        4744.742|    1967|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        4620.520|    1966|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        4490.494|    1965|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        4324.486|    1964|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        3986.441|    1963|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        3804.548|    1962|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        3750.841|    1961|
| Mexico        | Americas  |    1992|     64.65874| lifeExp |  71.455|        3686.395|    1960|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9707.136|    2016|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9612.965|    2015|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9492.551|    2014|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9409.965|    2013|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9414.906|    2012|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9183.328|    2011|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8959.581|    2010|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8657.836|    2009|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9232.197|    2008|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9253.318|    2007|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        9108.065|    2006|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8808.564|    2005|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8667.289|    2004|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8416.904|    2003|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8401.016|    2002|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8494.839|    2001|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8659.797|    2000|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8340.564|    1999|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        8245.494|    1998|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7999.858|    1997|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7603.709|    1996|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7307.177|    1995|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7896.121|    1994|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7685.217|    1993|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7532.608|    1992|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7415.506|    1991|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7257.931|    1990|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7044.825|    1989|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        6893.916|    1988|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        6942.826|    1987|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        6951.816|    1986|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7369.866|    1985|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7333.353|    1984|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7228.939|    1983|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7711.239|    1982|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7935.986|    1981|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7467.538|    1980|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        7003.035|    1979|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        6545.368|    1978|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        6165.411|    1977|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        6127.206|    1976|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        6036.819|    1975|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        5881.256|    1974|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        5735.520|    1973|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        5490.266|    1972|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        5238.981|    1971|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        5212.902|    1970|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        5050.561|    1969|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        5036.374|    1968|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        4744.742|    1967|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        4620.520|    1966|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        4490.494|    1965|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        4324.486|    1964|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        3986.441|    1963|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        3804.548|    1962|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        3750.841|    1961|
| Mexico        | Americas  |    1997|     64.65874| lifeExp |  73.670|        3686.395|    1960|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9707.136|    2016|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9612.965|    2015|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9492.551|    2014|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9409.965|    2013|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9414.906|    2012|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9183.328|    2011|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8959.581|    2010|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8657.836|    2009|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9232.197|    2008|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9253.318|    2007|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        9108.065|    2006|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8808.564|    2005|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8667.289|    2004|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8416.904|    2003|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8401.016|    2002|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8494.839|    2001|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8659.797|    2000|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8340.564|    1999|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        8245.494|    1998|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7999.858|    1997|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7603.709|    1996|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7307.177|    1995|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7896.121|    1994|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7685.217|    1993|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7532.608|    1992|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7415.506|    1991|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7257.931|    1990|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7044.825|    1989|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        6893.916|    1988|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        6942.826|    1987|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        6951.816|    1986|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7369.866|    1985|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7333.353|    1984|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7228.939|    1983|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7711.239|    1982|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7935.986|    1981|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7467.538|    1980|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        7003.035|    1979|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        6545.368|    1978|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        6165.411|    1977|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        6127.206|    1976|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        6036.819|    1975|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        5881.256|    1974|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        5735.520|    1973|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        5490.266|    1972|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        5238.981|    1971|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        5212.902|    1970|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        5050.561|    1969|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        5036.374|    1968|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        4744.742|    1967|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        4620.520|    1966|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        4490.494|    1965|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        4324.486|    1964|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        3986.441|    1963|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        3804.548|    1962|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        3750.841|    1961|
| Mexico        | Americas  |    2002|     64.65874| lifeExp |  74.902|        3686.395|    1960|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9707.136|    2016|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9612.965|    2015|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9492.551|    2014|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9409.965|    2013|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9414.906|    2012|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9183.328|    2011|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8959.581|    2010|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8657.836|    2009|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9232.197|    2008|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9253.318|    2007|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        9108.065|    2006|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8808.564|    2005|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8667.289|    2004|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8416.904|    2003|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8401.016|    2002|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8494.839|    2001|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8659.797|    2000|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8340.564|    1999|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        8245.494|    1998|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7999.858|    1997|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7603.709|    1996|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7307.177|    1995|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7896.121|    1994|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7685.217|    1993|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7532.608|    1992|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7415.506|    1991|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7257.931|    1990|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7044.825|    1989|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        6893.916|    1988|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        6942.826|    1987|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        6951.816|    1986|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7369.866|    1985|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7333.353|    1984|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7228.939|    1983|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7711.239|    1982|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7935.986|    1981|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7467.538|    1980|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        7003.035|    1979|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        6545.368|    1978|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        6165.411|    1977|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        6127.206|    1976|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        6036.819|    1975|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        5881.256|    1974|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        5735.520|    1973|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        5490.266|    1972|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        5238.981|    1971|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        5212.902|    1970|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        5050.561|    1969|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        5036.374|    1968|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        4744.742|    1967|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        4620.520|    1966|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        4490.494|    1965|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        4324.486|    1964|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        3986.441|    1963|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        3804.548|    1962|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        3750.841|    1961|
| Mexico        | Americas  |    2007|     64.65874| lifeExp |  76.195|        3686.395|    1960|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       52194.886|    2016|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       51722.097|    2015|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       50782.521|    2014|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       49976.629|    2013|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       49497.586|    2012|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       48783.469|    2011|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       48373.879|    2010|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       47575.609|    2009|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       49364.645|    2008|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       49979.534|    2007|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       49575.401|    2006|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       48755.616|    2005|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       47614.280|    2004|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       46304.036|    2003|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       45428.646|    2002|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       45047.487|    2001|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       45055.818|    2000|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       43768.885|    1999|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       42292.891|    1998|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       40965.847|    1997|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       39681.520|    1996|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       38677.715|    1995|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       38104.972|    1994|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       37078.050|    1993|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       36566.174|    1992|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       35803.868|    1991|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       36312.414|    1990|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       36033.330|    1989|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       35083.969|    1988|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       33975.655|    1987|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       33133.695|    1986|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       32306.833|    1985|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       31268.976|    1984|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       29406.257|    1983|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       28362.495|    1982|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       29191.999|    1981|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       28734.399|    1980|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       29082.594|    1979|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       28500.240|    1978|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       27286.252|    1977|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       26347.809|    1976|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       25239.920|    1975|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       25540.501|    1974|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       25908.913|    1973|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       24760.145|    1972|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       23775.277|    1971|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       23309.621|    1970|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       22850.011|    1969|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       22380.607|    1968|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       21569.836|    1967|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       21274.135|    1966|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       20207.750|    1965|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       19231.172|    1964|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       18431.158|    1963|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       17910.279|    1962|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       17142.194|    1961|
| United States | Americas  |    1952|     64.65874| lifeExp |  68.440|       17036.885|    1960|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       52194.886|    2016|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       51722.097|    2015|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       50782.521|    2014|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       49976.629|    2013|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       49497.586|    2012|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       48783.469|    2011|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       48373.879|    2010|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       47575.609|    2009|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       49364.645|    2008|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       49979.534|    2007|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       49575.401|    2006|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       48755.616|    2005|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       47614.280|    2004|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       46304.036|    2003|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       45428.646|    2002|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       45047.487|    2001|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       45055.818|    2000|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       43768.885|    1999|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       42292.891|    1998|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       40965.847|    1997|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       39681.520|    1996|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       38677.715|    1995|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       38104.972|    1994|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       37078.050|    1993|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       36566.174|    1992|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       35803.868|    1991|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       36312.414|    1990|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       36033.330|    1989|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       35083.969|    1988|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       33975.655|    1987|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       33133.695|    1986|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       32306.833|    1985|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       31268.976|    1984|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       29406.257|    1983|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       28362.495|    1982|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       29191.999|    1981|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       28734.399|    1980|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       29082.594|    1979|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       28500.240|    1978|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       27286.252|    1977|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       26347.809|    1976|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       25239.920|    1975|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       25540.501|    1974|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       25908.913|    1973|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       24760.145|    1972|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       23775.277|    1971|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       23309.621|    1970|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       22850.011|    1969|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       22380.607|    1968|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       21569.836|    1967|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       21274.135|    1966|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       20207.750|    1965|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       19231.172|    1964|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       18431.158|    1963|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       17910.279|    1962|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       17142.194|    1961|
| United States | Americas  |    1957|     64.65874| lifeExp |  69.490|       17036.885|    1960|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       52194.886|    2016|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       51722.097|    2015|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       50782.521|    2014|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       49976.629|    2013|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       49497.586|    2012|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       48783.469|    2011|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       48373.879|    2010|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       47575.609|    2009|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       49364.645|    2008|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       49979.534|    2007|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       49575.401|    2006|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       48755.616|    2005|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       47614.280|    2004|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       46304.036|    2003|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       45428.646|    2002|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       45047.487|    2001|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       45055.818|    2000|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       43768.885|    1999|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       42292.891|    1998|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       40965.847|    1997|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       39681.520|    1996|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       38677.715|    1995|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       38104.972|    1994|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       37078.050|    1993|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       36566.174|    1992|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       35803.868|    1991|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       36312.414|    1990|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       36033.330|    1989|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       35083.969|    1988|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       33975.655|    1987|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       33133.695|    1986|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       32306.833|    1985|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       31268.976|    1984|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       29406.257|    1983|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       28362.495|    1982|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       29191.999|    1981|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       28734.399|    1980|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       29082.594|    1979|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       28500.240|    1978|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       27286.252|    1977|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       26347.809|    1976|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       25239.920|    1975|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       25540.501|    1974|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       25908.913|    1973|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       24760.145|    1972|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       23775.277|    1971|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       23309.621|    1970|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       22850.011|    1969|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       22380.607|    1968|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       21569.836|    1967|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       21274.135|    1966|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       20207.750|    1965|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       19231.172|    1964|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       18431.158|    1963|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       17910.279|    1962|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       17142.194|    1961|
| United States | Americas  |    1962|     64.65874| lifeExp |  70.210|       17036.885|    1960|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       52194.886|    2016|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       51722.097|    2015|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       50782.521|    2014|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       49976.629|    2013|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       49497.586|    2012|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       48783.469|    2011|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       48373.879|    2010|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       47575.609|    2009|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       49364.645|    2008|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       49979.534|    2007|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       49575.401|    2006|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       48755.616|    2005|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       47614.280|    2004|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       46304.036|    2003|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       45428.646|    2002|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       45047.487|    2001|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       45055.818|    2000|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       43768.885|    1999|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       42292.891|    1998|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       40965.847|    1997|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       39681.520|    1996|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       38677.715|    1995|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       38104.972|    1994|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       37078.050|    1993|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       36566.174|    1992|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       35803.868|    1991|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       36312.414|    1990|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       36033.330|    1989|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       35083.969|    1988|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       33975.655|    1987|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       33133.695|    1986|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       32306.833|    1985|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       31268.976|    1984|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       29406.257|    1983|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       28362.495|    1982|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       29191.999|    1981|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       28734.399|    1980|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       29082.594|    1979|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       28500.240|    1978|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       27286.252|    1977|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       26347.809|    1976|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       25239.920|    1975|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       25540.501|    1974|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       25908.913|    1973|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       24760.145|    1972|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       23775.277|    1971|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       23309.621|    1970|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       22850.011|    1969|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       22380.607|    1968|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       21569.836|    1967|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       21274.135|    1966|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       20207.750|    1965|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       19231.172|    1964|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       18431.158|    1963|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       17910.279|    1962|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       17142.194|    1961|
| United States | Americas  |    1967|     64.65874| lifeExp |  70.760|       17036.885|    1960|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       52194.886|    2016|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       51722.097|    2015|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       50782.521|    2014|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       49976.629|    2013|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       49497.586|    2012|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       48783.469|    2011|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       48373.879|    2010|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       47575.609|    2009|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       49364.645|    2008|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       49979.534|    2007|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       49575.401|    2006|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       48755.616|    2005|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       47614.280|    2004|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       46304.036|    2003|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       45428.646|    2002|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       45047.487|    2001|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       45055.818|    2000|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       43768.885|    1999|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       42292.891|    1998|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       40965.847|    1997|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       39681.520|    1996|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       38677.715|    1995|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       38104.972|    1994|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       37078.050|    1993|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       36566.174|    1992|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       35803.868|    1991|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       36312.414|    1990|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       36033.330|    1989|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       35083.969|    1988|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       33975.655|    1987|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       33133.695|    1986|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       32306.833|    1985|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       31268.976|    1984|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       29406.257|    1983|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       28362.495|    1982|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       29191.999|    1981|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       28734.399|    1980|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       29082.594|    1979|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       28500.240|    1978|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       27286.252|    1977|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       26347.809|    1976|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       25239.920|    1975|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       25540.501|    1974|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       25908.913|    1973|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       24760.145|    1972|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       23775.277|    1971|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       23309.621|    1970|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       22850.011|    1969|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       22380.607|    1968|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       21569.836|    1967|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       21274.135|    1966|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       20207.750|    1965|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       19231.172|    1964|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       18431.158|    1963|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       17910.279|    1962|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       17142.194|    1961|
| United States | Americas  |    1972|     64.65874| lifeExp |  71.340|       17036.885|    1960|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       52194.886|    2016|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       51722.097|    2015|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       50782.521|    2014|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       49976.629|    2013|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       49497.586|    2012|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       48783.469|    2011|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       48373.879|    2010|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       47575.609|    2009|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       49364.645|    2008|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       49979.534|    2007|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       49575.401|    2006|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       48755.616|    2005|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       47614.280|    2004|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       46304.036|    2003|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       45428.646|    2002|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       45047.487|    2001|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       45055.818|    2000|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       43768.885|    1999|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       42292.891|    1998|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       40965.847|    1997|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       39681.520|    1996|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       38677.715|    1995|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       38104.972|    1994|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       37078.050|    1993|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       36566.174|    1992|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       35803.868|    1991|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       36312.414|    1990|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       36033.330|    1989|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       35083.969|    1988|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       33975.655|    1987|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       33133.695|    1986|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       32306.833|    1985|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       31268.976|    1984|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       29406.257|    1983|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       28362.495|    1982|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       29191.999|    1981|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       28734.399|    1980|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       29082.594|    1979|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       28500.240|    1978|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       27286.252|    1977|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       26347.809|    1976|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       25239.920|    1975|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       25540.501|    1974|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       25908.913|    1973|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       24760.145|    1972|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       23775.277|    1971|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       23309.621|    1970|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       22850.011|    1969|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       22380.607|    1968|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       21569.836|    1967|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       21274.135|    1966|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       20207.750|    1965|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       19231.172|    1964|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       18431.158|    1963|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       17910.279|    1962|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       17142.194|    1961|
| United States | Americas  |    1977|     64.65874| lifeExp |  73.380|       17036.885|    1960|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       52194.886|    2016|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       51722.097|    2015|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       50782.521|    2014|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       49976.629|    2013|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       49497.586|    2012|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       48783.469|    2011|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       48373.879|    2010|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       47575.609|    2009|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       49364.645|    2008|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       49979.534|    2007|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       49575.401|    2006|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       48755.616|    2005|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       47614.280|    2004|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       46304.036|    2003|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       45428.646|    2002|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       45047.487|    2001|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       45055.818|    2000|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       43768.885|    1999|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       42292.891|    1998|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       40965.847|    1997|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       39681.520|    1996|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       38677.715|    1995|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       38104.972|    1994|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       37078.050|    1993|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       36566.174|    1992|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       35803.868|    1991|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       36312.414|    1990|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       36033.330|    1989|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       35083.969|    1988|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       33975.655|    1987|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       33133.695|    1986|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       32306.833|    1985|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       31268.976|    1984|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       29406.257|    1983|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       28362.495|    1982|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       29191.999|    1981|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       28734.399|    1980|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       29082.594|    1979|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       28500.240|    1978|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       27286.252|    1977|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       26347.809|    1976|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       25239.920|    1975|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       25540.501|    1974|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       25908.913|    1973|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       24760.145|    1972|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       23775.277|    1971|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       23309.621|    1970|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       22850.011|    1969|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       22380.607|    1968|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       21569.836|    1967|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       21274.135|    1966|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       20207.750|    1965|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       19231.172|    1964|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       18431.158|    1963|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       17910.279|    1962|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       17142.194|    1961|
| United States | Americas  |    1982|     64.65874| lifeExp |  74.650|       17036.885|    1960|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       52194.886|    2016|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       51722.097|    2015|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       50782.521|    2014|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       49976.629|    2013|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       49497.586|    2012|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       48783.469|    2011|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       48373.879|    2010|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       47575.609|    2009|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       49364.645|    2008|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       49979.534|    2007|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       49575.401|    2006|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       48755.616|    2005|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       47614.280|    2004|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       46304.036|    2003|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       45428.646|    2002|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       45047.487|    2001|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       45055.818|    2000|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       43768.885|    1999|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       42292.891|    1998|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       40965.847|    1997|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       39681.520|    1996|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       38677.715|    1995|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       38104.972|    1994|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       37078.050|    1993|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       36566.174|    1992|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       35803.868|    1991|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       36312.414|    1990|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       36033.330|    1989|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       35083.969|    1988|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       33975.655|    1987|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       33133.695|    1986|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       32306.833|    1985|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       31268.976|    1984|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       29406.257|    1983|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       28362.495|    1982|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       29191.999|    1981|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       28734.399|    1980|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       29082.594|    1979|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       28500.240|    1978|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       27286.252|    1977|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       26347.809|    1976|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       25239.920|    1975|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       25540.501|    1974|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       25908.913|    1973|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       24760.145|    1972|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       23775.277|    1971|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       23309.621|    1970|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       22850.011|    1969|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       22380.607|    1968|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       21569.836|    1967|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       21274.135|    1966|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       20207.750|    1965|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       19231.172|    1964|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       18431.158|    1963|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       17910.279|    1962|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       17142.194|    1961|
| United States | Americas  |    1987|     64.65874| lifeExp |  75.020|       17036.885|    1960|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       52194.886|    2016|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       51722.097|    2015|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       50782.521|    2014|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       49976.629|    2013|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       49497.586|    2012|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       48783.469|    2011|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       48373.879|    2010|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       47575.609|    2009|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       49364.645|    2008|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       49979.534|    2007|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       49575.401|    2006|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       48755.616|    2005|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       47614.280|    2004|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       46304.036|    2003|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       45428.646|    2002|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       45047.487|    2001|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       45055.818|    2000|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       43768.885|    1999|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       42292.891|    1998|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       40965.847|    1997|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       39681.520|    1996|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       38677.715|    1995|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       38104.972|    1994|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       37078.050|    1993|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       36566.174|    1992|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       35803.868|    1991|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       36312.414|    1990|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       36033.330|    1989|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       35083.969|    1988|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       33975.655|    1987|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       33133.695|    1986|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       32306.833|    1985|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       31268.976|    1984|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       29406.257|    1983|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       28362.495|    1982|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       29191.999|    1981|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       28734.399|    1980|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       29082.594|    1979|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       28500.240|    1978|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       27286.252|    1977|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       26347.809|    1976|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       25239.920|    1975|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       25540.501|    1974|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       25908.913|    1973|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       24760.145|    1972|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       23775.277|    1971|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       23309.621|    1970|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       22850.011|    1969|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       22380.607|    1968|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       21569.836|    1967|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       21274.135|    1966|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       20207.750|    1965|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       19231.172|    1964|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       18431.158|    1963|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       17910.279|    1962|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       17142.194|    1961|
| United States | Americas  |    1992|     64.65874| lifeExp |  76.090|       17036.885|    1960|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       52194.886|    2016|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       51722.097|    2015|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       50782.521|    2014|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       49976.629|    2013|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       49497.586|    2012|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       48783.469|    2011|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       48373.879|    2010|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       47575.609|    2009|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       49364.645|    2008|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       49979.534|    2007|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       49575.401|    2006|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       48755.616|    2005|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       47614.280|    2004|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       46304.036|    2003|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       45428.646|    2002|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       45047.487|    2001|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       45055.818|    2000|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       43768.885|    1999|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       42292.891|    1998|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       40965.847|    1997|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       39681.520|    1996|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       38677.715|    1995|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       38104.972|    1994|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       37078.050|    1993|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       36566.174|    1992|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       35803.868|    1991|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       36312.414|    1990|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       36033.330|    1989|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       35083.969|    1988|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       33975.655|    1987|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       33133.695|    1986|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       32306.833|    1985|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       31268.976|    1984|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       29406.257|    1983|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       28362.495|    1982|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       29191.999|    1981|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       28734.399|    1980|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       29082.594|    1979|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       28500.240|    1978|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       27286.252|    1977|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       26347.809|    1976|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       25239.920|    1975|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       25540.501|    1974|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       25908.913|    1973|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       24760.145|    1972|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       23775.277|    1971|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       23309.621|    1970|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       22850.011|    1969|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       22380.607|    1968|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       21569.836|    1967|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       21274.135|    1966|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       20207.750|    1965|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       19231.172|    1964|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       18431.158|    1963|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       17910.279|    1962|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       17142.194|    1961|
| United States | Americas  |    1997|     64.65874| lifeExp |  76.810|       17036.885|    1960|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       52194.886|    2016|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       51722.097|    2015|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       50782.521|    2014|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       49976.629|    2013|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       49497.586|    2012|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       48783.469|    2011|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       48373.879|    2010|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       47575.609|    2009|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       49364.645|    2008|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       49979.534|    2007|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       49575.401|    2006|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       48755.616|    2005|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       47614.280|    2004|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       46304.036|    2003|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       45428.646|    2002|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       45047.487|    2001|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       45055.818|    2000|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       43768.885|    1999|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       42292.891|    1998|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       40965.847|    1997|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       39681.520|    1996|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       38677.715|    1995|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       38104.972|    1994|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       37078.050|    1993|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       36566.174|    1992|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       35803.868|    1991|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       36312.414|    1990|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       36033.330|    1989|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       35083.969|    1988|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       33975.655|    1987|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       33133.695|    1986|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       32306.833|    1985|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       31268.976|    1984|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       29406.257|    1983|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       28362.495|    1982|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       29191.999|    1981|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       28734.399|    1980|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       29082.594|    1979|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       28500.240|    1978|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       27286.252|    1977|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       26347.809|    1976|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       25239.920|    1975|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       25540.501|    1974|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       25908.913|    1973|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       24760.145|    1972|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       23775.277|    1971|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       23309.621|    1970|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       22850.011|    1969|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       22380.607|    1968|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       21569.836|    1967|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       21274.135|    1966|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       20207.750|    1965|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       19231.172|    1964|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       18431.158|    1963|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       17910.279|    1962|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       17142.194|    1961|
| United States | Americas  |    2002|     64.65874| lifeExp |  77.310|       17036.885|    1960|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       52194.886|    2016|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       51722.097|    2015|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       50782.521|    2014|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       49976.629|    2013|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       49497.586|    2012|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       48783.469|    2011|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       48373.879|    2010|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       47575.609|    2009|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       49364.645|    2008|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       49979.534|    2007|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       49575.401|    2006|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       48755.616|    2005|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       47614.280|    2004|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       46304.036|    2003|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       45428.646|    2002|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       45047.487|    2001|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       45055.818|    2000|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       43768.885|    1999|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       42292.891|    1998|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       40965.847|    1997|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       39681.520|    1996|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       38677.715|    1995|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       38104.972|    1994|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       37078.050|    1993|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       36566.174|    1992|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       35803.868|    1991|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       36312.414|    1990|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       36033.330|    1989|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       35083.969|    1988|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       33975.655|    1987|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       33133.695|    1986|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       32306.833|    1985|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       31268.976|    1984|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       29406.257|    1983|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       28362.495|    1982|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       29191.999|    1981|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       28734.399|    1980|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       29082.594|    1979|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       28500.240|    1978|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       27286.252|    1977|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       26347.809|    1976|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       25239.920|    1975|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       25540.501|    1974|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       25908.913|    1973|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       24760.145|    1972|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       23775.277|    1971|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       23309.621|    1970|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       22850.011|    1969|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       22380.607|    1968|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       21569.836|    1967|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       21274.135|    1966|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       20207.750|    1965|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       19231.172|    1964|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       18431.158|    1963|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       17910.279|    1962|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       17142.194|    1961|
| United States | Americas  |    2007|     64.65874| lifeExp |  78.242|       17036.885|    1960|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       14009.998|    2016|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       13859.407|    2015|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       13856.695|    2014|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       13467.438|    2013|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       12913.104|    2012|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       12512.913|    2011|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       11938.212|    2010|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       11112.456|    2009|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       10698.052|    2008|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|       10014.872|    2007|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        9424.517|    2006|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        9068.239|    2005|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        8442.550|    2004|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        8036.479|    2003|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        7967.163|    2002|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        8636.545|    2001|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        8997.660|    2000|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        9207.792|    1999|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        9438.883|    1998|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        9089.123|    1997|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        8432.621|    1996|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        8044.642|    1995|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        8221.949|    1994|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        7720.467|    1993|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        7576.146|    1992|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        7070.506|    1991|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6877.287|    1990|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6903.525|    1989|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6872.389|    1988|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6814.581|    1987|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6349.604|    1986|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5872.571|    1985|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5824.946|    1984|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5930.284|    1983|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6652.268|    1982|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        7419.914|    1981|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        7354.228|    1980|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6995.612|    1979|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6633.200|    1978|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6336.468|    1977|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6280.022|    1976|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        6066.265|    1975|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5730.020|    1974|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5572.708|    1973|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5558.678|    1972|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5639.344|    1971|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5670.611|    1970|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5570.576|    1969|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5300.418|    1968|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5248.841|    1967|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5502.523|    1966|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5395.151|    1965|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5397.710|    1964|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5329.625|    1963|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5384.393|    1962|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5539.019|    1961|
| Uruguay       | Americas  |    1952|     64.65874| lifeExp |  66.071|        5474.622|    1960|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       14009.998|    2016|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       13859.407|    2015|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       13856.695|    2014|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       13467.438|    2013|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       12913.104|    2012|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       12512.913|    2011|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       11938.212|    2010|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       11112.456|    2009|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       10698.052|    2008|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|       10014.872|    2007|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        9424.517|    2006|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        9068.239|    2005|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        8442.550|    2004|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        8036.479|    2003|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        7967.163|    2002|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        8636.545|    2001|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        8997.660|    2000|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        9207.792|    1999|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        9438.883|    1998|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        9089.123|    1997|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        8432.621|    1996|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        8044.642|    1995|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        8221.949|    1994|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        7720.467|    1993|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        7576.146|    1992|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        7070.506|    1991|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6877.287|    1990|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6903.525|    1989|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6872.389|    1988|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6814.581|    1987|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6349.604|    1986|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5872.571|    1985|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5824.946|    1984|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5930.284|    1983|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6652.268|    1982|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        7419.914|    1981|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        7354.228|    1980|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6995.612|    1979|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6633.200|    1978|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6336.468|    1977|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6280.022|    1976|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        6066.265|    1975|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5730.020|    1974|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5572.708|    1973|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5558.678|    1972|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5639.344|    1971|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5670.611|    1970|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5570.576|    1969|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5300.418|    1968|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5248.841|    1967|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5502.523|    1966|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5395.151|    1965|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5397.710|    1964|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5329.625|    1963|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5384.393|    1962|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5539.019|    1961|
| Uruguay       | Americas  |    1957|     64.65874| lifeExp |  67.044|        5474.622|    1960|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       14009.998|    2016|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       13859.407|    2015|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       13856.695|    2014|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       13467.438|    2013|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       12913.104|    2012|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       12512.913|    2011|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       11938.212|    2010|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       11112.456|    2009|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       10698.052|    2008|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|       10014.872|    2007|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        9424.517|    2006|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        9068.239|    2005|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        8442.550|    2004|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        8036.479|    2003|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        7967.163|    2002|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        8636.545|    2001|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        8997.660|    2000|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        9207.792|    1999|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        9438.883|    1998|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        9089.123|    1997|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        8432.621|    1996|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        8044.642|    1995|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        8221.949|    1994|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        7720.467|    1993|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        7576.146|    1992|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        7070.506|    1991|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6877.287|    1990|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6903.525|    1989|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6872.389|    1988|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6814.581|    1987|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6349.604|    1986|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5872.571|    1985|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5824.946|    1984|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5930.284|    1983|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6652.268|    1982|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        7419.914|    1981|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        7354.228|    1980|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6995.612|    1979|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6633.200|    1978|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6336.468|    1977|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6280.022|    1976|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        6066.265|    1975|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5730.020|    1974|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5572.708|    1973|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5558.678|    1972|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5639.344|    1971|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5670.611|    1970|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5570.576|    1969|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5300.418|    1968|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5248.841|    1967|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5502.523|    1966|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5395.151|    1965|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5397.710|    1964|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5329.625|    1963|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5384.393|    1962|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5539.019|    1961|
| Uruguay       | Americas  |    1962|     64.65874| lifeExp |  68.253|        5474.622|    1960|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       14009.998|    2016|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       13859.407|    2015|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       13856.695|    2014|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       13467.438|    2013|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       12913.104|    2012|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       12512.913|    2011|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       11938.212|    2010|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       11112.456|    2009|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       10698.052|    2008|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|       10014.872|    2007|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        9424.517|    2006|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        9068.239|    2005|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        8442.550|    2004|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        8036.479|    2003|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        7967.163|    2002|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        8636.545|    2001|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        8997.660|    2000|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        9207.792|    1999|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        9438.883|    1998|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        9089.123|    1997|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        8432.621|    1996|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        8044.642|    1995|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        8221.949|    1994|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        7720.467|    1993|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        7576.146|    1992|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        7070.506|    1991|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6877.287|    1990|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6903.525|    1989|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6872.389|    1988|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6814.581|    1987|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6349.604|    1986|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5872.571|    1985|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5824.946|    1984|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5930.284|    1983|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6652.268|    1982|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        7419.914|    1981|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        7354.228|    1980|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6995.612|    1979|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6633.200|    1978|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6336.468|    1977|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6280.022|    1976|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        6066.265|    1975|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5730.020|    1974|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5572.708|    1973|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5558.678|    1972|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5639.344|    1971|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5670.611|    1970|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5570.576|    1969|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5300.418|    1968|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5248.841|    1967|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5502.523|    1966|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5395.151|    1965|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5397.710|    1964|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5329.625|    1963|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5384.393|    1962|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5539.019|    1961|
| Uruguay       | Americas  |    1967|     64.65874| lifeExp |  68.468|        5474.622|    1960|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       14009.998|    2016|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       13859.407|    2015|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       13856.695|    2014|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       13467.438|    2013|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       12913.104|    2012|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       12512.913|    2011|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       11938.212|    2010|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       11112.456|    2009|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       10698.052|    2008|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|       10014.872|    2007|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        9424.517|    2006|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        9068.239|    2005|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        8442.550|    2004|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        8036.479|    2003|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        7967.163|    2002|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        8636.545|    2001|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        8997.660|    2000|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        9207.792|    1999|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        9438.883|    1998|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        9089.123|    1997|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        8432.621|    1996|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        8044.642|    1995|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        8221.949|    1994|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        7720.467|    1993|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        7576.146|    1992|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        7070.506|    1991|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6877.287|    1990|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6903.525|    1989|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6872.389|    1988|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6814.581|    1987|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6349.604|    1986|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5872.571|    1985|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5824.946|    1984|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5930.284|    1983|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6652.268|    1982|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        7419.914|    1981|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        7354.228|    1980|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6995.612|    1979|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6633.200|    1978|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6336.468|    1977|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6280.022|    1976|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        6066.265|    1975|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5730.020|    1974|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5572.708|    1973|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5558.678|    1972|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5639.344|    1971|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5670.611|    1970|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5570.576|    1969|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5300.418|    1968|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5248.841|    1967|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5502.523|    1966|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5395.151|    1965|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5397.710|    1964|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5329.625|    1963|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5384.393|    1962|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5539.019|    1961|
| Uruguay       | Americas  |    1972|     64.65874| lifeExp |  68.673|        5474.622|    1960|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       14009.998|    2016|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       13859.407|    2015|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       13856.695|    2014|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       13467.438|    2013|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       12913.104|    2012|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       12512.913|    2011|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       11938.212|    2010|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       11112.456|    2009|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       10698.052|    2008|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|       10014.872|    2007|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        9424.517|    2006|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        9068.239|    2005|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        8442.550|    2004|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        8036.479|    2003|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        7967.163|    2002|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        8636.545|    2001|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        8997.660|    2000|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        9207.792|    1999|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        9438.883|    1998|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        9089.123|    1997|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        8432.621|    1996|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        8044.642|    1995|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        8221.949|    1994|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        7720.467|    1993|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        7576.146|    1992|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        7070.506|    1991|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6877.287|    1990|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6903.525|    1989|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6872.389|    1988|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6814.581|    1987|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6349.604|    1986|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5872.571|    1985|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5824.946|    1984|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5930.284|    1983|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6652.268|    1982|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        7419.914|    1981|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        7354.228|    1980|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6995.612|    1979|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6633.200|    1978|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6336.468|    1977|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6280.022|    1976|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        6066.265|    1975|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5730.020|    1974|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5572.708|    1973|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5558.678|    1972|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5639.344|    1971|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5670.611|    1970|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5570.576|    1969|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5300.418|    1968|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5248.841|    1967|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5502.523|    1966|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5395.151|    1965|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5397.710|    1964|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5329.625|    1963|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5384.393|    1962|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5539.019|    1961|
| Uruguay       | Americas  |    1977|     64.65874| lifeExp |  69.481|        5474.622|    1960|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       14009.998|    2016|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       13859.407|    2015|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       13856.695|    2014|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       13467.438|    2013|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       12913.104|    2012|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       12512.913|    2011|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       11938.212|    2010|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       11112.456|    2009|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       10698.052|    2008|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|       10014.872|    2007|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        9424.517|    2006|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        9068.239|    2005|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        8442.550|    2004|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        8036.479|    2003|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        7967.163|    2002|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        8636.545|    2001|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        8997.660|    2000|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        9207.792|    1999|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        9438.883|    1998|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        9089.123|    1997|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        8432.621|    1996|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        8044.642|    1995|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        8221.949|    1994|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        7720.467|    1993|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        7576.146|    1992|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        7070.506|    1991|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6877.287|    1990|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6903.525|    1989|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6872.389|    1988|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6814.581|    1987|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6349.604|    1986|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5872.571|    1985|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5824.946|    1984|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5930.284|    1983|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6652.268|    1982|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        7419.914|    1981|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        7354.228|    1980|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6995.612|    1979|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6633.200|    1978|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6336.468|    1977|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6280.022|    1976|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        6066.265|    1975|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5730.020|    1974|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5572.708|    1973|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5558.678|    1972|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5639.344|    1971|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5670.611|    1970|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5570.576|    1969|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5300.418|    1968|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5248.841|    1967|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5502.523|    1966|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5395.151|    1965|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5397.710|    1964|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5329.625|    1963|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5384.393|    1962|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5539.019|    1961|
| Uruguay       | Americas  |    1982|     64.65874| lifeExp |  70.805|        5474.622|    1960|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       14009.998|    2016|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       13859.407|    2015|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       13856.695|    2014|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       13467.438|    2013|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       12913.104|    2012|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       12512.913|    2011|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       11938.212|    2010|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       11112.456|    2009|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       10698.052|    2008|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|       10014.872|    2007|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        9424.517|    2006|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        9068.239|    2005|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        8442.550|    2004|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        8036.479|    2003|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        7967.163|    2002|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        8636.545|    2001|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        8997.660|    2000|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        9207.792|    1999|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        9438.883|    1998|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        9089.123|    1997|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        8432.621|    1996|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        8044.642|    1995|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        8221.949|    1994|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        7720.467|    1993|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        7576.146|    1992|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        7070.506|    1991|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6877.287|    1990|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6903.525|    1989|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6872.389|    1988|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6814.581|    1987|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6349.604|    1986|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5872.571|    1985|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5824.946|    1984|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5930.284|    1983|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6652.268|    1982|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        7419.914|    1981|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        7354.228|    1980|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6995.612|    1979|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6633.200|    1978|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6336.468|    1977|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6280.022|    1976|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        6066.265|    1975|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5730.020|    1974|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5572.708|    1973|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5558.678|    1972|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5639.344|    1971|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5670.611|    1970|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5570.576|    1969|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5300.418|    1968|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5248.841|    1967|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5502.523|    1966|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5395.151|    1965|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5397.710|    1964|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5329.625|    1963|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5384.393|    1962|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5539.019|    1961|
| Uruguay       | Americas  |    1987|     64.65874| lifeExp |  71.918|        5474.622|    1960|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       14009.998|    2016|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       13859.407|    2015|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       13856.695|    2014|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       13467.438|    2013|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       12913.104|    2012|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       12512.913|    2011|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       11938.212|    2010|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       11112.456|    2009|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       10698.052|    2008|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|       10014.872|    2007|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        9424.517|    2006|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        9068.239|    2005|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        8442.550|    2004|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        8036.479|    2003|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        7967.163|    2002|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        8636.545|    2001|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        8997.660|    2000|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        9207.792|    1999|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        9438.883|    1998|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        9089.123|    1997|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        8432.621|    1996|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        8044.642|    1995|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        8221.949|    1994|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        7720.467|    1993|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        7576.146|    1992|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        7070.506|    1991|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6877.287|    1990|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6903.525|    1989|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6872.389|    1988|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6814.581|    1987|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6349.604|    1986|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5872.571|    1985|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5824.946|    1984|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5930.284|    1983|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6652.268|    1982|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        7419.914|    1981|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        7354.228|    1980|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6995.612|    1979|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6633.200|    1978|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6336.468|    1977|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6280.022|    1976|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        6066.265|    1975|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5730.020|    1974|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5572.708|    1973|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5558.678|    1972|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5639.344|    1971|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5670.611|    1970|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5570.576|    1969|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5300.418|    1968|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5248.841|    1967|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5502.523|    1966|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5395.151|    1965|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5397.710|    1964|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5329.625|    1963|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5384.393|    1962|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5539.019|    1961|
| Uruguay       | Americas  |    1992|     64.65874| lifeExp |  72.752|        5474.622|    1960|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       14009.998|    2016|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       13859.407|    2015|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       13856.695|    2014|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       13467.438|    2013|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       12913.104|    2012|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       12512.913|    2011|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       11938.212|    2010|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       11112.456|    2009|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       10698.052|    2008|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|       10014.872|    2007|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        9424.517|    2006|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        9068.239|    2005|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        8442.550|    2004|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        8036.479|    2003|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        7967.163|    2002|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        8636.545|    2001|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        8997.660|    2000|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        9207.792|    1999|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        9438.883|    1998|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        9089.123|    1997|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        8432.621|    1996|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        8044.642|    1995|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        8221.949|    1994|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        7720.467|    1993|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        7576.146|    1992|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        7070.506|    1991|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6877.287|    1990|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6903.525|    1989|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6872.389|    1988|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6814.581|    1987|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6349.604|    1986|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5872.571|    1985|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5824.946|    1984|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5930.284|    1983|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6652.268|    1982|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        7419.914|    1981|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        7354.228|    1980|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6995.612|    1979|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6633.200|    1978|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6336.468|    1977|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6280.022|    1976|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        6066.265|    1975|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5730.020|    1974|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5572.708|    1973|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5558.678|    1972|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5639.344|    1971|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5670.611|    1970|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5570.576|    1969|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5300.418|    1968|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5248.841|    1967|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5502.523|    1966|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5395.151|    1965|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5397.710|    1964|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5329.625|    1963|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5384.393|    1962|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5539.019|    1961|
| Uruguay       | Americas  |    1997|     64.65874| lifeExp |  74.223|        5474.622|    1960|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       14009.998|    2016|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       13859.407|    2015|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       13856.695|    2014|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       13467.438|    2013|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       12913.104|    2012|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       12512.913|    2011|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       11938.212|    2010|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       11112.456|    2009|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       10698.052|    2008|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|       10014.872|    2007|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        9424.517|    2006|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        9068.239|    2005|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        8442.550|    2004|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        8036.479|    2003|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        7967.163|    2002|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        8636.545|    2001|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        8997.660|    2000|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        9207.792|    1999|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        9438.883|    1998|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        9089.123|    1997|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        8432.621|    1996|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        8044.642|    1995|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        8221.949|    1994|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        7720.467|    1993|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        7576.146|    1992|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        7070.506|    1991|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6877.287|    1990|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6903.525|    1989|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6872.389|    1988|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6814.581|    1987|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6349.604|    1986|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5872.571|    1985|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5824.946|    1984|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5930.284|    1983|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6652.268|    1982|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        7419.914|    1981|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        7354.228|    1980|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6995.612|    1979|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6633.200|    1978|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6336.468|    1977|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6280.022|    1976|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        6066.265|    1975|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5730.020|    1974|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5572.708|    1973|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5558.678|    1972|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5639.344|    1971|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5670.611|    1970|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5570.576|    1969|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5300.418|    1968|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5248.841|    1967|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5502.523|    1966|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5395.151|    1965|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5397.710|    1964|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5329.625|    1963|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5384.393|    1962|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5539.019|    1961|
| Uruguay       | Americas  |    2002|     64.65874| lifeExp |  75.307|        5474.622|    1960|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       14009.998|    2016|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       13859.407|    2015|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       13856.695|    2014|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       13467.438|    2013|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       12913.104|    2012|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       12512.913|    2011|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       11938.212|    2010|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       11112.456|    2009|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       10698.052|    2008|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|       10014.872|    2007|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        9424.517|    2006|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        9068.239|    2005|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        8442.550|    2004|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        8036.479|    2003|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        7967.163|    2002|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        8636.545|    2001|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        8997.660|    2000|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        9207.792|    1999|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        9438.883|    1998|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        9089.123|    1997|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        8432.621|    1996|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        8044.642|    1995|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        8221.949|    1994|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        7720.467|    1993|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        7576.146|    1992|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        7070.506|    1991|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6877.287|    1990|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6903.525|    1989|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6872.389|    1988|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6814.581|    1987|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6349.604|    1986|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5872.571|    1985|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5824.946|    1984|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5930.284|    1983|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6652.268|    1982|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        7419.914|    1981|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        7354.228|    1980|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6995.612|    1979|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6633.200|    1978|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6336.468|    1977|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6280.022|    1976|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        6066.265|    1975|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5730.020|    1974|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5572.708|    1973|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5558.678|    1972|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5639.344|    1971|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5670.611|    1970|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5570.576|    1969|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5300.418|    1968|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5248.841|    1967|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5502.523|    1966|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5395.151|    1965|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5397.710|    1964|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5329.625|    1963|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5384.393|    1962|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5539.019|    1961|
| Uruguay       | Americas  |    2007|     64.65874| lifeExp |  76.384|        5474.622|    1960|

Activity \#2: Create cheatsheet patterned.
------------------------------------------
