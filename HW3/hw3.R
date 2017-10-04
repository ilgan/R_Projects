---
  title: "hw03_dplyr-and-more-ggplot2s"
date: "September 26, 2017"
output: 
  html_document:
  toc: true
---
  
library(tidyverse)
library(gapminder)
library(dplyr)
library(ggplot2)
library(knitr)
library(dplyr)

gapminder %>% 
  filter(country %in% c("Rwanda", "Afghanistan")) %>% 
  kable(., format = "markdown", caption = "Kable Rmd Good Looking Table")

p <- ggplot(gapminder, aes(year, lifeExp)) + geom_point() 
p + geom_smooth(se=FALSE) + aes(colour=continent)
p + geom_smooth(method="lm")


# Just for a practice...
## 1
```{r, fig.width=8}
vc1 <- gapminder %>% 
  mutate(size=c("Small", "Large")[(pop>5000000) + 1]) %>% 
  ggplot(aes(gdpPercap, lifeExp)) +
  facet_grid(size ~ continent) 
vc1 + geom_point()

gapminder %>% 
  mutate(size=c("Small", "Large")[(pop>5000000) + 1]) %>% 
  kable(., format = "markdown", caption = "Kable Rmd Good Looking Table")
```
## 2
```{r}
gapminder %>% 
  filter(country %in% c("Rwanda", "Afghanistan")) %>% 
  kable(., format = "markdown", caption = "Kable Rmd Good Looking Table")

vc2 <- ggplot(gapminder, aes(year, lifeExp)) + geom_point() 
vc2 + geom_smooth(se=FALSE) + aes(colour=continent)
vc2 + geom_smooth(method="lm")
```
## 3: Life expectancy in Canada
```{r}
gapminder %>% 
  filter(country %in% c("Canada")) %>% 
  ggplot(aes(year, lifeExp)) + geom_point() +
  geom_smooth(method="lm")

gapminder %>% 
  filter(country %in% c("Canada")) %>% 
  arrange(year) %>% 
  kable(., format = "markdown", caption = "Life expectancy in Canada")

```
## 4: Populatoin growth in Canada 
```{r}
gapminder %>% 
  filter(country %in% c("Canada")) %>% 
  ggplot(aes(year, pop)) + geom_point() +
  geom_smooth() +
  geom_line(alpha=0.2)

gapminder %>% 
  filter(country %in% c("Canada")) %>% 
  arrange(year) %>% 
  kable(., format = "markdown", caption = "Life expectancy in Canada")

```