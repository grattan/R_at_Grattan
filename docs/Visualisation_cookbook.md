# Chart cookbook

This section takes you through a few often-used chart types. 


# Set up



```r
library(tidyverse)
library(grattantheme)
library(ggrepel)
library(absmapsdata)
library(sf)
library(scales)
```

The `sa3_income` dataset will be used for all key examples in this chapter.^[From [ABS Employee income by occupation and sex, 2010-11 to 2015-16](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/6524.0.55.0022011-2016?OpenDocument)] It is a long dataset from the ABS that contains the median income and number of workers by Statistical Area 3, occupation and sex between 2010 and 2015.


```r
sa3_income <- read_csv("data/sa3_income.csv") %>% 
  filter(!is.na(median_income),
         !is.na(average_income))
```

```
## Parsed with column specification:
## cols(
##   sa3 = col_double(),
##   sa3_name = col_character(),
##   sa3_sqkm = col_double(),
##   sa4_name = col_character(),
##   gcc_name = col_character(),
##   occupation = col_character(),
##   sex = col_character(),
##   year = col_double(),
##   median_income = col_double(),
##   average_income = col_double(),
##   workers = col_double()
## )
```

```r
head(sa3_income)
```

```
## # A tibble: 6 x 11
##     sa3 sa3_name sa3_sqkm sa4_name gcc_name occupation sex    year
##   <dbl> <chr>       <dbl> <chr>    <chr>    <chr>      <chr> <dbl>
## 1 10102 Queanbe…    6511. Capital… Rest of… Clerical … Fema…  2010
## 2 10102 Queanbe…    6511. Capital… Rest of… Clerical … Fema…  2011
## 3 10102 Queanbe…    6511. Capital… Rest of… Clerical … Fema…  2012
## 4 10102 Queanbe…    6511. Capital… Rest of… Clerical … Fema…  2013
## 5 10102 Queanbe…    6511. Capital… Rest of… Clerical … Fema…  2014
## 6 10102 Queanbe…    6511. Capital… Rest of… Clerical … Fema…  2015
## # … with 3 more variables: median_income <dbl>, average_income <dbl>,
## #   workers <dbl>
```



## Bar charts

Bar charts are made with `geom_bar` or `geom_col`. Creating a bar chart will look something like this:



```r
ggplot(data = <data>) + 
  geom_bar(aes(x = <xvar>, y = <yvar>),
     stat = <STAT>, 
     position = <POSITION>
  )
```


It has two key arguments: `stat` and `position`. 

First, `stat` defines what kind of _operation_ the function will do on the dataset before plotting. Some options are:

- `"count"`, the **default**: count the number of observations in a particular group, and plot that number. This is useful when you're using microdata. When this is the case, there is no need for a `y` aesthetic.
- `"sum"`: sum the values of the `y` aesthetic.
- `"identity"`: directly report the values of the `y` aesthetic. This is how PowerPoint and Excel charts work.

You can use **`geom_col`** instead, as a shortcut for `geom_bar(stat = "identity)`. 

Second, `position`, dictates how multiple bars occupying the same x-axis position will positioned. The options are:

- `"stack"`, the default: bars in the same group are stacked atop one another.
- `"dodge"`: bars in the same group are positioned next to one another.
- `"fill"`: bars in the same group are stacked and all fill to 100 per cent.

Let's look at a bar chart that shows the proportion of areas where people earn less than $50,000 in each occupation type:


```r
data <- sa3_income %>% 
  filter(!sex == "Persons") %>% 
  mutate(under = average_income < 60e3) %>% 
  group_by(occupation, sex, under) %>% 
  summarise(n = sum(workers)) %>% 
  mutate(pc = n / sum(n)) %>% 
  filter(under == FALSE)
  

data %>% 
  ggplot(aes(x = occupation,
             y = pc * 100,
             fill = sex)) +
  geom_bar(stat = "identity",
           position = "dodge") +
  theme_grattan() +
  grattan_y_continuous(labels = comma) +
  grattan_fill_manual(6) + 
  labs(x = "",
       y = "") +
  coord_flip()
```

![](Visualisation_cookbook_files/figure-epub3/bar2-1.png)<!-- -->


You can also **order** the groups in your chart by a variable. If you want to order states by population, use `reorder` inside `aes`:



To flip the chart -- a useful move when you have long labels -- add `coord_flipped` (ie 'flip coordinates') and tell `theme_grattan` that the plot is flipped using `flipped = TRUE`. 




Our long numeric labels means the chart clips them off a bit at the end. We can deal with this in two ways:

1. Adjust the limits of the axis to accommodate the long labels, meaning we will have to define our own axis-label breaks using the `seq` function^[`seq(x1, x2, y)` will return a vector of numbers between `x1` and `x2`, spaced by `y`. For example: `seq(0, 10, 2)` will produce `0  2  4  6  8  10`]:




2. Add empty space at the top of the chart to accommodate the long labels:



## Line charts

A line chart has one key aesthetic: `group`. This tells `ggplot` how to connect individual lines.



You can also add dots for each year by layering `geom_point` on top of `geom_line`:



If you wanted to show each state individually, you could **facet** your chart so that a separate plot was produced for each state:



To tidy this up, we can: 

  1. shorten the years to be "13", "14", etc instead of "2013", "2014", etc (via the `x` aesthetic)
  1. shorten the y-axis labels to "millions" (via the `y` aesthetic)
  1. add a black horizontal line at the bottom of each facet
  1. give the facets a bit of room by adjusting `panel.spacing`
  1. define our own x-axis label breaks to just show `13`, `15` and `17`







## Scatter plots

Scatter plots require `x` and `y` aesthetics. These can then be coloured and faceted.

First, create a dataset that we'll use for scatter plots. Take the `population_table` dataset and transform it to have one variable for population in 2013, and another for population in 2018:



 
Then plot it  
 






It looks like the areas with the largest population grew the most between 2013 and 2018. To explore the relationship further, you can add a line-of-best-fit with `geom_smooth`:




You could colour-code positive and negative changes from within the `geom_point` aesthetic. Making a change there won't pass through to the `geom_smooth` aesthetic, so your line-of-best-fit will apply to all data points.




Like the charts above, you could facet this by state to see if there were any interesting patterns. We'll filter out ACT and NT because they only have one and two data points (SA4s) in them, respectively.




## Distributions

`geom_histogram`
`geom_density`

`ggridges::`


## Maps

### `sf` objects
[what is]

### Using `absmapsdata`

The `absmapsdata` contains compressed, and tidied `sf` objects containing geometric information about ABS data structures. The included objects are:

  - Statistical Area 1 2011 and 2016: `sa12011` or `sa12016`
  - Statistical Area 2 2011 and 2016: `sa22011` or `sa22016`
  - Statistical Area 3 2011 and 2016: `sa32011` or `sa32016`
  - Statistical Area 4 2011 and 2016: `sa42011` or `sa42016`
  - Greater Capital Cities 2011 and 2016: `gcc2011` or `gcc2016`
  - Remoteness Areas 2011 and 2016: `ra2011` or `ra2016`
  - State 2011 and 2016: `state2011` or `state2016`
  - Commonwealth Electoral Divisions 2018: `ced2018`
  - State Electoral Divisions 2018:`sed2018`
  - Local Government Areas 2016 and 2018: `lga2016` or `lga2018`
  - Postcodes 2016: `postcodes2016`

You can install the package from Github:


```r
remotes::install_github("wfmackey/absmapsdata")
library(absmapsdata)
```

You will also need the `sf` package installed to handle the `sf` objects:


```r
install.packages("sf")
library(sf)
```



### Making choropleth maps

Choropleth maps break an area into 'bits', and colours each 'bit' according to a variable.

SA4 is the largest non-state statistical area in the ABS ASGS standard. 

You can join the `sf` objects from `absmapsdata` to your dataset using `left_join`. The variable names might be different -- eg `sa4_name` compared to `sa4_name_2016` -- so use the `by` function to match them.



You then plot a map like you would any other `ggplot`: provide your data, then choose your `aes` and your `geom`. For maps with `sf` objects, the **key aesthetic** is `geometry = geometry`, and the **key geom** is `geom_sf`.

The argument `lwd` controls the line width of area borders.

Note that RStudio takes a long time to render a map in the 




Showing all of Australia on a single map is difficult: there are enormous areas that are home to few people which dominate the space. Showing individual states or capital city areas can sometimes be useful. 

To do this, filter the `map_data` object: 




#### Adding labels to maps

You can add labels to choropleth maps with the standard `geom_text` or `geom_label`. Because it is likely that some labels will overlap, `ggrepel::geom_text_repel` or `ggrepel::geom_label_repel` is usually the better option.

To use `geom_(text|label)_repel`, you need to tell `ggrepel` where in 




```r
map <- map_data %>% 
        filter(state == "Vic") %>% 
        ggplot(aes(geometry = geometry)) +
        geom_sf(aes(fill = pop_change),
                lwd = .1,
                colour = "black") +
        theme_void() +
        grattan_fill_manual(discrete = FALSE, 
                            palette = "diverging",
                            limits = c(-20, 20),
                            breaks = seq(-20, 20, 10)) +
  geom_label_repel(aes(label = sa4_name),
                  stat = "sf_coordinates", nudge_x = 1000, segment.alpha = .5,
                  size = 4, 
                  direction = "y",
                  label.size = 0, 
                  label.padding = unit(0.1, "lines"),
                  colour = "grey50",
                  segment.color = "grey50") + 
  scale_y_continuous(expand = expand_scale(mult = c(0, .2))) + 
  theme(legend.position = "top") + 
  labs(fill = "Population \nchange")

map
```


## Creating simple interactive graphs with `plotly`

`plotly::ggplotly()`


