# Data transformation with `dplyr`

This section focusses on transforming rectangular datasets. 


The `dplyr` verbs and concepts covered in this chapter are also covered in this video by Garrett Grolemund (a co-author of _[R for Data Science](https://r4ds.had.co.nz/)_ with Hadley Wickham). 


```
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

<iframe src="https://www.youtube.com/embed/y9KJmUGc8SE" width="100%" height="400px"></iframe>


## Set up

Load your packages first. This chapter just uses the packages contained in the `tidyverse`:


```r
library(tidyverse)
```


The `sa3_income` dataset will be used for all key examples in this chapter.^[This is a tidied version of the [ABS Employee income by occupation and sex, 2010-11 to 2016-16](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/6524.0.55.0022011-2016?OpenDocument) dataset.] It is a long dataset from the ABS that contains the average income and number of workers by Statistical Area 3, occupation and sex between 2011 and 2016.

If you haven't already, download the `sa3_income.csv` file to your own `data` folder:


```r
download.file(url = "https://raw.githubusercontent.com/grattan/R_at_Grattan/master/data/sa3_income.csv",
              destfile = "data/sa3_income.csv")
```

Then read it using the `read_csv` function:


```r
sa3_income <- read_csv("data/sa3_income.csv")
```

```
## Rows: 47899 Columns: 16
```

```
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (8): sa3_name, sa4_name, gcc_name, state, occupation, occ_short, prof, g...
## dbl (8): sa3, sa3_sqkm, sa3_income_percentile, year, median_income, average_...
```

```
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```




```r
head(sa3_income)
```

```
## # A tibble: 6 × 6
##    year sa3_name  state gender income workers
##   <dbl> <chr>     <chr> <chr>   <dbl>   <dbl>
## 1  2011 Belconnen ACT   Men    54105.   67774
## 2  2012 Belconnen ACT   Men    56724.   69435
## 3  2013 Belconnen ACT   Men    58918.   69697
## 4  2014 Belconnen ACT   Men    60525.   68613
## 5  2015 Belconnen ACT   Men    60964.   63428
## 6  2016 Belconnen ACT   Men    63389.   69828
```


## The pipe: `%>%`

You will almost always want to perform more than one of the operations described below on your dataset. One way to perform multiple operations, one after the other, is to 'nest' them inside. This nesting will be _painfully_ familiar to Excel users.

Consider an example of baking and eating a cake.^[XXX cannot remember the source for this example; probably Hadley? Jenny Bryan? Maybe somenone else?] You take the ingredients, combine them, then mix, then bake, and then eat them. In a nested formula, this process looks like:


```r
eat(bake(mix(combine(ingredients))))
```

In a nested formula, you need to start in the _middle_ and work your way out. This means anyone reading your code -- including you in the future! -- needs to start in the middle and work their way out. But because we're used to left-right reading, we're not particularly good at naturally interpreting nested functions like this one.

This is where the 'pipe' can help. The pipe operator `%>%` (keyboard shortcut: `cmd + shift + m`)  takes an argument on the left and 'pipes' it into the function on the right. Each time you see `%>%`, you can read it as 'and then'. 

So the you could express the baking example as:


```r
ingredients %>% # and then
  combine() %>% # and then
  mix() %>% # and then
  bake() %>% # and then
  eat() # yum!
```

Which reads as:

> take the `ingredients`, then `combine`, then `mix`, then `bake`, then `eat` them.

This does the same thing as `eat(bake(mix(combine(ingredients))))`. But it's much nicer and more natural to read, and to _write_.

Another example: the function `paste` takes arguments and combines them together into a single string. So you could use the pipe to:


```r
"hello" %>% paste("dear", "reader")
```

```
## [1] "hello dear reader"
```

which is the same as


```r
paste("hello", "dear", "reader")
```

```
## [1] "hello dear reader"
```


Or you could define a vector of numbers and pass^['pass' can also be used to mean 'pipe'.] them to the `sum()` function:


```r
my_numbers <- c(1, 2, 3, 5, 8, 13)

my_numbers %>% sum()
```

```
## [1] 32
```

Or you could skip the intermediate step altogether:

```r
c(1, 2, 3, 5, 8, 13) %>% 
  sum()
```

```
## [1] 32
```

This is the same as:


```r
sum(c(1, 2, 3, 5, 8, 13))
```

```
## [1] 32
```


The benefits of piping become more clear when you want to perform a few sequential operations on a dataset. For example, you might want to `filter` the observations in the `sa3_income` data to only `NSW`, before you `group_by` `gender` and `summarise` the `income` of these grops (these functions are explained in detail below). All of these functions take 'data' as the first argument, and are designed to be used with pipes.

Like the income differential it shows, writing this process as a nested function is outrageous and hard to read:


```r
summarise((group_by(filter(sa3_income, state == "NSW"), gender)), av_mean_income = mean(income))
```

```
## # A tibble: 2 × 2
##   gender av_mean_income
##   <chr>           <dbl>
## 1 Men            58202.
## 2 Women          41662.
```

The original common way to avoid this unseemly nesting in `R` was to assign each 'step' its own object, which is definitely clearer:


```r
data1 <- filter(sa3_income, state == "NSW")
data2 <- group_by(data1, gender)
data3 <- summarise(data2, av_mean_income = mean(income))
data3
```

```
## # A tibble: 2 × 2
##   gender av_mean_income
##   <chr>           <dbl>
## 1 Men            58202.
## 2 Women          41662.
```

And using pipes make the steps clearer still: 

1. take the `sa3_income` data, and then %>% 
2. `filter` it to only NSW, and then %>% 
3. `group` it by gender, and then %>% 
4. `summarise` it


```r
sa3_income %>%  # and then
  filter(state == "NSW") %>% # and then 
  group_by(gender) %>% # and then
  summarise(av_mean_income = mean(income))
```

```
## # A tibble: 2 × 2
##   gender av_mean_income
##   <chr>           <dbl>
## 1 Men            58202.
## 2 Women          41662.
```

 


## Select variables with `select()`

The `select` function takes a dataset and **keeps** or **drops** variables (columns) that are specified.

For example, look at the variables that are in the `sa3_income` dataset (using the `names()` function):


```r
names(sa3_income)
```

```
## [1] "year"     "sa3_name" "state"    "gender"   "income"   "workers"
```

If you wanted to keep just the `state` and `income` variables, you could take the `sa3_income` dataset and select just those variables:


```r
sa3_income %>% 
  select(state, income)
```

```
## # A tibble: 4,019 × 2
##    state income
##    <chr>  <dbl>
##  1 ACT   54105.
##  2 ACT   56724.
##  3 ACT   58918.
##  4 ACT   60525.
##  5 ACT   60964.
##  6 ACT   63389.
##  7 ACT   53139.
##  8 ACT   54515.
##  9 ACT   58132.
## 10 ACT   56247.
## # … with 4,009 more rows
```

Or you could use `-` (minus) to remove the `state` and `sa3_name` variables:^[This is the same as **keeping everything except** the `state` and `sa3_name` variables.]


```r
sa3_income %>% 
  select(-state, -sa3_name)
```

```
## # A tibble: 4,019 × 4
##     year gender income workers
##    <dbl> <chr>   <dbl>   <dbl>
##  1  2011 Men    54105.   67774
##  2  2012 Men    56724.   69435
##  3  2013 Men    58918.   69697
##  4  2014 Men    60525.   68613
##  5  2015 Men    60964.   63428
##  6  2016 Men    63389.   69828
##  7  2011 Men    53139.     666
##  8  2012 Men    54515.     647
##  9  2013 Men    58132.     641
## 10  2014 Men    56247.     561
## # … with 4,009 more rows
```

### Selecting groups of variables

Sometimes it can be useful to keep or drop variables with names that have a certain characteristic; they begin with some text string, or end with one, or contain one, or have some other pattern altogether. 

You can use patterns and ['select helpers'](https://tidyselect.r-lib.org/reference/select_helpers.html)^[Explained in useful detail by the Tidyverse people at https://tidyselect.r-lib.org/reference/select_helpers.html] 
from the Tidyverse to help deal with these sets of variables.

For example, if you want to keep just the SA3 and state variables -- ie the variables that start with `"s"` -- you could: 


```r
sa3_income %>% 
  select(starts_with("s"))
```

```
## # A tibble: 4,019 × 2
##    sa3_name      state
##    <chr>         <chr>
##  1 Belconnen     ACT  
##  2 Belconnen     ACT  
##  3 Belconnen     ACT  
##  4 Belconnen     ACT  
##  5 Belconnen     ACT  
##  6 Belconnen     ACT  
##  7 Canberra East ACT  
##  8 Canberra East ACT  
##  9 Canberra East ACT  
## 10 Canberra East ACT  
## # … with 4,009 more rows
```

Or, instead, if you wanted to keep just the variables that contain `"er"`, you could:


```r
sa3_income %>% 
  select(contains("er"))
```

```
## # A tibble: 4,019 × 2
##    gender workers
##    <chr>    <dbl>
##  1 Men      67774
##  2 Men      69435
##  3 Men      69697
##  4 Men      68613
##  5 Men      63428
##  6 Men      69828
##  7 Men        666
##  8 Men        647
##  9 Men        641
## 10 Men        561
## # … with 4,009 more rows
```

And if you wanted to keep **both** the `"s"` variables and the `"er"` variables, you could:


```r
sa3_income %>% 
  select(starts_with("s"), contains("er"), )
```

```
## # A tibble: 4,019 × 4
##    sa3_name      state gender workers
##    <chr>         <chr> <chr>    <dbl>
##  1 Belconnen     ACT   Men      67774
##  2 Belconnen     ACT   Men      69435
##  3 Belconnen     ACT   Men      69697
##  4 Belconnen     ACT   Men      68613
##  5 Belconnen     ACT   Men      63428
##  6 Belconnen     ACT   Men      69828
##  7 Canberra East ACT   Men        666
##  8 Canberra East ACT   Men        647
##  9 Canberra East ACT   Men        641
## 10 Canberra East ACT   Men        561
## # … with 4,009 more rows
```

The full list of these handy select functions are provided with the `?tidyselect::select_helpers` documentation, listed below:

- `starts_with()`: Starts with a prefix.
- `ends_with()`: Ends with a suffix.
- `contains()`: Contains a literal string.
- `matches()`: Matches a regular expression.
- `num_range()`: Matches a numerical range like x01, x02, x03.
- `one_of()`: Matches variable names in a character vector.
- `everything()`: Matches all variables.
- `last_col()`: Select last variable, possibly with an offset.





## Filter with `filter()`

The `filter` function takes a dataset and **keeps** observations (rows) that meet the **conditions**. 

`filter` has one required first argument -- the data -- and then as many 'conditions' as you want to provide. 


### Conditions; logical operations; `TRUE` or `FALSE`

The **conditions** are logical operations, meaning they are a statement that return either `TRUE` or `FALSE` in the computer's mind.^[Computers' mind, more likely.] 

We know, for instance, that `12` is equal to `12` and that `1 + 2` does not equal `12`. Which means if we type `12 == 12` or `1 + 2 == 12` into the console it should give `FALSE`:


```r
12 == 12
```

```
## [1] TRUE
```

```r
1 + 2 == 12
```

```
## [1] FALSE
```

Or, we can see if `1 + 2` is equal `5` or `9` or `3` by providing a vector of those numbers:


```r
1 + 2 == c(5, 9, 3)
```

```
## [1] FALSE FALSE  TRUE
```

This works for character strings, too:


```r
"apple" == c("orange", "apple", 7)
```

```
## [1] FALSE  TRUE FALSE
```


A lot of what we do in 'data science' is based on these `TRUE` and `FALSE` conditions. 

### Filtering data with `filter`

Turning back to the `sa3_income` data, if you just wanted to see observations people in `NT`:


```r
sa3_income %>% 
  filter(state == "NT")
```

```
## # A tibble: 123 × 6
##     year sa3_name      state gender income workers
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl>
##  1  2011 Alice Springs NT    Men    52602.   23663
##  2  2012 Alice Springs NT    Men    55050.   24065
##  3  2013 Alice Springs NT    Men    57251.   24218
##  4  2014 Alice Springs NT    Men    58403.   24566
##  5  2015 Alice Springs NT    Men    60084.   24562
##  6  2016 Alice Springs NT    Men    64330.   22048
##  7  2011 Barkly        NT    Men    50517.    2272
##  8  2012 Barkly        NT    Men    52474.    2321
##  9  2013 Barkly        NT    Men    55006.    2364
## 10  2014 Barkly        NT    Men    56543.    2234
## # … with 113 more rows
```

Or you might just want to look at high-income (`income > 70,000`) areas from Victoria in 2015:


```r
sa3_income %>% 
  filter(state == "Vic",
         income > 70000,
         year == 2015)
```

```
## # A tibble: 3 × 6
##    year sa3_name           state gender income workers
##   <dbl> <chr>              <chr> <chr>   <dbl>   <dbl>
## 1  2015 Bayside            Vic   Men    77175.   62460
## 2  2015 Stonnington - East Vic   Men    70652.   27922
## 3  2015 Stonnington - West Vic   Men    70234.   47597
```


Each of the commas in the `filter` function represent an 'and' `&`. So you can read the steps above as: 

> take the `sa3_income` data and filter to keep only the observations that are from Victoria`,` and that have a average income above 70k`,` and are from the year 2015.


Sometimes you might want to relax a little, keeping observations from one category **or** another. You can do this with the **or** symbol: `|`^[On the keyboard: `shift` + `backslash`]


```r
sa3_income %>% 
  filter(state == "Vic" | state == "Tas",
         income > 100000,
         year == 2015 | year == 2016)
```

```
## # A tibble: 0 × 6
## # … with 6 variables: year <dbl>, sa3_name <chr>, state <chr>, gender <chr>,
## #   income <dbl>, workers <dbl>
```

Which reads:

> take the `sa3_income` data and filter to keep only the observations that are from Victoria OR NSW, and that have a average income above 100k, and are from the year 2015 OR 2016.


### Grouped filtering with `group_by()` 

The `group_by` function groups a dataset by given variables. This effectively generates one dataset per group within your main dataset. Any function you then apply -- like `filter()` -- will be applied to _each_ of the grouped datasets. 

For example, you could filter the `sa3_income` dataset to keep just the observation with the highest average income:


```r
sa3_income %>% 
  filter(income == max(income))
```

```
## # A tibble: 1 × 6
##    year sa3_name     state gender  income workers
##   <dbl> <chr>        <chr> <chr>    <dbl>   <dbl>
## 1  2015 West Pilbara WA    Men    107844.   22928
```

To keep the observations that have the highest average incomes _in each state_, you can `group_by` state, then `filter`:^[Wow they are all men!]


```r
sa3_income %>% 
  group_by(state) %>% 
  filter(income == max(income))
```

```
## # A tibble: 8 × 6
## # Groups:   state [8]
##    year sa3_name                 state gender  income workers
##   <dbl> <chr>                    <chr> <chr>    <dbl>   <dbl>
## 1  2013 Molonglo                 ACT   Men     92947.     227
## 2  2016 North Sydney - Mosman    NSW   Men     90668.   74702
## 3  2016 Christmas Island         NT    Men     84474.     621
## 4  2015 Gladstone                Qld   Men     97282.   48026
## 5  2015 Outback - North and East SA    Men     71791.   15849
## 6  2016 West Coast               Tas   Men     58116.   11117
## 7  2016 Bayside                  Vic   Men     78624.   64541
## 8  2015 West Pilbara             WA    Men    107844.   22928
```

From the description of the tibble above, you can learn that your data has 8 unique groups of state: 

`## # Groups:       state [8]`

Or you could keep the observations with the _lowest_ average incomes in _each state and year_:^[Wow they are all women!]


```r
sa3_income %>% 
  group_by(state, year) %>% 
  filter(income == min(income))
```

```
## # A tibble: 48 × 6
## # Groups:   state, year [48]
##     year sa3_name                state gender income workers
##    <dbl> <chr>                   <chr> <chr>   <dbl>   <dbl>
##  1  2014 Cocos (Keeling) Islands NT    Men    32652.      45
##  2  2011 Belconnen               ACT   Women  43235    22708
##  3  2014 Belconnen               ACT   Women  48399.   22750
##  4  2015 Belconnen               ACT   Women  48814.   20577
##  5  2016 Belconnen               ACT   Women  50756.   22982
##  6  2012 Gungahlin               ACT   Women  45241    13647
##  7  2013 North Canberra          ACT   Women  45844.   11965
##  8  2012 Great Lakes             NSW   Women  32590     4730
##  9  2015 Lord Howe Island        NSW   Women  34173.      75
## 10  2011 Lower Murray            NSW   Women  30800.    2122
## # … with 38 more rows
```

The dataset remains grouped after your function(s). To explicitly 'ungroup' your data, add the `ungroup` function to your chain (the 'Groups' note has disappeared in the below):


```r
sa3_income %>% 
  group_by(state, year) %>% 
  filter(income == min(income)) %>% 
  ungroup()
```

```
## # A tibble: 48 × 6
##     year sa3_name                state gender income workers
##    <dbl> <chr>                   <chr> <chr>   <dbl>   <dbl>
##  1  2014 Cocos (Keeling) Islands NT    Men    32652.      45
##  2  2011 Belconnen               ACT   Women  43235    22708
##  3  2014 Belconnen               ACT   Women  48399.   22750
##  4  2015 Belconnen               ACT   Women  48814.   20577
##  5  2016 Belconnen               ACT   Women  50756.   22982
##  6  2012 Gungahlin               ACT   Women  45241    13647
##  7  2013 North Canberra          ACT   Women  45844.   11965
##  8  2012 Great Lakes             NSW   Women  32590     4730
##  9  2015 Lord Howe Island        NSW   Women  34173.      75
## 10  2011 Lower Murray            NSW   Women  30800.    2122
## # … with 38 more rows
```





## Edit and add new variables with `mutate()`

To add new variables to your dataset, use the `mutate` function. Like all `dplyr` verbs, the first argument to `mutate` is your data. Then define variables using a `new_variable_name = x` format, where `x` can be a single number or character string, or simple operation or function using current variables. 


To add a new variable to the `sa3_income` dataset that shows the log the number of workers:


```r
sa3_income %>% 
  mutate(log_workers = log(workers))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers log_workers
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl>       <dbl>
##  1  2011 Belconnen     ACT   Men    54105.   67774       11.1 
##  2  2012 Belconnen     ACT   Men    56724.   69435       11.1 
##  3  2013 Belconnen     ACT   Men    58918.   69697       11.2 
##  4  2014 Belconnen     ACT   Men    60525.   68613       11.1 
##  5  2015 Belconnen     ACT   Men    60964.   63428       11.1 
##  6  2016 Belconnen     ACT   Men    63389.   69828       11.2 
##  7  2011 Canberra East ACT   Men    53139.     666        6.50
##  8  2012 Canberra East ACT   Men    54515.     647        6.47
##  9  2013 Canberra East ACT   Men    58132.     641        6.46
## 10  2014 Canberra East ACT   Men    56247.     561        6.33
## # … with 4,009 more rows
```

To edit a variable, redefine it in `mutate`. For example, if you wanted to take the last two digits of year:


```r
sa3_income %>% 
  mutate(year = as.integer(year - 2000))
```

```
## # A tibble: 4,019 × 6
##     year sa3_name      state gender income workers
##    <int> <chr>         <chr> <chr>   <dbl>   <dbl>
##  1    11 Belconnen     ACT   Men    54105.   67774
##  2    12 Belconnen     ACT   Men    56724.   69435
##  3    13 Belconnen     ACT   Men    58918.   69697
##  4    14 Belconnen     ACT   Men    60525.   68613
##  5    15 Belconnen     ACT   Men    60964.   63428
##  6    16 Belconnen     ACT   Men    63389.   69828
##  7    11 Canberra East ACT   Men    53139.     666
##  8    12 Canberra East ACT   Men    54515.     647
##  9    13 Canberra East ACT   Men    58132.     641
## 10    14 Canberra East ACT   Men    56247.     561
## # … with 4,009 more rows
```





### Using `if_else()` or `case_when()` 


Sometimes you want to create a new variable based on some sort of condition. Like, if the number of workers in an `sa3` is more than `2,000`, set the new `many_workers` variable to `TRUE`, and set it to `FALSE` otherwise. 

This kind of operation can be thought of as `if_else`: `if` (some condition), do this, otherwise do that. 

That's what the `if_else()` function does. It takes three arguments: a condition, a value if that condition is true, and a value if that condition is false.

You can use the `if_else()` function when you are creating new variables in a `mutate` command:


```r
sa3_income %>% 
  mutate(many_workers = if_else(workers > 2000, "Many workers", "Not many workers"))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers many_workers    
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl> <chr>           
##  1  2011 Belconnen     ACT   Men    54105.   67774 Many workers    
##  2  2012 Belconnen     ACT   Men    56724.   69435 Many workers    
##  3  2013 Belconnen     ACT   Men    58918.   69697 Many workers    
##  4  2014 Belconnen     ACT   Men    60525.   68613 Many workers    
##  5  2015 Belconnen     ACT   Men    60964.   63428 Many workers    
##  6  2016 Belconnen     ACT   Men    63389.   69828 Many workers    
##  7  2011 Canberra East ACT   Men    53139.     666 Not many workers
##  8  2012 Canberra East ACT   Men    54515.     647 Not many workers
##  9  2013 Canberra East ACT   Men    58132.     641 Not many workers
## 10  2014 Canberra East ACT   Men    56247.     561 Not many workers
## # … with 4,009 more rows
```

Which reads:

> Take the `sa3_income` dataset, and then add a variable that says 'Many workers' if there are more than 2,000 workers, and 'Not many workers' if there are fewer-or-equal than 2,000 workers.

With the `if_else` function, you take one conditional statement and return something based on that. But **often** you don't want to be so binary; you want to do this if this is true, that if that is true, and the other if the other is true, etc. 


This could be done by nesting `if_else` statements:


```r
sa3_income %>% 
  mutate(worker_group = if_else(workers > 2000, "More than 2000 workers", 
                                if_else(workers > 1000, "1000-2000 workers",
                                        if_else(workers > 500, "500-1000 workers",
                                                "500 workers or less"))))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers worker_group          
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl> <chr>                 
##  1  2011 Belconnen     ACT   Men    54105.   67774 More than 2000 workers
##  2  2012 Belconnen     ACT   Men    56724.   69435 More than 2000 workers
##  3  2013 Belconnen     ACT   Men    58918.   69697 More than 2000 workers
##  4  2014 Belconnen     ACT   Men    60525.   68613 More than 2000 workers
##  5  2015 Belconnen     ACT   Men    60964.   63428 More than 2000 workers
##  6  2016 Belconnen     ACT   Men    63389.   69828 More than 2000 workers
##  7  2011 Canberra East ACT   Men    53139.     666 500-1000 workers      
##  8  2012 Canberra East ACT   Men    54515.     647 500-1000 workers      
##  9  2013 Canberra East ACT   Men    58132.     641 500-1000 workers      
## 10  2014 Canberra East ACT   Men    56247.     561 500-1000 workers      
## # … with 4,009 more rows
```

But that syntax can be a bit difficult to read. You can do this in a clearer way using `case_when`:


```r
sa3_income %>% 
  mutate(worker_group = case_when(
    workers > 20000 ~ "More than 20,000 workers",
    workers > 10000 ~ "More than 10,000 workers",
    workers >  5000 ~ "More than 5,000 workers",
    workers <= 5000 ~ "5,000 or fewer workers"
  ))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers worker_group            
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl> <chr>                   
##  1  2011 Belconnen     ACT   Men    54105.   67774 More than 20,000 workers
##  2  2012 Belconnen     ACT   Men    56724.   69435 More than 20,000 workers
##  3  2013 Belconnen     ACT   Men    58918.   69697 More than 20,000 workers
##  4  2014 Belconnen     ACT   Men    60525.   68613 More than 20,000 workers
##  5  2015 Belconnen     ACT   Men    60964.   63428 More than 20,000 workers
##  6  2016 Belconnen     ACT   Men    63389.   69828 More than 20,000 workers
##  7  2011 Canberra East ACT   Men    53139.     666 5,000 or fewer workers  
##  8  2012 Canberra East ACT   Men    54515.     647 5,000 or fewer workers  
##  9  2013 Canberra East ACT   Men    58132.     641 5,000 or fewer workers  
## 10  2014 Canberra East ACT   Men    56247.     561 5,000 or fewer workers  
## # … with 4,009 more rows
```

The `case_when` function takes the first condition (LHS) and applies some value (RHS) if it is true. It then moves to the next condition, and so on. Once an observation has been classified -- eg an observation has more than 20,000 workers -- it is ignored in proceeding conditions. 

Ending a `case_when` statement with `TRUE ~ [some value]` is a catch all, and will apply the RHS `[some value]` to any observations that did not meet an explicit condition. For example, you could end the worker classification with:


```r
sa3_income %>% 
  mutate(worker_group = case_when(
    workers > 20000 ~ "More than 20,000 workers",
    workers > 10000 ~ "More than 10,000 workers",
    workers >  5000 ~ "More than 5,000 workers",
    TRUE ~ "5,000 or fewer workers"
  ))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers worker_group            
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl> <chr>                   
##  1  2011 Belconnen     ACT   Men    54105.   67774 More than 20,000 workers
##  2  2012 Belconnen     ACT   Men    56724.   69435 More than 20,000 workers
##  3  2013 Belconnen     ACT   Men    58918.   69697 More than 20,000 workers
##  4  2014 Belconnen     ACT   Men    60525.   68613 More than 20,000 workers
##  5  2015 Belconnen     ACT   Men    60964.   63428 More than 20,000 workers
##  6  2016 Belconnen     ACT   Men    63389.   69828 More than 20,000 workers
##  7  2011 Canberra East ACT   Men    53139.     666 5,000 or fewer workers  
##  8  2012 Canberra East ACT   Men    54515.     647 5,000 or fewer workers  
##  9  2013 Canberra East ACT   Men    58132.     641 5,000 or fewer workers  
## 10  2014 Canberra East ACT   Men    56247.     561 5,000 or fewer workers  
## # … with 4,009 more rows
```

Meaning, for any observation that did not have workers more than 20,000 or more than 10,000 or more than 5,000, assign the value `"5,000 or fewer workers"`.

Observations that do not meet a condition will be set to `NA`:


```r
sa3_income %>% 
  mutate(worker_group = case_when(
    workers > 10e6 ~ "More than 10 million workers"
  ))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers worker_group
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl> <chr>       
##  1  2011 Belconnen     ACT   Men    54105.   67774 <NA>        
##  2  2012 Belconnen     ACT   Men    56724.   69435 <NA>        
##  3  2013 Belconnen     ACT   Men    58918.   69697 <NA>        
##  4  2014 Belconnen     ACT   Men    60525.   68613 <NA>        
##  5  2015 Belconnen     ACT   Men    60964.   63428 <NA>        
##  6  2016 Belconnen     ACT   Men    63389.   69828 <NA>        
##  7  2011 Canberra East ACT   Men    53139.     666 <NA>        
##  8  2012 Canberra East ACT   Men    54515.     647 <NA>        
##  9  2013 Canberra East ACT   Men    58132.     641 <NA>        
## 10  2014 Canberra East ACT   Men    56247.     561 <NA>        
## # … with 4,009 more rows
```


Like any `if` or `if_else`, you can provide more than one condition to your conditional statement:


```r
sa3_income %>% 
  mutate(women_group = case_when(
    gender == "Women" & workers > 20000 ~ "More than 20,000 women",
    gender == "Women" & workers > 10000 ~ "More than 10,000 women",
    gender == "Women" & workers >  5000 ~ "More than 5,000 women",
    gender == "Women"                  ~ "5,000 or fewer women",
    TRUE ~ "Men"
  ))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers women_group
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl> <chr>      
##  1  2011 Belconnen     ACT   Men    54105.   67774 Men        
##  2  2012 Belconnen     ACT   Men    56724.   69435 Men        
##  3  2013 Belconnen     ACT   Men    58918.   69697 Men        
##  4  2014 Belconnen     ACT   Men    60525.   68613 Men        
##  5  2015 Belconnen     ACT   Men    60964.   63428 Men        
##  6  2016 Belconnen     ACT   Men    63389.   69828 Men        
##  7  2011 Canberra East ACT   Men    53139.     666 Men        
##  8  2012 Canberra East ACT   Men    54515.     647 Men        
##  9  2013 Canberra East ACT   Men    58132.     641 Men        
## 10  2014 Canberra East ACT   Men    56247.     561 Men        
## # … with 4,009 more rows
```






### Grouped mutates with `group_by()` 

Like filtering, you can add or edit variables on grouped data. For example, you could get the average number of workers in each SA3 over the 6 years:


```r
sa3_income %>% 
  group_by(sa3_name, gender) %>% 
  mutate(av_workers = mean(workers))
```

```
## # A tibble: 4,019 × 7
## # Groups:   sa3_name, gender [672]
##     year sa3_name      state gender income workers av_workers
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl>      <dbl>
##  1  2011 Belconnen     ACT   Men    54105.   67774     68129.
##  2  2012 Belconnen     ACT   Men    56724.   69435     68129.
##  3  2013 Belconnen     ACT   Men    58918.   69697     68129.
##  4  2014 Belconnen     ACT   Men    60525.   68613     68129.
##  5  2015 Belconnen     ACT   Men    60964.   63428     68129.
##  6  2016 Belconnen     ACT   Men    63389.   69828     68129.
##  7  2011 Canberra East ACT   Men    53139.     666       641.
##  8  2012 Canberra East ACT   Men    54515.     647       641.
##  9  2013 Canberra East ACT   Men    58132.     641       641.
## 10  2014 Canberra East ACT   Men    56247.     561       641.
## # … with 4,009 more rows
```

Above, the `mean()` function is applied separately to each unique group of `sa3_name` and `gender`, taking one average for women in Queanbeyan, one average for men in Queanbeyan, and so on. 

Grouping a dataset does not prohibit operations that don't utilise the grouping. For example, you could get each year's workers relative to the SA3/gender average in the same call to `mutate`:


```r
sa3_income %>% 
  group_by(sa3_name, gender) %>% 
  mutate(av_workers = mean(workers),
         worker_diff = workers / av_workers)
```

```
## # A tibble: 4,019 × 8
## # Groups:   sa3_name, gender [672]
##     year sa3_name      state gender income workers av_workers worker_diff
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl>      <dbl>       <dbl>
##  1  2011 Belconnen     ACT   Men    54105.   67774     68129.       0.995
##  2  2012 Belconnen     ACT   Men    56724.   69435     68129.       1.02 
##  3  2013 Belconnen     ACT   Men    58918.   69697     68129.       1.02 
##  4  2014 Belconnen     ACT   Men    60525.   68613     68129.       1.01 
##  5  2015 Belconnen     ACT   Men    60964.   63428     68129.       0.931
##  6  2016 Belconnen     ACT   Men    63389.   69828     68129.       1.02 
##  7  2011 Canberra East ACT   Men    53139.     666       641.       1.04 
##  8  2012 Canberra East ACT   Men    54515.     647       641.       1.01 
##  9  2013 Canberra East ACT   Men    58132.     641       641.       1.00 
## 10  2014 Canberra East ACT   Men    56247.     561       641.       0.875
## # … with 4,009 more rows
```


See that the data remains grouped after the `mutate`. You can explicitly `ungroup()` afterwards:


```r
sa3_income %>% 
  group_by(sa3_name, gender) %>% 
  mutate(av_workers = mean(workers),
         worker_diff = workers / av_workers) %>% 
  ungroup()
```

```
## # A tibble: 4,019 × 8
##     year sa3_name      state gender income workers av_workers worker_diff
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl>      <dbl>       <dbl>
##  1  2011 Belconnen     ACT   Men    54105.   67774     68129.       0.995
##  2  2012 Belconnen     ACT   Men    56724.   69435     68129.       1.02 
##  3  2013 Belconnen     ACT   Men    58918.   69697     68129.       1.02 
##  4  2014 Belconnen     ACT   Men    60525.   68613     68129.       1.01 
##  5  2015 Belconnen     ACT   Men    60964.   63428     68129.       0.931
##  6  2016 Belconnen     ACT   Men    63389.   69828     68129.       1.02 
##  7  2011 Canberra East ACT   Men    53139.     666       641.       1.04 
##  8  2012 Canberra East ACT   Men    54515.     647       641.       1.01 
##  9  2013 Canberra East ACT   Men    58132.     641       641.       1.00 
## 10  2014 Canberra East ACT   Men    56247.     561       641.       0.875
## # … with 4,009 more rows
```






## Summarise data with `summarise()`

Summarising is a useful way to assess and present data. The `summarise` function collapses your data down into a single row, performing the operation(s) you provide:



```r
sa3_income %>% 
  summarise(mean_income = mean(income),
            total_workers = sum(workers))  # this is a silly statistic
```

```
## # A tibble: 1 × 2
##   mean_income total_workers
##         <dbl>         <dbl>
## 1      50272.     117002608
```


Summarising is usually only useful when combined with `group_by`.


### Grouped summaries with `group_by()` 

Grouped summaries can help change the _detail_ of your data. In the original `sa3_income` data, there is a unique `workers` observation for each year, SA3 and gender. If you wanted to aggregate that information up see the total number of workers for each year and SA3:


```r
sa3_income %>% 
  group_by(year, sa3_name) %>% 
  summarise(workers = sum(workers))
```

```
## # A tibble: 2,010 × 3
## # Groups:   year [6]
##     year sa3_name                             workers
##    <dbl> <chr>                                  <dbl>
##  1  2011 Adelaide City                          18048
##  2  2011 Adelaide Hills                         59794
##  3  2011 Albany                                 43811
##  4  2011 Albury                                 50490
##  5  2011 Alice Springs                          31563
##  6  2011 Armadale                               56088
##  7  2011 Armidale                               27957
##  8  2011 Auburn                                 57298
##  9  2011 Augusta - Margaret River - Busselton   35852
## 10  2011 Bald Hills - Everton Park              36273
## # … with 2,000 more rows
```

After the `summarise` function, the dataset grouping remains but is reduced by one -- so the right-hand-side grouping is lost. This enables a common combination to find a proportion of a group. For example, if you 

**Common functions to use with summarise**

Grouped summaries generate summary statistics for grouped data. It uses the same `summarise` function, but is preceded with a `group_by`. For example, if you want to find the average income for women and men:


```r
sa3_income %>% 
  group_by(gender) %>% 
  summarise(mean_income = mean(income))
```

```
## # A tibble: 2 × 2
##   gender mean_income
##   <chr>        <dbl>
## 1 Men         58780.
## 2 Women       41760.
```

Or the total workers in each year and state by gender:


```r
sa3_income %>% 
  group_by(year, state, gender) %>% 
  summarise(workers = sum(workers))
```

```
## # A tibble: 96 × 4
## # Groups:   year, state [48]
##     year state gender workers
##    <dbl> <chr> <chr>    <dbl>
##  1  2011 ACT   Men     265281
##  2  2011 ACT   Women    88632
##  3  2011 NSW   Men    4438272
##  4  2011 NSW   Women  1415914
##  5  2011 NT    Men     140946
##  6  2011 NT    Women    44413
##  7  2011 Qld   Men    2859150
##  8  2011 Qld   Women   918841
##  9  2011 SA    Men     997160
## 10  2011 SA    Women   325980
## # … with 86 more rows
```




## Arrange with `arrange()`

'doesn't add or subtract to your data'

Sorting data in one way or another can be useful. Use the `arrange` function to sort data by the provided variable(s). Like with `select`, you can use the minus sign `-` to reverse the order. 

For example, to find the areas in 2016 with the **least** workers:


```r
sa3_income %>%
  filter(year == 2016) %>% 
  arrange(workers)
```

```
## # A tibble: 670 × 6
##     year sa3_name                  state gender income workers
##    <dbl> <chr>                     <chr> <chr>   <dbl>   <dbl>
##  1  2016 Lord Howe Island          NSW   Women  37944       74
##  2  2016 Urriarra - Namadgi        ACT   Women  86672.      90
##  3  2016 Christmas Island          NT    Women  57640      141
##  4  2016 Canberra East             ACT   Women  52091.     182
##  5  2016 Lord Howe Island          NSW   Men    40292      255
##  6  2016 Urriarra - Namadgi        ACT   Men    86747.     296
##  7  2016 Christmas Island          NT    Men    84474.     621
##  8  2016 Barkly                    NT    Women  52552.     704
##  9  2016 Canberra East             ACT   Men    58035.     711
## 10  2016 Daly - Tiwi - West Arnhem NT    Women  50096.    1075
## # … with 660 more rows
```

You can provide more than one variable. To sort the data first by `state` and, within each state, by the most workers (ie sorting by negative workers):


```r
sa3_income %>%
  filter(year == 2016) %>% 
  arrange(state, -workers)
```

```
## # A tibble: 670 × 6
##     year sa3_name       state gender income workers
##    <dbl> <chr>          <chr> <chr>   <dbl>   <dbl>
##  1  2016 Belconnen      ACT   Men    63389.   69828
##  2  2016 Tuggeranong    ACT   Men    66921.   65248
##  3  2016 Gungahlin      ACT   Men    66714.   55176
##  4  2016 North Canberra ACT   Men    62258.   37481
##  5  2016 Woden Valley   ACT   Men    66853.   24690
##  6  2016 Belconnen      ACT   Women  50756.   22982
##  7  2016 Tuggeranong    ACT   Women  52058.   21949
##  8  2016 South Canberra ACT   Men    72437.   20998
##  9  2016 Gungahlin      ACT   Women  50908.   18134
## 10  2016 Weston Creek   ACT   Men    67242.   15500
## # … with 660 more rows
```

### `lead` and `lag` functions with `arrange`

Having your data arranged in the way you want lets you use the `lead` (looking forward) and `lag` (looking backward) functions. 

Both the `lead` and `lag` functions take a variable as their only requried argument. The default number of lags or leads is `1`, and this can be changed with the second argument. For example:


```r
sa3_income %>%
  mutate(last_workers = lag(workers))
```

```
## # A tibble: 4,019 × 7
##     year sa3_name      state gender income workers last_workers
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl>        <dbl>
##  1  2011 Belconnen     ACT   Men    54105.   67774           NA
##  2  2012 Belconnen     ACT   Men    56724.   69435        67774
##  3  2013 Belconnen     ACT   Men    58918.   69697        69435
##  4  2014 Belconnen     ACT   Men    60525.   68613        69697
##  5  2015 Belconnen     ACT   Men    60964.   63428        68613
##  6  2016 Belconnen     ACT   Men    63389.   69828        63428
##  7  2011 Canberra East ACT   Men    53139.     666        69828
##  8  2012 Canberra East ACT   Men    54515.     647          666
##  9  2013 Canberra East ACT   Men    58132.     641          647
## 10  2014 Canberra East ACT   Men    56247.     561          641
## # … with 4,009 more rows
```

If you wanted to see the growth rate of income over time, you could `arrange` then `group_by` your data before creating an `income_growth` variable that is `income / lag(income)`.



```r
sa3_income %>%
  arrange(sa3_name, gender, year) %>% 
  group_by(sa3_name, gender) %>% 
  mutate(income_growth = income / lag(income) - 1)
```

```
## # A tibble: 4,019 × 7
## # Groups:   sa3_name, gender [672]
##     year sa3_name      state gender income workers income_growth
##    <dbl> <chr>         <chr> <chr>   <dbl>   <dbl>         <dbl>
##  1  2011 Adelaide City SA    Men    48760.   13737       NA     
##  2  2012 Adelaide City SA    Men    49974.   13730        0.0249
##  3  2013 Adelaide City SA    Men    52975.   13955        0.0601
##  4  2014 Adelaide City SA    Men    54818.   13782        0.0348
##  5  2015 Adelaide City SA    Men    54185.   13930       -0.0115
##  6  2016 Adelaide City SA    Men    56689.   15300        0.0462
##  7  2011 Adelaide City SA    Women  38359.    4311       NA     
##  8  2012 Adelaide City SA    Women  40409.    4219        0.0534
##  9  2013 Adelaide City SA    Women  41287.    4281        0.0217
## 10  2014 Adelaide City SA    Women  42872     4200        0.0384
## # … with 4,009 more rows
```




## Putting it all together

You will often use a combination of the above `dplyr` functions to get your data into shape. 

For example, say you want to get the total workers and total income in each state and year by gender. You could start with the `sa3_income` dataset, and then filter to year 2016, then create a new variable equal to `workers * income`, then group by year, state and gender before you summarise to get the statistics you want. With pipes, it could look something like:


```r
sa3_income %>% 
  filter(year == 2016) %>% 
  mutate(total_income = workers * income) %>% 
  group_by(year, state, gender) %>% 
  summarise(total_workers = sum(workers),
            mean_income = mean(income),
            total_income = sum(total_income))
```

```
## # A tibble: 16 × 6
## # Groups:   year, state [8]
##     year state gender total_workers mean_income  total_income
##    <dbl> <chr> <chr>          <dbl>       <dbl>         <dbl>
##  1  2016 ACT   Men           293558      67901.  19336462167.
##  2  2016 ACT   Women          97565      58222.   5180698359.
##  3  2016 NSW   Men          4952353      62207. 314145522637 
##  4  2016 NSW   Women        1575308      45003.  72633515399.
##  5  2016 NT    Men           157954      70961.  11488404531.
##  6  2016 NT    Women          48107      54143.   2607187917.
##  7  2016 Qld   Men          3110067      61794. 194644704512.
##  8  2016 Qld   Women         994436      44251.  44474845486.
##  9  2016 SA    Men          1041747      58602.  60710695691.
## 10  2016 SA    Women         340699      43034.  14705553952 
## 11  2016 Tas   Men           316727      54427.  17485898880.
## 12  2016 Tas   Women         104040      40685.   4305640148.
## 13  2016 Vic   Men          3926751      59814. 236830412049.
## 14  2016 Vic   Women        1264225      42816.  55273320473.
## 15  2016 WA    Men          1756314      72582. 127679046129.
## 16  2016 WA    Women         540767      48537.  26179412110.
```

Or say you want to see the annual growth rate of female workers in the SA3 with the highest female income. You could filter to keep women, and then group by SA3, then get the highest income for each of SA3, then ungroup and filter to keep only the SA3 with the highest income, then arrange by year and get the annual worker growth:


```r
sa3_income %>% 
  filter(gender == "Women") %>% 
  group_by(sa3_name) %>% 
  mutate(highest_income = max(income)) %>% 
  ungroup() %>% 
  filter(highest_income == max(highest_income)) %>% 
  arrange(year) %>% 
  mutate(worker_growth = workers / lag(workers) - 1)
```

```
## # A tibble: 6 × 8
##    year sa3_name           state gender income workers highest_income worker_growth
##   <dbl> <chr>              <chr> <chr>   <dbl>   <dbl>          <dbl>         <dbl>
## 1  2011 Urriarra - Namadgi ACT   Women  48525.      84         86672.        NA    
## 2  2012 Urriarra - Namadgi ACT   Women  51648.      96         86672.         0.143
## 3  2013 Urriarra - Namadgi ACT   Women  61858.     124         86672.         0.292
## 4  2014 Urriarra - Namadgi ACT   Women  72980.      99         86672.        -0.202
## 5  2015 Urriarra - Namadgi ACT   Women  68534.      72         86672.        -0.273
## 6  2016 Urriarra - Namadgi ACT   Women  86672.      90         86672.         0.25
```




## Joining datasets with `left_join()` 

Joining one dataset with another is incredibly useful and can be a difficult concept to grasp. The concept of joining one dataset to another is well introduced in [Chapter 13 of R for Data Science](https://r4ds.had.co.nz/relational-data.html): 

> It's rare that a data analysis involves only a single table of data. Typically you have many tables of data, and you must combine them to answer the questions that you’re interested in. Collectively, multiple tables of data are called **relational data** because it is the relations, not just the individual datasets, that are important.

The `dplyr` package ['Join two tbls together'](https://dplyr.tidyverse.org/reference/join.html) page provides a comprehensive summary of all join types. We will explore the key use of joins in our line of work -- `left_join` -- below. 

A 'left' join takes your main dataset, and adds variables from a new dataset based on a matching condition **that's unhelpful, fix**. If an observation in the new dataset is not found in the main dataset, it is ignored. 

It is probably easier to show this with an example. Say that we had the income percentiles of each SA3 in each year from a different data source:




```r
sa3_percentiles <- read_csv("data/sa3_percentiles.csv")
```

```
## Rows: 2010 Columns: 3
```

```
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (1): sa3_name
## dbl (2): year, sa3_income_percentile
```

```
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```




