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
library(plyr)
```

1. Character data
-----------------

We wil; start from the loading the libraries for this excercise.

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

-   Use str\_length() and str\_sub() to extract the middle character from a string.

``` r
string <- "This is defiNitely string"
#string <- "12345" #for testing purposes
ln <- str_length(string)
str_sub(string, start=ln/2+1, end=ln/2+1)
```

    ## [1] "N"

-   What will you do if the string has an even number of characters?

In that case we can extract the middle-1 or middle+1 character instead, or output "your character has even number of caracters" forcing the user to adjust the input string, and/or output an error.

-   What does str\_wrap() do? When might you want to use it?

``` r
thanks_path <- file.path(R.home("doc"), "THANKS")
thanks <- str_c(readLines(thanks_path), collapse = "\n")
thanks <- word(thanks, 1, 3, fixed("\n\n"))
cat(str_wrap(thanks), "\n")
```

    ## R would not be what it is today without the invaluable help of these people
    ## outside of the R core team, who contributed by donating code, bug fixes and
    ## documentation: Valerio Aimale, Thomas Baier, Henrik Bengtsson, Roger Bivand,
    ## Ben Bolker, David Brahm, G"oran Brostr"om, Patrick Burns, Vince Carey, Saikat
    ## DebRoy, Matt Dowle, Brian D'Urso, Lyndon Drake, Dirk Eddelbuettel, Claus
    ## Ekstrom, Sebastian Fischmeister, John Fox, Paul Gilbert, Yu Gong, Gabor
    ## Grothendieck, Frank E Harrell Jr, Torsten Hothorn, Robert King, Kjetil Kjernsmo,
    ## Roger Koenker, Philippe Lambert, Jan de Leeuw, Jim Lindsey, Patrick Lindsey,
    ## Catherine Loader, Gordon Maclean, John Maindonald, David Meyer, Ei-ji Nakama,
    ## Jens Oehlschaegel, Steve Oncley, Richard O'Keefe, Hubert Palme, Roger D. Peng,
    ## Jose' C. Pinheiro, Tony Plate, Anthony Rossini, Jonathan Rougier, Petr Savicky,
    ## Guenther Sawitzki, Marc Schwartz, Arun Srinivasan, Detlef Steuer, Bill Simpson,
    ## Gordon Smyth, Adrian Trapletti, Terry Therneau, Rolf Turner, Bill Venables,
    ## Gregory R. Warnes, Andreas Weingessel, Morten Welinder, James Wettenhall, Simon
    ## Wood, and Achim Zeileis. Others have written code that has been adopted by R and
    ## is acknowledged in the code files, including

This is a wrapper around stri\_wrap which implements the Knuth-Plass paragraph wrapping algorithm, where the function breaks text paragraphs into lines, of total width. We might wanna use it in the case when the lines' width is important, fixed screen sizes for example.

-   What does str\_trim() do? What’s the opposite of str\_trim()?

``` r
string <- "   This is definitely string   "
string
```

    ## [1] "   This is definitely string   "

``` r
str_trim(string)
```

    ## [1] "This is definitely string"

str\_trim() - trims all the leading and trailing whitespaces from the string. The opposite to str\_trim() function is str\_pad().

-   Write a function that turns (e.g.) a vector c("a", "b", "c") into the string a, b, and c. Think carefully about what it should do if given a vector of length 0, 1, or 2.

``` r
x = c("a", "b", "c")
y = c("")

func <- function(input) {
  output = ""
  if (length(input) == 1)
  {
    output <- str_c(input)
    writeLines("Your output is of the size 0") #zero length case
  }
  else if (length(input) == 2)
  {
    output <- str_c(output, input[1], " and ", input[2])
  }
  else
  {
    for (i in 1:(length(input)-2))
    {
      output <- str_c(output, input[i], ", ")
    }
    output <- str_c(output, input[length(input)-1], " and ", input[length(input)])
  }
  writeLines(output)
}

func(y)
```

    ## Your output is of the size 0

``` r
func(x)
```

    ## a, b and c

2. Writing functions
--------------------

-   If you plan to complete the homework where we build an R package, write a couple of experimental functions exploring some functionality that is useful to you in real life and that might form the basis of your personal package. We are going to use the data from the real wind turbine in form of csv. First function wil read this file and clean it up.

``` r
read_wind_data <- function(input, save_flag){
  #Reads teh wind turbine data CSV, cleans and prints it out.
  gtm.rawData <- read.csv(input, header = TRUE)
  gtm.dat <- within(gtm.rawData, rm("X.GV.SD_04","X.GV.SD_05","X.GV.SD_38", "X.GV.HRR_GeneratorWindingTemp.1"))
  c_names <- colnames(gtm.dat, do.NULL = TRUE, prefix = "col")
  raw_data <- str_replace(c_names, "X.GV.", "")
  names(gtm.dat) <- raw_data

  return(gtm.dat)
}
```

Functoin creates dir in main folder

``` r
gtm.dat <- read_wind_data("10.0.103.10.csv", FALSE)
```

``` r
mkdirs <- function(fp) {
    if(!file.exists(fp)) {
        mkdirs(dirname(source_local(), fp))
        dir.create(fp)
    }
} 
```

Function plots var1 against var2 from data-frame df and saves if save\_flag == TRUE:

``` r
plot_and_save <- function(df, var1, var2, save_flag){
    my_plot <- ggplot(df, aes(df[[var1]], df[[var2]])) +
      geom_point() +
      geom_smooth(se=FALSE)
  
    if(save_flag == TRUE){
    #mkdirs(media)
      ggsave("media/my_plot.png", plot = my_plot)
    }
}
```

``` r
plot_and_save(gtm.dat, "HRR_WTCorrectedWindSpeed", "HRR_kW", TRUE)
```

    ## Saving 7 x 5 in image

    ## `geom_smooth()` using method = 'gam'

PCA plus Linear regression

``` r
end = ncol(gtm.dat)
gtm.gentemp <- gtm.dat[,end]
gtm.vars <- gtm.dat[,3:end-1]

le_lin_fit <- function(vars, gentemp) {
  PCA <- prcomp(vars, center = TRUE, scale. = TRUE) 
  print(PCA$rotation)
  plot(PCA, type = "l")
  summary(PCA)
  #the_fit <- lm(gentemp ~ gtm.dat)
  #the_fit <- lm(gentemp ~ PCA$rotation[,1], PCA$rotation[,2])
  the_fit <- lm(gtm.gentemp ~ gtm.vars$HRR_kVAR + gtm.vars$HRR_WTCorrectedWindSpeed)
  coef(the_fit)
  }
le_lin_fit(gtm.vars, gtm.gentemp)
```

    ##                                               PC1         PC2         PC3
    ## HRR_kWLastMinAve                        0.2694277 -0.02322375 -0.03184289
    ## HRR_kVAR                               -0.2639943  0.10864757 -0.14978710
    ## HRR_kW                                  0.2755433 -0.07586693  0.04008918
    ## primaryLovatoReadings.EqvPowerFactor    0.1543677  0.07390814 -0.95044475
    ## primaryLovatoReadings.EqvActivePower    0.2758620 -0.07504541  0.05568773
    ## primaryLovatoReadings.EqvReactivePower -0.2653991  0.11019958 -0.15274527
    ## primaryLovatoReadings.L1PhaseVoltage    0.2672072 -0.10046280 -0.04269043
    ## primaryLovatoReadings.L2PhaseVoltage    0.2608719 -0.10616909 -0.06449137
    ## primaryLovatoReadings.L3PhaseVoltage    0.2507694 -0.09073555 -0.06138340
    ## HRR_WTCorrectedWindSpeed                0.2691140 -0.02878778  0.02487058
    ## primaryLovatoReadings.L1Current         0.2753698 -0.07947220  0.07167282
    ## primaryLovatoReadings.L2Current         0.2749689 -0.08304476  0.08104972
    ## primaryLovatoReadings.L3Current         0.2737410 -0.08319053  0.08210071
    ## HRR_GeneratorWindingTemp                0.2576492  0.21187422 -0.01571583
    ## HRR_NacelleAirTemp                      0.1306331  0.68498134  0.10589402
    ## HRR_OutsideAirTemp                      0.1638464  0.62770457  0.06992898
    ##                                                PC4         PC5         PC6
    ## HRR_kWLastMinAve                        0.05553563  0.51543996  0.30325915
    ## HRR_kVAR                               -0.24180561  0.40793458 -0.33436958
    ## HRR_kW                                  0.16447810  0.01570958  0.01881254
    ## primaryLovatoReadings.EqvPowerFactor    0.20757214 -0.12932588 -0.02948340
    ## primaryLovatoReadings.EqvActivePower    0.18688915 -0.06335173  0.13740080
    ## primaryLovatoReadings.EqvReactivePower -0.23967144  0.39865323 -0.25827865
    ## primaryLovatoReadings.L1PhaseVoltage   -0.38113091 -0.05772633 -0.07271088
    ## primaryLovatoReadings.L2PhaseVoltage   -0.47473960 -0.10837129 -0.01113263
    ## primaryLovatoReadings.L3PhaseVoltage   -0.58638016 -0.19095623  0.05592986
    ## HRR_WTCorrectedWindSpeed                0.11151021  0.02498727 -0.10798173
    ## primaryLovatoReadings.L1Current         0.11664510  0.11726840 -0.40013941
    ## primaryLovatoReadings.L2Current         0.12124726  0.11751135 -0.39227630
    ## primaryLovatoReadings.L3Current         0.11028835  0.13879935 -0.39819511
    ## HRR_GeneratorWindingTemp               -0.07449039  0.50061994  0.44462706
    ## HRR_NacelleAirTemp                     -0.05351327 -0.16396341 -0.04484117
    ## HRR_OutsideAirTemp                      0.01178893 -0.10726383 -0.13025473
    ##                                                 PC7          PC8
    ## HRR_kWLastMinAve                        0.078473874  0.616030862
    ## HRR_kVAR                               -0.069592143 -0.002250357
    ## HRR_kW                                  0.136689966  0.062102216
    ## primaryLovatoReadings.EqvPowerFactor    0.037744583 -0.042772363
    ## primaryLovatoReadings.EqvActivePower    0.086025263  0.022243109
    ## primaryLovatoReadings.EqvReactivePower -0.047146155  0.073150604
    ## primaryLovatoReadings.L1PhaseVoltage    0.036030289  0.011960083
    ## primaryLovatoReadings.L2PhaseVoltage    0.034262280  0.029009246
    ## primaryLovatoReadings.L3PhaseVoltage   -0.015747924  0.049831424
    ## HRR_WTCorrectedWindSpeed               -0.947637626  0.035861085
    ## primaryLovatoReadings.L1Current         0.138557699 -0.129093596
    ## primaryLovatoReadings.L2Current         0.126097545 -0.148795360
    ## primaryLovatoReadings.L3Current         0.142585694 -0.050923607
    ## HRR_GeneratorWindingTemp               -0.003850837 -0.575722838
    ## HRR_NacelleAirTemp                      0.010312378 -0.216817354
    ## HRR_OutsideAirTemp                      0.054580630  0.429360265
    ##                                                PC9         PC10
    ## HRR_kWLastMinAve                       -0.21134537  0.031827638
    ## HRR_kVAR                                0.48393425 -0.032038808
    ## HRR_kW                                  0.70491249 -0.073718391
    ## primaryLovatoReadings.EqvPowerFactor   -0.04948559 -0.003036451
    ## primaryLovatoReadings.EqvActivePower    0.39191655  0.081516559
    ## primaryLovatoReadings.EqvReactivePower -0.01691257  0.076841441
    ## primaryLovatoReadings.L1PhaseVoltage   -0.02282035 -0.523466154
    ## primaryLovatoReadings.L2PhaseVoltage    0.01787685  0.097480857
    ## primaryLovatoReadings.L3PhaseVoltage    0.01922059  0.295788570
    ## HRR_WTCorrectedWindSpeed                0.02210821 -0.005883316
    ## primaryLovatoReadings.L1Current        -0.12534126  0.363609360
    ## primaryLovatoReadings.L2Current        -0.11382470  0.367597515
    ## primaryLovatoReadings.L3Current        -0.18859781 -0.578435043
    ## HRR_GeneratorWindingTemp               -0.03265403 -0.001592876
    ## HRR_NacelleAirTemp                     -0.01628376 -0.062133549
    ## HRR_OutsideAirTemp                      0.02529997  0.055969646
    ##                                                PC11        PC12
    ## HRR_kWLastMinAve                       -0.172605848  0.26967243
    ## HRR_kVAR                               -0.551721334 -0.08640976
    ## HRR_kW                                  0.258280789  0.36365471
    ## primaryLovatoReadings.EqvPowerFactor   -0.021094905  0.01799963
    ## primaryLovatoReadings.EqvActivePower    0.119623679 -0.35981059
    ## primaryLovatoReadings.EqvReactivePower  0.747039133  0.07060450
    ## primaryLovatoReadings.L1PhaseVoltage    0.041397038 -0.11183953
    ## primaryLovatoReadings.L2PhaseVoltage    0.064210083 -0.19101186
    ## primaryLovatoReadings.L3PhaseVoltage   -0.081815967  0.23308692
    ## HRR_WTCorrectedWindSpeed                0.030111476  0.01369662
    ## primaryLovatoReadings.L1Current        -0.041876971  0.03171767
    ## primaryLovatoReadings.L2Current        -0.048507628 -0.02629238
    ## primaryLovatoReadings.L3Current        -0.009234097  0.02194536
    ## HRR_GeneratorWindingTemp                0.035199484 -0.22509115
    ## HRR_NacelleAirTemp                     -0.063800606  0.51209795
    ## HRR_OutsideAirTemp                      0.057800314 -0.48393469
    ##                                                PC13          PC14
    ## HRR_kWLastMinAve                       -0.154835293  0.0850483180
    ## HRR_kVAR                               -0.034456528  0.0761552314
    ## HRR_kW                                  0.098077343 -0.3943473684
    ## primaryLovatoReadings.EqvPowerFactor    0.010508201  0.0007486192
    ## primaryLovatoReadings.EqvActivePower   -0.142769881  0.7240880858
    ## primaryLovatoReadings.EqvReactivePower -0.013837307  0.1822414144
    ## primaryLovatoReadings.L1PhaseVoltage   -0.228478117 -0.0307410288
    ## primaryLovatoReadings.L2PhaseVoltage   -0.493837640 -0.2251473865
    ## primaryLovatoReadings.L3PhaseVoltage    0.574164510  0.2198113731
    ## HRR_WTCorrectedWindSpeed               -0.007489965 -0.0128960152
    ## primaryLovatoReadings.L1Current         0.008488319  0.0032476739
    ## primaryLovatoReadings.L2Current        -0.178635889 -0.1169014624
    ## primaryLovatoReadings.L3Current         0.323851706  0.1586688322
    ## HRR_GeneratorWindingTemp                0.171342051 -0.1440012171
    ## HRR_NacelleAirTemp                     -0.300591539  0.2473304354
    ## HRR_OutsideAirTemp                      0.249318074 -0.2303488050
    ##                                                PC15         PC16
    ## HRR_kWLastMinAve                       -0.006652025  0.005222930
    ## HRR_kVAR                                0.021537685 -0.001463822
    ## HRR_kW                                  0.005739461 -0.008166088
    ## primaryLovatoReadings.EqvPowerFactor    0.002980929  0.009017333
    ## primaryLovatoReadings.EqvActivePower    0.007798602  0.026220834
    ## primaryLovatoReadings.EqvReactivePower -0.018123255  0.021560614
    ## primaryLovatoReadings.L1PhaseVoltage   -0.632218989 -0.140557306
    ## primaryLovatoReadings.L2PhaseVoltage    0.576398587  0.004538336
    ## primaryLovatoReadings.L3PhaseVoltage   -0.043704827  0.100860531
    ## HRR_WTCorrectedWindSpeed                0.014757610 -0.007104292
    ## primaryLovatoReadings.L1Current        -0.050719967 -0.732153513
    ## primaryLovatoReadings.L2Current        -0.282029219  0.643622540
    ## primaryLovatoReadings.L3Current         0.423655096  0.135019268
    ## HRR_GeneratorWindingTemp                0.004599669 -0.007468716
    ## HRR_NacelleAirTemp                      0.040262223  0.007634083
    ## HRR_OutsideAirTemp                     -0.041926865 -0.005187987

![](HW6_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-15-1.png)

    ##                       (Intercept)                 gtm.vars$HRR_kVAR 
    ##                      508.26118071                       -0.01306712 
    ## gtm.vars$HRR_WTCorrectedWindSpeed 
    ##                        1.35151825

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
