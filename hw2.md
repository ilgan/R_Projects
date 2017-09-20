hw2
================
iganelin
September 20, 2017

Homework 2
==========

Loading libraries

``` r
library(gapminder)
library(tidyverse)
```

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

``` r
library(knitr)
library(dplyr)
```

Smell test the data
-------------------

-   Is it a data.frame, a matrix, a vector, a list?

``` r
typeof(gapminder) #list
```

    ## [1] "list"

``` r
head(gapminder) 
```

    ## # A tibble: 6 x 6
    ##       country continent  year lifeExp      pop gdpPercap
    ##        <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
    ## 1 Afghanistan      Asia  1952  28.801  8425333  779.4453
    ## 2 Afghanistan      Asia  1957  30.332  9240934  820.8530
    ## 3 Afghanistan      Asia  1962  31.997 10267083  853.1007
    ## 4 Afghanistan      Asia  1967  34.020 11537966  836.1971
    ## 5 Afghanistan      Asia  1972  36.088 13079460  739.9811
    ## 6 Afghanistan      Asia  1977  38.438 14880372  786.1134

-   How many variables/columns?
-   How many rows/observations?
-   Can you get these facts about “extent” or “size” in more than one way?

``` r
dim(gapminder)  # rows x cols: 1704x6
```

    ## [1] 1704    6

``` r
ncol(gapminder) # 6
```

    ## [1] 6

``` r
nrow(gapminder) # 1704
```

    ## [1] 1704

-   What data type is each variable?

``` r
typeof(gapminder$country)   # integer
```

    ## [1] "integer"

``` r
typeof(gapminder$continent) # integer
```

    ## [1] "integer"

``` r
typeof(gapminder$year)      # integer
```

    ## [1] "integer"

``` r
typeof(gapminder$lifeExp)   # double
```

    ## [1] "double"

``` r
typeof(gapminder$pop)       # integer
```

    ## [1] "integer"

``` r
typeof(gapminder$gdpPercap) # double
```

    ## [1] "double"

Explore individual variables
============================

-   What are possible values (or range, whichever is appropriate) of each variable?

``` r
summary(gapminder$year)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1952    1966    1980    1980    1993    2007

-   What values are typical? What’s the spread? What’s the distribution? Etc., tailored to the variable at hand.

*Mean: 1980, spread: from 1952 till 2007* - Distribution:

``` r
hist(gapminder$year)
```

![](hw2_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-6-1.png)

Explore various plot types
==========================

-   A scatterplot of two quantitative variables.

``` r
ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_point()
```

![](hw2_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-1.png)

``` r
ggplot(gapminder, aes(x = year, y = gdpPercap)) + geom_point()
```

![](hw2_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-2.png)

-   A plot of one quantitative variable. Maybe a histogram or densityplot or frequency polygon.

``` r
hist(gapminder$lifeExp)
```

![](hw2_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-1.png)

-   A plot of one quantitative variable and one categorical. Maybe boxplots for several continents or countries.

``` r
ggplot(gapminder, aes(x = continent, y = lifeExp)) + geom_boxplot()
```

![](hw2_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-9-1.png)

Use filter(), select() and %&gt;%
=================================

-   Use filter() to create data subsets that you want to plot.

``` r
filter(gapminder, continent=="Asia" & pop>=2.960e+07)
```

    ## # A tibble: 126 x 6
    ##        country continent  year lifeExp       pop gdpPercap
    ##         <fctr>    <fctr> <int>   <dbl>     <int>     <dbl>
    ##  1 Afghanistan      Asia  2007  43.828  31889923  974.5803
    ##  2  Bangladesh      Asia  1952  37.484  46886859  684.2442
    ##  3  Bangladesh      Asia  1957  39.348  51365468  661.6375
    ##  4  Bangladesh      Asia  1962  41.216  56839289  686.3416
    ##  5  Bangladesh      Asia  1967  43.453  62821884  721.1861
    ##  6  Bangladesh      Asia  1972  45.252  70759295  630.2336
    ##  7  Bangladesh      Asia  1977  46.923  80428306  659.8772
    ##  8  Bangladesh      Asia  1982  50.009  93074406  676.9819
    ##  9  Bangladesh      Asia  1987  52.819 103764241  751.9794
    ## 10  Bangladesh      Asia  1992  56.018 113704579  837.8102
    ## # ... with 116 more rows

``` r
filter(gapminder, continent=="Asia")
```

    ## # A tibble: 396 x 6
    ##        country continent  year lifeExp      pop gdpPercap
    ##         <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
    ##  1 Afghanistan      Asia  1952  28.801  8425333  779.4453
    ##  2 Afghanistan      Asia  1957  30.332  9240934  820.8530
    ##  3 Afghanistan      Asia  1962  31.997 10267083  853.1007
    ##  4 Afghanistan      Asia  1967  34.020 11537966  836.1971
    ##  5 Afghanistan      Asia  1972  36.088 13079460  739.9811
    ##  6 Afghanistan      Asia  1977  38.438 14880372  786.1134
    ##  7 Afghanistan      Asia  1982  39.854 12881816  978.0114
    ##  8 Afghanistan      Asia  1987  40.822 13867957  852.3959
    ##  9 Afghanistan      Asia  1992  41.674 16317921  649.3414
    ## 10 Afghanistan      Asia  1997  41.763 22227415  635.3414
    ## # ... with 386 more rows

-   Practice piping together filter() and select(). Possibly even piping into ggplot().

``` r
gapminder %>% 
  filter(continent=="Asia" & pop>=2.960e+07) %>% 
  select(-gdpPercap)
```

    ## # A tibble: 126 x 5
    ##        country continent  year lifeExp       pop
    ##         <fctr>    <fctr> <int>   <dbl>     <int>
    ##  1 Afghanistan      Asia  2007  43.828  31889923
    ##  2  Bangladesh      Asia  1952  37.484  46886859
    ##  3  Bangladesh      Asia  1957  39.348  51365468
    ##  4  Bangladesh      Asia  1962  41.216  56839289
    ##  5  Bangladesh      Asia  1967  43.453  62821884
    ##  6  Bangladesh      Asia  1972  45.252  70759295
    ##  7  Bangladesh      Asia  1977  46.923  80428306
    ##  8  Bangladesh      Asia  1982  50.009  93074406
    ##  9  Bangladesh      Asia  1987  52.819 103764241
    ## 10  Bangladesh      Asia  1992  56.018 113704579
    ## # ... with 116 more rows

But I want to do more!
======================

Evaluate this code and describe the result. Presumably the analyst’s intent was to get the data for Rwanda and Afghanistan. Did they succeed? Why or why not? If not, what is the correct way to do this?

``` r
filter(gapminder, country == c("Rwanda", "Afghanistan"))
```

    ## # A tibble: 12 x 6
    ##        country continent  year lifeExp      pop gdpPercap
    ##         <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
    ##  1 Afghanistan      Asia  1957  30.332  9240934  820.8530
    ##  2 Afghanistan      Asia  1967  34.020 11537966  836.1971
    ##  3 Afghanistan      Asia  1977  38.438 14880372  786.1134
    ##  4 Afghanistan      Asia  1987  40.822 13867957  852.3959
    ##  5 Afghanistan      Asia  1997  41.763 22227415  635.3414
    ##  6 Afghanistan      Asia  2007  43.828 31889923  974.5803
    ##  7      Rwanda    Africa  1952  40.000  2534927  493.3239
    ##  8      Rwanda    Africa  1962  43.000  3051242  597.4731
    ##  9      Rwanda    Africa  1972  44.600  3992121  590.5807
    ## 10      Rwanda    Africa  1982  46.218  5507565  881.5706
    ## 11      Rwanda    Africa  1992  23.599  7290203  737.0686
    ## 12      Rwanda    Africa  2002  43.413  7852401  785.6538

Answer: No.

The right way would be:

``` r
filter(gapminder, country %in% c("Rwanda", "Afghanistan"))
```

    ## # A tibble: 24 x 6
    ##        country continent  year lifeExp      pop gdpPercap
    ##         <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
    ##  1 Afghanistan      Asia  1952  28.801  8425333  779.4453
    ##  2 Afghanistan      Asia  1957  30.332  9240934  820.8530
    ##  3 Afghanistan      Asia  1962  31.997 10267083  853.1007
    ##  4 Afghanistan      Asia  1967  34.020 11537966  836.1971
    ##  5 Afghanistan      Asia  1972  36.088 13079460  739.9811
    ##  6 Afghanistan      Asia  1977  38.438 14880372  786.1134
    ##  7 Afghanistan      Asia  1982  39.854 12881816  978.0114
    ##  8 Afghanistan      Asia  1987  40.822 13867957  852.3959
    ##  9 Afghanistan      Asia  1992  41.674 16317921  649.3414
    ## 10 Afghanistan      Asia  1997  41.763 22227415  635.3414
    ## # ... with 14 more rows

-   Present numerical tables in a more attractive form, such as using knitr::kable().

``` r
gapminder %>% 
  filter(country %in% c("Rwanda", "Afghanistan")) %>% 
  kable(., format = "markdown", caption = "Kable Rmd Good Looking Table")
```

| country     | continent |  year|  lifeExp|       pop|  gdpPercap|
|:------------|:----------|-----:|--------:|---------:|----------:|
| Afghanistan | Asia      |  1952|   28.801|   8425333|   779.4453|
| Afghanistan | Asia      |  1957|   30.332|   9240934|   820.8530|
| Afghanistan | Asia      |  1962|   31.997|  10267083|   853.1007|
| Afghanistan | Asia      |  1967|   34.020|  11537966|   836.1971|
| Afghanistan | Asia      |  1972|   36.088|  13079460|   739.9811|
| Afghanistan | Asia      |  1977|   38.438|  14880372|   786.1134|
| Afghanistan | Asia      |  1982|   39.854|  12881816|   978.0114|
| Afghanistan | Asia      |  1987|   40.822|  13867957|   852.3959|
| Afghanistan | Asia      |  1992|   41.674|  16317921|   649.3414|
| Afghanistan | Asia      |  1997|   41.763|  22227415|   635.3414|
| Afghanistan | Asia      |  2002|   42.129|  25268405|   726.7341|
| Afghanistan | Asia      |  2007|   43.828|  31889923|   974.5803|
| Rwanda      | Africa    |  1952|   40.000|   2534927|   493.3239|
| Rwanda      | Africa    |  1957|   41.500|   2822082|   540.2894|
| Rwanda      | Africa    |  1962|   43.000|   3051242|   597.4731|
| Rwanda      | Africa    |  1967|   44.100|   3451079|   510.9637|
| Rwanda      | Africa    |  1972|   44.600|   3992121|   590.5807|
| Rwanda      | Africa    |  1977|   45.000|   4657072|   670.0806|
| Rwanda      | Africa    |  1982|   46.218|   5507565|   881.5706|
| Rwanda      | Africa    |  1987|   44.020|   6349365|   847.9912|
| Rwanda      | Africa    |  1992|   23.599|   7290203|   737.0686|
| Rwanda      | Africa    |  1997|   36.087|   7212583|   589.9445|
| Rwanda      | Africa    |  2002|   43.413|   7852401|   785.6538|
| Rwanda      | Africa    |  2007|   46.242|   8860588|   863.0885|

-   Use more of the dplyr functions for operating on a single table.

``` r
gapminder %>% 
  filter(continent=="Asia" & pop>=2.960e+07) %>% 
  select(-pop) %>% 
  mutate(developpedCountries = gdpPercap>20000) %>% 
  kable(., format = "markdown", caption = "Kable Rmd Good Looking Table")
```

| country     | continent |  year|   lifeExp|   gdpPercap| developpedCountries |
|:------------|:----------|-----:|---------:|-----------:|:--------------------|
| Afghanistan | Asia      |  2007|  43.82800|    974.5803| FALSE               |
| Bangladesh  | Asia      |  1952|  37.48400|    684.2442| FALSE               |
| Bangladesh  | Asia      |  1957|  39.34800|    661.6375| FALSE               |
| Bangladesh  | Asia      |  1962|  41.21600|    686.3416| FALSE               |
| Bangladesh  | Asia      |  1967|  43.45300|    721.1861| FALSE               |
| Bangladesh  | Asia      |  1972|  45.25200|    630.2336| FALSE               |
| Bangladesh  | Asia      |  1977|  46.92300|    659.8772| FALSE               |
| Bangladesh  | Asia      |  1982|  50.00900|    676.9819| FALSE               |
| Bangladesh  | Asia      |  1987|  52.81900|    751.9794| FALSE               |
| Bangladesh  | Asia      |  1992|  56.01800|    837.8102| FALSE               |
| Bangladesh  | Asia      |  1997|  59.41200|    972.7700| FALSE               |
| Bangladesh  | Asia      |  2002|  62.01300|   1136.3904| FALSE               |
| Bangladesh  | Asia      |  2007|  64.06200|   1391.2538| FALSE               |
| China       | Asia      |  1952|  44.00000|    400.4486| FALSE               |
| China       | Asia      |  1957|  50.54896|    575.9870| FALSE               |
| China       | Asia      |  1962|  44.50136|    487.6740| FALSE               |
| China       | Asia      |  1967|  58.38112|    612.7057| FALSE               |
| China       | Asia      |  1972|  63.11888|    676.9001| FALSE               |
| China       | Asia      |  1977|  63.96736|    741.2375| FALSE               |
| China       | Asia      |  1982|  65.52500|    962.4214| FALSE               |
| China       | Asia      |  1987|  67.27400|   1378.9040| FALSE               |
| China       | Asia      |  1992|  68.69000|   1655.7842| FALSE               |
| China       | Asia      |  1997|  70.42600|   2289.2341| FALSE               |
| China       | Asia      |  2002|  72.02800|   3119.2809| FALSE               |
| China       | Asia      |  2007|  72.96100|   4959.1149| FALSE               |
| India       | Asia      |  1952|  37.37300|    546.5657| FALSE               |
| India       | Asia      |  1957|  40.24900|    590.0620| FALSE               |
| India       | Asia      |  1962|  43.60500|    658.3472| FALSE               |
| India       | Asia      |  1967|  47.19300|    700.7706| FALSE               |
| India       | Asia      |  1972|  50.65100|    724.0325| FALSE               |
| India       | Asia      |  1977|  54.20800|    813.3373| FALSE               |
| India       | Asia      |  1982|  56.59600|    855.7235| FALSE               |
| India       | Asia      |  1987|  58.55300|    976.5127| FALSE               |
| India       | Asia      |  1992|  60.22300|   1164.4068| FALSE               |
| India       | Asia      |  1997|  61.76500|   1458.8174| FALSE               |
| India       | Asia      |  2002|  62.87900|   1746.7695| FALSE               |
| India       | Asia      |  2007|  64.69800|   2452.2104| FALSE               |
| Indonesia   | Asia      |  1952|  37.46800|    749.6817| FALSE               |
| Indonesia   | Asia      |  1957|  39.91800|    858.9003| FALSE               |
| Indonesia   | Asia      |  1962|  42.51800|    849.2898| FALSE               |
| Indonesia   | Asia      |  1967|  45.96400|    762.4318| FALSE               |
| Indonesia   | Asia      |  1972|  49.20300|   1111.1079| FALSE               |
| Indonesia   | Asia      |  1977|  52.70200|   1382.7021| FALSE               |
| Indonesia   | Asia      |  1982|  56.15900|   1516.8730| FALSE               |
| Indonesia   | Asia      |  1987|  60.13700|   1748.3570| FALSE               |
| Indonesia   | Asia      |  1992|  62.68100|   2383.1409| FALSE               |
| Indonesia   | Asia      |  1997|  66.04100|   3119.3356| FALSE               |
| Indonesia   | Asia      |  2002|  68.58800|   2873.9129| FALSE               |
| Indonesia   | Asia      |  2007|  70.65000|   3540.6516| FALSE               |
| Iran        | Asia      |  1972|  55.23400|   9613.8186| FALSE               |
| Iran        | Asia      |  1977|  57.70200|  11888.5951| FALSE               |
| Iran        | Asia      |  1982|  59.62000|   7608.3346| FALSE               |
| Iran        | Asia      |  1987|  63.04000|   6642.8814| FALSE               |
| Iran        | Asia      |  1992|  65.74200|   7235.6532| FALSE               |
| Iran        | Asia      |  1997|  68.04200|   8263.5903| FALSE               |
| Iran        | Asia      |  2002|  69.45100|   9240.7620| FALSE               |
| Iran        | Asia      |  2007|  70.96400|  11605.7145| FALSE               |
| Japan       | Asia      |  1952|  63.03000|   3216.9563| FALSE               |
| Japan       | Asia      |  1957|  65.50000|   4317.6944| FALSE               |
| Japan       | Asia      |  1962|  68.73000|   6576.6495| FALSE               |
| Japan       | Asia      |  1967|  71.43000|   9847.7886| FALSE               |
| Japan       | Asia      |  1972|  73.42000|  14778.7864| FALSE               |
| Japan       | Asia      |  1977|  75.38000|  16610.3770| FALSE               |
| Japan       | Asia      |  1982|  77.11000|  19384.1057| FALSE               |
| Japan       | Asia      |  1987|  78.67000|  22375.9419| TRUE                |
| Japan       | Asia      |  1992|  79.36000|  26824.8951| TRUE                |
| Japan       | Asia      |  1997|  80.69000|  28816.5850| TRUE                |
| Japan       | Asia      |  2002|  82.00000|  28604.5919| TRUE                |
| Japan       | Asia      |  2007|  82.60300|  31656.0681| TRUE                |
| Korea, Rep. | Asia      |  1967|  57.71600|   2029.2281| FALSE               |
| Korea, Rep. | Asia      |  1972|  62.61200|   3030.8767| FALSE               |
| Korea, Rep. | Asia      |  1977|  64.76600|   4657.2210| FALSE               |
| Korea, Rep. | Asia      |  1982|  67.12300|   5622.9425| FALSE               |
| Korea, Rep. | Asia      |  1987|  69.81000|   8533.0888| FALSE               |
| Korea, Rep. | Asia      |  1992|  72.24400|  12104.2787| FALSE               |
| Korea, Rep. | Asia      |  1997|  74.64700|  15993.5280| FALSE               |
| Korea, Rep. | Asia      |  2002|  77.04500|  19233.9882| FALSE               |
| Korea, Rep. | Asia      |  2007|  78.62300|  23348.1397| TRUE                |
| Myanmar     | Asia      |  1977|  56.05900|    371.0000| FALSE               |
| Myanmar     | Asia      |  1982|  58.05600|    424.0000| FALSE               |
| Myanmar     | Asia      |  1987|  58.33900|    385.0000| FALSE               |
| Myanmar     | Asia      |  1992|  59.32000|    347.0000| FALSE               |
| Myanmar     | Asia      |  1997|  60.32800|    415.0000| FALSE               |
| Myanmar     | Asia      |  2002|  59.90800|    611.0000| FALSE               |
| Myanmar     | Asia      |  2007|  62.06900|    944.0000| FALSE               |
| Pakistan    | Asia      |  1952|  43.43600|    684.5971| FALSE               |
| Pakistan    | Asia      |  1957|  45.55700|    747.0835| FALSE               |
| Pakistan    | Asia      |  1962|  47.67000|    803.3427| FALSE               |
| Pakistan    | Asia      |  1967|  49.80000|    942.4083| FALSE               |
| Pakistan    | Asia      |  1972|  51.92900|   1049.9390| FALSE               |
| Pakistan    | Asia      |  1977|  54.04300|   1175.9212| FALSE               |
| Pakistan    | Asia      |  1982|  56.15800|   1443.4298| FALSE               |
| Pakistan    | Asia      |  1987|  58.24500|   1704.6866| FALSE               |
| Pakistan    | Asia      |  1992|  60.83800|   1971.8295| FALSE               |
| Pakistan    | Asia      |  1997|  61.81800|   2049.3505| FALSE               |
| Pakistan    | Asia      |  2002|  63.61000|   2092.7124| FALSE               |
| Pakistan    | Asia      |  2007|  65.48300|   2605.9476| FALSE               |
| Philippines | Asia      |  1962|  54.75700|   1649.5522| FALSE               |
| Philippines | Asia      |  1967|  56.39300|   1814.1274| FALSE               |
| Philippines | Asia      |  1972|  58.06500|   1989.3741| FALSE               |
| Philippines | Asia      |  1977|  60.06000|   2373.2043| FALSE               |
| Philippines | Asia      |  1982|  62.08200|   2603.2738| FALSE               |
| Philippines | Asia      |  1987|  64.15100|   2189.6350| FALSE               |
| Philippines | Asia      |  1992|  66.45800|   2279.3240| FALSE               |
| Philippines | Asia      |  1997|  68.56400|   2536.5349| FALSE               |
| Philippines | Asia      |  2002|  70.30300|   2650.9211| FALSE               |
| Philippines | Asia      |  2007|  71.68800|   3190.4810| FALSE               |
| Thailand    | Asia      |  1967|  58.28500|   1295.4607| FALSE               |
| Thailand    | Asia      |  1972|  60.40500|   1524.3589| FALSE               |
| Thailand    | Asia      |  1977|  62.49400|   1961.2246| FALSE               |
| Thailand    | Asia      |  1982|  64.59700|   2393.2198| FALSE               |
| Thailand    | Asia      |  1987|  66.08400|   2982.6538| FALSE               |
| Thailand    | Asia      |  1992|  67.29800|   4616.8965| FALSE               |
| Thailand    | Asia      |  1997|  67.52100|   5852.6255| FALSE               |
| Thailand    | Asia      |  2002|  68.56400|   5913.1875| FALSE               |
| Thailand    | Asia      |  2007|  70.61600|   7458.3963| FALSE               |
| Vietnam     | Asia      |  1962|  45.36300|    772.0492| FALSE               |
| Vietnam     | Asia      |  1967|  47.83800|    637.1233| FALSE               |
| Vietnam     | Asia      |  1972|  50.25400|    699.5016| FALSE               |
| Vietnam     | Asia      |  1977|  55.76400|    713.5371| FALSE               |
| Vietnam     | Asia      |  1982|  58.81600|    707.2358| FALSE               |
| Vietnam     | Asia      |  1987|  62.82000|    820.7994| FALSE               |
| Vietnam     | Asia      |  1992|  67.66200|    989.0231| FALSE               |
| Vietnam     | Asia      |  1997|  70.67200|   1385.8968| FALSE               |
| Vietnam     | Asia      |  2002|  73.01700|   1764.4567| FALSE               |
| Vietnam     | Asia      |  2007|  74.24900|   2441.5764| FALSE               |

Report your process
===================

The instructions were easy to follow and with help of the search engine, all the right answers were easily found.

The helpful tutorials:

-   [r-bloggers.com](https://www.r-bloggers.com/data-manipulation-with-dplyr/)

-   [http://t-redactyl.io](http://t-redactyl.io/blog/2016/04/creating-plots-in-r-using-ggplot2-part-10-boxplots.html)
