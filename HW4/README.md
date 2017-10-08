# STAT545-hw04-ganelin-ilya

tidyr In a Nutshell
===

This is a minimal guide, mostly for myself, to remind me of the most import tidyr functions **gather** and **spread** functions that I'm familiar with. Also checkout [dplyr In a Nutshell](https://github.com/trinker/dplyr_in_a_nutshell) and [A tidyr Tutorial](http://data.library.virginia.edu/a-tidyr-tutorial/)


```{r}
library(knitr)
library(gapminder)
library(tidyr)
```




# 2  Main Functions

List of **tidyr** functions and the **reshape2** functions they're related to:

reshape2 Function    | tidyr Function | Special Powers
---------------------|-------------------|----------------------------
`melt`               |  `gather`         | long format\*
`dcast`              |  `spread`         | wide format\*


\*[Hadley notes](http://vita.had.co.nz/papers/tidy-data.pdf) these terms are imprecise but good enough for my little noodle

## Arguments (when chaining)

![](tidyr.png)


# Demos
### Some Data
```{r}
library(tidyr); library(dplyr)

dat <- data.frame(
   id = LETTERS[1:5],
   x = sample(0:1, 5, TRUE),
   y = sample(0:1, 5, TRUE),
   z = sample(0:1, 5, TRUE)
)

dat
```

### gather in Action

```{r}
dat %>% gather(item, scores, -c(id))
```

### spread it Back Out

```{r}
dat %>% gather(item, scores, -c(id)) %>%
    spread(item, scores)
```

---

# Additional Demos

### gather

```{r}
dat %>% gather(item, scores, x:z) 
dat %>% gather(item, scores, x, y, z) 
```

### spread

```{r}
dat %>% gather(item, scores, -c(id)) %>%
    spread(id, scores)
```


```{r, echo=FALSE, eval=FALSE}
## knitr::knit2html("README.Rmd")
```
