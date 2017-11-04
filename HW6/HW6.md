HW6
================
iganelin
November 4, 2017

Homework 06: Data wrangling wrap up
===================================

### Loading libraries

``` r
library(gapminder)
library(singer)
library(tidyverse)
library(knitr)
library(dplyr)
library(forcats)
```

1. Character data
-----------------

We wil start from the loading the libraries for this excercise.

``` r
library(tidyverse)
library(stringr)
```

Lets write a few strings.

``` r
string1 <- "This is definitely string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
str_c("x", "y", "z")
```

    ## [1] "xyz"

``` r
str_c(string1, ". ", string2)
```

    ## [1] "This is definitely string. If I want to include a \"quote\" inside a string, I use single quotes"

``` r
#or
str_c(string1, string2, sep = ", ")
```

    ## [1] "This is definitely string, If I want to include a \"quote\" inside a string, I use single quotes"

### 14.2.5 Exercises

-   In code that doesn’t use stringr, you’ll often see paste() and paste0(). What’s the difference between the two functions?

The difference between paste() and paste0() is that the argument "sep"" by default is ” ” (paste) and “” (paste0). It can be changed in the fuction itself.

-   What stringr function are they equivalent to?

paste() =&gt; str\_c(..., sep = " ", collapse = NULL) paste0() =&gt; str\_c(..., sep = "", collapse = NULL)

-   How do the functions differ in their handling of NA?

Let's see how they work:

``` r
str_c(c("a", NA, "b"), "-d")
```

    ## [1] "a-d" NA    "b-d"

``` r
paste(c("a", NA, "b"), "-d")
```

    ## [1] "a -d"  "NA -d" "b -d"

``` r
paste0(c("a", NA, "b"), "-d")
```

    ## [1] "a-d"  "NA-d" "b-d"

....so as we can see from the examples above, str\_c does recognize NA, whereas paste() and paste0() both read NA as a string.

-   In your own words, describe the difference between the sep and collapse arguments to str\_c().

Argument "sep" is used when we want to insert a string between the input vectors. Argument "collapse" is used when we want to combine input vectors into one string.

-   Use str\_length() and str\_sub() to extract the middle character from a string. What will you do if the string has an even number of characters?

-   What does str\_wrap() do? When might you want to use it?

-   What does str\_trim() do? What’s the opposite of str\_trim()?

-   Write a function that turns (e.g.) a vector c("a", "b", "c") into the string a, b, and c. Think carefully about what it should do if given a vector of length 0, 1, or 2.

2. Writing functions
--------------------

3. Work with the candy data
---------------------------

4. Work with the singer data
----------------------------

5. Work with a list
-------------------

6. Work with a nested data frame
--------------------------------

Report your process
-------------------
