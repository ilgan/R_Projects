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

This is a minimal guide, mostly for myself, to remind me of the most import tidyr functions **gather** and **spread** functions that I'm familiar with. Also checkout [A tidyr Tutorial](http://data.library.virginia.edu/a-tidyr-tutorial/)

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
