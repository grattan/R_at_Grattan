# Data transformation

This section focusses on transforming rectangular datasets. 


## Set up



```r
library(tidyverse)
```


The `sa3_income` dataset will be used for all key examples in this chapter.^[From [ABS Employee income by occupation and sex, 2010-11 to 2016-16](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/6524.0.55.0022011-2016?OpenDocument)] It is a long dataset from the ABS that contains the average income and number of workers by Statistical Area 3, occupation and sex between 2010 and 2016.


```r
sa3_income <- read_csv("data/sa3_income.csv")
```

```
## Parsed with column specification:
## cols(
##   sa3 = col_double(),
##   sa3_name = col_character(),
##   sa3_sqkm = col_double(),
##   sa3_income_percentile = col_double(),
##   sa4_name = col_character(),
##   gcc_name = col_character(),
##   state = col_character(),
##   occupation = col_character(),
##   occ_short = col_character(),
##   prof = col_character(),
##   gender = col_character(),
##   year = col_double(),
##   median_income = col_double(),
##   average_income = col_double(),
##   total_income = col_double(),
##   workers = col_double()
## )
```

```r
head(sa3_income)
```

```
## # A tibble: 6 x 16
##     sa3 sa3_name sa3_sqkm sa3_income_perc… sa4_name gcc_name state
##   <dbl> <chr>       <dbl>            <dbl> <chr>    <chr>    <chr>
## 1 10102 Queanbe…    6511.               80 Capital… Rest of… NSW  
## 2 10102 Queanbe…    6511.               76 Capital… Rest of… NSW  
## 3 10102 Queanbe…    6511.               78 Capital… Rest of… NSW  
## 4 10102 Queanbe…    6511.               76 Capital… Rest of… NSW  
## 5 10102 Queanbe…    6511.               74 Capital… Rest of… NSW  
## 6 10102 Queanbe…    6511.               79 Capital… Rest of… NSW  
## # … with 9 more variables: occupation <chr>, occ_short <chr>, prof <chr>,
## #   gender <chr>, year <dbl>, median_income <dbl>, average_income <dbl>,
## #   total_income <dbl>, workers <dbl>
```





## The pipe: %>%

You will almost always want to perform more than one of the operations described below on your dataset. One way to perform multiple operations, one after the other, is to 'nest' them inside. This nesting will be _painfully_ familiar to Excel users.

Consider an example of baking and eating a cake.^[XXX cannot remember the source for this example; probably Hadley? Jenny Bryan? Maybe somenone else?] You take the ingredients, combine them, then mix, then bake, and then eat them. In a nested formula, this process looks like:


```r
eat(bake(mix(combine(ingredients))))
```

In a nested formula, you need to start in the _middle_ and work your way out. This means anyone reading your code -- including you in the future! -- needs to start in the middle and work their way out. But because we're used to left-right reading, we're not particularly good at naturally interpreting nested functions like this one.

This is where the 'pipe' can help. The pipe operator `%>%` (keyboard shortcut: `cmd + shift + m`)  takes an argument on the left and 'pipes' it into the function on the right. Each time you see `%>%`, you can read it as 'and then'. 

So the you could express the baking example as:


```r
ingredients %>% 
  combine() %>% 
  mix() %>% 
  bake() %>% 
  eat()
```

Which reads as:
> take the `ingredients`, then `combine`, then `mix`, then `bake`, then `eat` them.

This does the same thing as `eat(bake(mix(combine(ingredients))))`. But it's much nicer and more natural to read, and to _write_.

In simple `R` code, the function `paste` takes arguments and combines them together into a single string. So you could use the pipe to:


```r
"hello" %>% paste("dear", "reader")
```

```
## [1] "hello dear reader"
```


Or you could define a vector of numbers and pass^['pass' can also be used to mean 'pipe'.] them to the `sum()` function:


```r
my_numbers <- c(1, 2, 3, 5, 8, 100)

my_numbers %>% sum()
```

```
## [1] 119
```

Or you could skip the intermediate step altogether:

```r
c(1, 2, 3, 5, 8, 100) %>% 
  sum()
```

```
## [1] 119
```


The benefits of piping become more clear when you want to perform a few sequential operations on a dataset. For example, you might want to `filter` the observations in the `sa3_income` data to only `NSW`, before you `group_by` `gender` and `summarise` the `average_income` of these grops (these functions are explained in detail below). All of these functions take 'data' as the first argument, and are designed to be used with pipes.

Like the income differential it shows, writing this process as a nested function is outrageous and hard to read:


```r
summarise((group_by(filter(sa3_income, state == "NSW"), gender)), av_mean_income = mean(average_income))
```

```
## # A tibble: 2 x 2
##   gender av_mean_income
##   <chr>           <dbl>
## 1 Men            58296.
## 2 Women          41694.
```

The original common way to avoid this unseemly nesting in `R` was to assign each 'step' its own object, which is definitely clearer:


```r
data1 <- filter(sa3_income, state == "NSW")
data2 <- group_by(data1, gender)
data3 <- summarise(data2, av_mean_income = mean(average_income))
data3
```

```
## # A tibble: 2 x 2
##   gender av_mean_income
##   <chr>           <dbl>
## 1 Men            58296.
## 2 Women          41694.
```

And using pipes make the steps clearer still: 

1. take the `sa3_income` data, then %>% 
2. `filter` it to only NSW, then %>% 
3. `group` it by gender, then %>% 
4. `summarise` it


```r
sa3_income %>% 
  filter(state == "NSW") %>% 
  group_by(gender) %>% 
  summarise(av_mean_income = mean(average_income))
```

```
## # A tibble: 2 x 2
##   gender av_mean_income
##   <chr>           <dbl>
## 1 Men            58296.
## 2 Women          41694.
```

 

## Key `dplyr` functions:

All have the same syntax structure, which enable pipe-chains. 


## Select variables with `select()`

The `select` function takes a dataset and **keeps** or **drops** variables (columns) that are specified.

For example, look at the variables that are in the `sa3_income` dataset (using the `names()` function):


```r
names(sa3_income)
```

```
## [1] "year"           "sa3_name"       "state"          "occupation"    
## [5] "gender"         "average_income" "workers"        "sa3_sqkm"
```

If you wanted to keep just the `state` and `average_income` variables, you could take the `sa3_income` dataset and select just those variables:


```r
sa3_income %>% 
  select(state, average_income)
```

```
## # A tibble: 47,899 x 2
##    state average_income
##    <chr>          <dbl>
##  1 NSW            51306
##  2 NSW            53807
##  3 NSW            56405
##  4 NSW            57742
##  5 NSW            58286
##  6 NSW            61591
##  7 NSW            66869
##  8 NSW            69721
##  9 NSW            71859
## 10 NSW            74871
## # … with 47,889 more rows
```

Or you could use `-` (minus) to remove the `state` and `sa3_name` variables:^[This is the same as **keeping everything except** the `state` and `sa3_name` variables.]


```r
sa3_income %>% 
  select(-state, -sa3_name)
```

```
## # A tibble: 47,899 x 6
##     year occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2011 Admin      Women           51306    4597    6511.
##  2  2012 Admin      Women           53807    4708    6511.
##  3  2013 Admin      Women           56405    4732    6511.
##  4  2014 Admin      Women           57742    4573    6511.
##  5  2015 Admin      Women           58286    4087    6511.
##  6  2016 Admin      Women           61591    4448    6511.
##  7  2011 Admin      Men             66869    1459    6511.
##  8  2012 Admin      Men             69721    1467    6511.
##  9  2013 Admin      Men             71859    1460    6511.
## 10  2014 Admin      Men             74871    1394    6511.
## # … with 47,889 more rows
```

### Selecting groups of variables

Sometimes it can be useful to keep or drop variables with names that have a certain characteristic; they begin with some text string, or end with one, or contain one, or have some other pattern altogether. 

You can use patterns and ['select helpers'](https://tidyselect.r-lib.org/reference/select_helpers.html)^[Explained in useful detail by the Tidyverse people at https://tidyselect.r-lib.org/reference/select_helpers.html] 
from the Tidyverse to help deal with these sets of variables.

For example, if you want to keep just the SA3 and SA4 variables -- ie the variables that start with `"sa"` -- you could: 


```r
sa3_income %>% 
  select(starts_with("sa"))
```

```
## # A tibble: 47,899 x 2
##    sa3_name   sa3_sqkm
##    <chr>         <dbl>
##  1 Queanbeyan    6511.
##  2 Queanbeyan    6511.
##  3 Queanbeyan    6511.
##  4 Queanbeyan    6511.
##  5 Queanbeyan    6511.
##  6 Queanbeyan    6511.
##  7 Queanbeyan    6511.
##  8 Queanbeyan    6511.
##  9 Queanbeyan    6511.
## 10 Queanbeyan    6511.
## # … with 47,889 more rows
```

Or, instead, if you wanted to keep just the variables that contain `"income"`, you could:


```r
sa3_income %>% 
  select(contains("income"))
```

```
## # A tibble: 47,899 x 1
##    average_income
##             <dbl>
##  1          51306
##  2          53807
##  3          56405
##  4          57742
##  5          58286
##  6          61591
##  7          66869
##  8          69721
##  9          71859
## 10          74871
## # … with 47,889 more rows
```

And if you wanted to keep **both** the `"sa"` variables and the `"income"` variables, you could:


```r
sa3_income %>% 
  select(starts_with("sa"), contains("income"), )
```

```
## # A tibble: 47,899 x 3
##    sa3_name   sa3_sqkm average_income
##    <chr>         <dbl>          <dbl>
##  1 Queanbeyan    6511.          51306
##  2 Queanbeyan    6511.          53807
##  3 Queanbeyan    6511.          56405
##  4 Queanbeyan    6511.          57742
##  5 Queanbeyan    6511.          58286
##  6 Queanbeyan    6511.          61591
##  7 Queanbeyan    6511.          66869
##  8 Queanbeyan    6511.          69721
##  9 Queanbeyan    6511.          71859
## 10 Queanbeyan    6511.          74871
## # … with 47,889 more rows
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

We know, for instance, that `1 + 2` does not equal `12`. Which means if we type `1 + 2 == 12` into the console it should give `FALSE`:


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
## # A tibble: 1,403 x 8
##     year sa3_name   state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2011 Darwin Ci… NT    Admin      Women           46533    1846     40.6
##  2  2012 Darwin Ci… NT    Admin      Women           49584    1922     40.6
##  3  2013 Darwin Ci… NT    Admin      Women           51334    1892     40.6
##  4  2014 Darwin Ci… NT    Admin      Women           53309    1870     40.6
##  5  2015 Darwin Ci… NT    Admin      Women           56489    1745     40.6
##  6  2016 Darwin Ci… NT    Admin      Women           60115    1765     40.6
##  7  2011 Darwin Ci… NT    Admin      Men             62476     599     40.6
##  8  2012 Darwin Ci… NT    Admin      Men             66488     603     40.6
##  9  2013 Darwin Ci… NT    Admin      Men             77042     601     40.6
## 10  2014 Darwin Ci… NT    Admin      Men             86273     583     40.6
## # … with 1,393 more rows
```

Or you might just want to look at high-income (`average_income > 100,000`) areas from Victoria in 2015:


```r
sa3_income %>% 
  filter(state == "Vic",
         average_income > 100000,
         year == 2015)
```

```
## # A tibble: 43 x 8
##     year sa3_name   state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2015 Darebin -… Vic   Manager    Men            108957    2028     14.0
##  2  2015 Essendon   Vic   Manager    Men            118590    3060     18.2
##  3  2015 Essendon   Vic   Manager    Men            103482    5154     18.2
##  4  2015 Essendon   Vic   Professio… Men            104808    4517     18.2
##  5  2015 Melbourne… Vic   Manager    Men            127012    4878     31.5
##  6  2015 Melbourne… Vic   Manager    Men            107598    8353     31.5
##  7  2015 Port Phil… Vic   Manager    Men            132143    6103     25.7
##  8  2015 Port Phil… Vic   Manager    Men            115392   11055     25.7
##  9  2015 Port Phil… Vic   Professio… Men            103645    8984     25.7
## 10  2015 Stonningt… Vic   Manager    Men            170056    3765     11.9
## # … with 33 more rows
```


Each of the commas in the `filter` function represent an 'and' `&`. So you can read the steps above as: 

> take the `sa3_income` data and filter to keep only the observations that are from Victoria`,` and that have a average income above 100k`,` and are from the year 2015.


Sometimes you might want to relax a little, keeping observations from one category **or** another. You can do this with the **or** symbol: `|`^[On the keyboard: `shift` + `backslash`]


```r
sa3_income %>% 
  filter(state == "Vic" | state == "Tas",
         average_income > 100000,
         year == 2015 | year == 2016)
```

```
## # A tibble: 98 x 8
##     year sa3_name   state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2015 Darebin -… Vic   Manager    Men            108957    2028     14.0
##  2  2016 Darebin -… Vic   Manager    Men            113062    2104     14.0
##  3  2015 Essendon   Vic   Manager    Men            118590    3060     18.2
##  4  2016 Essendon   Vic   Manager    Men            122965    3154     18.2
##  5  2015 Essendon   Vic   Manager    Men            103482    5154     18.2
##  6  2016 Essendon   Vic   Manager    Men            107895    5345     18.2
##  7  2015 Essendon   Vic   Professio… Men            104808    4517     18.2
##  8  2016 Essendon   Vic   Professio… Men            104054    4723     18.2
##  9  2015 Melbourne… Vic   Manager    Men            127012    4878     31.5
## 10  2016 Melbourne… Vic   Manager    Men            124118    4933     31.5
## # … with 88 more rows
```

Which reads:

> take the `sa3_income` data and filter to keep only the observations that are from Victoria OR NSW, and that have a average income above 100k, and are from the year 2015 OR 2016.


### Grouped filtering with `group_by()` 

The `group_by` function groups a dataset by given variables. This effectively generates one dataset per group within your main dataset. Any function you then apply -- like `filter()` -- will be applied to _each_ of the grouped datasets. 

For example, you could filter the `sa3_income` dataset to keep just the observation with the highest average income:


```r
sa3_income %>% 
  filter(average_income == max(average_income))
```

```
## # A tibble: 1 x 8
##    year sa3_name    state occupation gender average_income workers sa3_sqkm
##   <dbl> <chr>       <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
## 1  2016 North Sydn… NSW   Manager    Men            250629    6869     19.0
```

To keep the observations that have the highest average incomes _in each state_, you can `group_by` state, then `filter`:^[Wow they are all men!]


```r
sa3_income %>% 
  group_by(state) %>% 
  filter(average_income == max(average_income))
```

```
## # A tibble: 8 x 8
## # Groups:   state [8]
##    year sa3_name    state occupation gender average_income workers sa3_sqkm
##   <dbl> <chr>       <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
## 1  2016 North Sydn… NSW   Manager    Men            250629    6869     19.0
## 2  2016 Bayside     Vic   Manager    Men            193455    6605     37.2
## 3  2016 Brisbane I… Qld   Manager    Men            162648    2354     15.6
## 4  2016 Burnside    SA    Manager    Men            128236    1994     27.5
## 5  2015 Cottesloe … WA    Manager    Men            240260    3458     48.7
## 6  2015 Hobart Inn… Tas   Manager    Men             99148    1741     62.2
## 7  2016 Darwin City NT    Manager    Men            137086    1720     40.6
## 8  2016 South Canb… ACT   Manager    Men            152109    2019     44.4
```

From the description of the tibble above, you can learn that your data has 8 unique groups of state: 

`## #Groups:       state [8]`

Or you could keep the observations with the _lowest_ average incomes in _each state and year_:^[Wow they are all women!]


```r
sa3_income %>% 
  group_by(state, year) %>% 
  filter(average_income == min(average_income))
```

```
## # A tibble: 48 x 8
## # Groups:   state, year [48]
##     year sa3_name   state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2014 Sydney In… NSW   Labourer   Women           19397    3021     25.1
##  2  2015 Sydney In… NSW   Labourer   Women           19784    3399     25.1
##  3  2011 Manly      NSW   Labourer   Women           17094     289     14.3
##  4  2012 Manly      NSW   Labourer   Women           15510     346     14.3
##  5  2013 Manly      NSW   Labourer   Women           16449     359     14.3
##  6  2016 Manly      NSW   Labourer   Women           18919     223     14.3
##  7  2011 Melbourne… Vic   Labourer   Women           17783     857     31.5
##  8  2012 Melbourne… Vic   Labourer   Women           16311    1006     31.5
##  9  2013 Melbourne… Vic   Labourer   Women           16034    1262     31.5
## 10  2014 Melbourne… Vic   Labourer   Women           16571    1311     31.5
## # … with 38 more rows
```

The dataset remains grouped after your function(s). To explicitly 'ungroup' your data, add the `ungroup` function to your chain (note that the 'Groups' note has disappeared):


```r
sa3_income %>% 
  group_by(state, year) %>% 
  filter(average_income == min(average_income)) %>% 
  ungroup()
```

```
## # A tibble: 48 x 8
##     year sa3_name   state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2014 Sydney In… NSW   Labourer   Women           19397    3021     25.1
##  2  2015 Sydney In… NSW   Labourer   Women           19784    3399     25.1
##  3  2011 Manly      NSW   Labourer   Women           17094     289     14.3
##  4  2012 Manly      NSW   Labourer   Women           15510     346     14.3
##  5  2013 Manly      NSW   Labourer   Women           16449     359     14.3
##  6  2016 Manly      NSW   Labourer   Women           18919     223     14.3
##  7  2011 Melbourne… Vic   Labourer   Women           17783     857     31.5
##  8  2012 Melbourne… Vic   Labourer   Women           16311    1006     31.5
##  9  2013 Melbourne… Vic   Labourer   Women           16034    1262     31.5
## 10  2014 Melbourne… Vic   Labourer   Women           16571    1311     31.5
## # … with 38 more rows
```





## Edit and add new variables with `mutate()`

To add new variables to your dataset, use the `mutate` function. Like all `dplyr` verbs, the first argument to `mutate` is your data. Then define variables using a `new_variable_name = x` format, where `x` can be a single number or character string, or simple operation or function using current variables. 

To add a new variable to the `sa3_income` dataset that shows the number of workers (by gender and occupation) per square kilometer area of the region:


```r
sa3_income %>% 
  mutate(worker_density = workers / sa3_sqkm)
```

```
## # A tibble: 47,899 x 9
##     year sa3_name state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>    <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2011 Queanbe… NSW   Admin      Women           51306    4597    6511.
##  2  2012 Queanbe… NSW   Admin      Women           53807    4708    6511.
##  3  2013 Queanbe… NSW   Admin      Women           56405    4732    6511.
##  4  2014 Queanbe… NSW   Admin      Women           57742    4573    6511.
##  5  2015 Queanbe… NSW   Admin      Women           58286    4087    6511.
##  6  2016 Queanbe… NSW   Admin      Women           61591    4448    6511.
##  7  2011 Queanbe… NSW   Admin      Men             66869    1459    6511.
##  8  2012 Queanbe… NSW   Admin      Men             69721    1467    6511.
##  9  2013 Queanbe… NSW   Admin      Men             71859    1460    6511.
## 10  2014 Queanbe… NSW   Admin      Men             74871    1394    6511.
## # … with 47,889 more rows, and 1 more variable: worker_density <dbl>
```


### Cases when you should use `case_when()`



### Grouped mutates with `group_by()` 



## Summarise data with `summarise()`

Summarising data is our ultimate goal. We'll want to clean data using the steps above -- but often so we can 'summairse' the data 

### Grouped summaries with `group_by()` 


## Arrange with `arrange()`


Sorting data in one way or another is useful because XXXX.


```r
sa3_income %>%
  filter(year == 2016) %>% 
  arrange(sa3_sqkm)
```

```
## # A tibble: 7,995 x 8
##     year sa3_name   state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2016 Leichhardt NSW   Admin      Women           65700    2711     10.7
##  2  2016 Leichhardt NSW   Admin      Men            110770    1102     10.7
##  3  2016 Leichhardt NSW   Admin      Men             78651    3811     10.7
##  4  2016 Leichhardt NSW   Service    Women           37144    1253     10.7
##  5  2016 Leichhardt NSW   Service    Men             48746     849     10.7
##  6  2016 Leichhardt NSW   Service    Men             41858    2102     10.7
##  7  2016 Leichhardt NSW   Labourer   Women           28531     209     10.7
##  8  2016 Leichhardt NSW   Labourer   Men             46097     668     10.7
##  9  2016 Leichhardt NSW   Labourer   Men             41910     879     10.7
## 10  2016 Leichhardt NSW   Driver     Women           37262      31     10.7
## # … with 7,985 more rows
```

Or:


```r
sa3_income %>%
  filter(year == 2016) %>% 
  arrange(-sa3_sqkm)
```

```
## # A tibble: 7,995 x 8
##     year sa3_name   state occupation gender average_income workers sa3_sqkm
##    <dbl> <chr>      <chr> <chr>      <chr>           <dbl>   <dbl>    <dbl>
##  1  2016 Goldfields WA    Admin      Women           49563    1830  714513.
##  2  2016 Goldfields WA    Admin      Men             79834     248  714513.
##  3  2016 Goldfields WA    Admin      Men             53197    2080  714513.
##  4  2016 Goldfields WA    Service    Women           39578    1337  714513.
##  5  2016 Goldfields WA    Service    Men             76979     468  714513.
##  6  2016 Goldfields WA    Service    Men             49249    1800  714513.
##  7  2016 Goldfields WA    Labourer   Women           33953     886  714513.
##  8  2016 Goldfields WA    Labourer   Men             64614    1494  714513.
##  9  2016 Goldfields WA    Labourer   Men             53193    2381  714513.
## 10  2016 Goldfields WA    Driver     Women           75251     431  714513.
## # … with 7,985 more rows
```






## Joining datasets with `*_join()` 

