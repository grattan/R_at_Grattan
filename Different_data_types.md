# Different data types {#data-types}

Data comes in many different forms. This chapter explores some of these forms and provides some tools to deal with them. 

It's useful to make a distinction between data **structures** and data **types**. This is a simplification but is all we need to think about for now.

**Data structures** are the objects that hold your data. A `vector` stores elements in one dimension. A `data.frame` (or `tibble`^[A `tibble` is the `tidyverse` version of a standard R `data.frame`. They are basically the same; a `tibble` just has some more sensible default behaviours. If you want to learn more about this, see [Section 3.6 in Advanced R](https://adv-r.hadley.nz/vectors-chap.html#tibble). ]) combines vectors of the same length into two dimensions with rows and columns. A `list` can store data in any way you like. 

For our work at Grattan, tidy data within `tibbles` -- where each row is an observation, and each column is a variable -- is usually preferred. 

By picking a common structure for our data, we are able to transform, plot and analyse it using a common set of functions. We don't need to move from one method to another depending our what our data looks like. 

Each `tibble` is a collection of `vectors` of the same length. And each `vector` must have a single data **type**. 

The key data types we use are: 

- Numerics (numbers) with the sub-types of doubles and integers.
- Characters, also known as strings, to deal with text variables.
- Factors, a stricter type for characters to use with categorical variables.
- Dates, which are notoriously hard to deal with in statistical software. 

The following sections will walk you through these data types and how to best handle them. We'll first load the required packages and read in some data.

## Set-up and packages

This chapter uses packages that are designed to help with different data types. 

The `stringr` package helps deal with characters. The `forcats` package helps with factors. The `lubridate` package helps -- a lot! -- with dates. 

These three packages are _installed_ part of the `tidyverse` and are installed with it. `stringr` and `forcats` are _loaded_ with `library(tidyverse)`, but `lubridate` isn't and needs to be loaded separately.




```r
library(tidyverse)
library(lubridate)
```


For most charts in this chapter, we'll use the `sa3_income` data summarised below.^[From [ABS Employee income by occupation and gender, 2010-11 to 2015-16](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/6524.0.55.0022011-2016?OpenDocument)] It is a tidy dataset containing the median income and number of workers by SA3, occupation and gender between 2010 and 2015:


```r
sa3_income <- read_csv("data/sa3_income.csv")

glimpse(sa3_income)
```

```
## Rows: 47,899
## Columns: 16
## $ sa3                   <dbl> 10102, 10102, 10102, 10102, 10102, 10102, 10102,…
## $ sa3_name              <chr> "Queanbeyan", "Queanbeyan", "Queanbeyan", "Quean…
## $ sa3_sqkm              <dbl> 6511.191, 6511.191, 6511.191, 6511.191, 6511.191…
## $ sa3_income_percentile <dbl> 80, 76, 78, 76, 74, 79, 80, 76, 78, 76, 74, 79, …
## $ sa4_name              <chr> "Capital Region", "Capital Region", "Capital Reg…
## $ gcc_name              <chr> "Rest of NSW", "Rest of NSW", "Rest of NSW", "Re…
## $ state                 <chr> "NSW", "NSW", "NSW", "NSW", "NSW", "NSW", "NSW",…
## $ occupation            <chr> "Clerical and Administrative Workers", "Clerical…
## $ occ_short             <chr> "Admin", "Admin", "Admin", "Admin", "Admin", "Ad…
## $ prof                  <chr> "Non-professional", "Non-professional", "Non-pro…
## $ gender                <chr> "Women", "Women", "Women", "Women", "Women", "Wo…
## $ year                  <dbl> 2011, 2012, 2013, 2014, 2015, 2016, 2011, 2012, …
## $ median_income         <dbl> 52127, 54894, 57868, 59025, 59041, 62741, 66900,…
## $ average_income        <dbl> 51306, 53807, 56405, 57742, 58286, 61591, 66869,…
## $ total_income          <dbl> 235853682, 253323356, 266908460, 264054166, 2382…
## $ workers               <dbl> 4597, 4708, 4732, 4573, 4087, 4448, 1459, 1467, …
```


## Why data types matter

Data 'types' define how your data is stored and what you can (or cannot) do with it. 

You can do maths on numbers:


```r
num1 <- 10
num2 <- 5

num1 + num2
```

```
## [1] 15
```

```r
num1 / num2
```

```
## [1] 2
```

And you can perform string operations on characters:


```r
char1 <- "Hello"

substring(char1, 4, 6)
```

```
## [1] "lo"
```

But you can't perform maths on characters, because that doesn't really make sense:


```r
"Hello" * 2 
```

```
## Error in "Hello" * 2: non-numeric argument to binary operator
```

Even when you kind of think it should:


```r
"100" * 2
```

```
## Error in "100" * 2: non-numeric argument to binary operator
```

Above, R is trying to multiply the _character_ `"100"` by the _number_ `2`. Which -- because of the types of these data -- makes as much sense as `"Hello"` $\times$ `2`. 

Defining and checking and being aware of the 'type' of your data is a boring and tedious task common to all statistical languages/software.
It's just something you need to do.

But knowing this information will save you countless errors, like the ones above, in the future. 
We'll get through it briefly, focussing on the things you need to know and on how to solve the problems you are likely to encounter.



## Checking and changing data types

You can use the `str` function to check the type of an object:


```r
ob1 <- "Hello"
str(ob1)
```

```
##  chr "Hello"
```

```r
ob2 <- 10
str(ob2)
```

```
##  num 10
```

```r
ob3 <- "10"
str(ob3)
```

```
##  chr "10"
```


You can also change or assert the data type explicitly:


```r
ob4 <- as.numeric("10")
str(ob4)
```

```
##  num 10
```

```r
ob5 <- as.character(10)
str(ob5)
```

```
##  chr "10"
```

But be cautious: forcing data from one type to another can lead to `NA` values when the conversion isn't possible. For example:


```r
ob6 <- "Hello"
as.numeric(ob6)
```

```
## Warning: NAs introduced by coercion
```

```
## [1] NA
```

The characters "Hello" can't be converted to a number, so R replaces it with `NA` and throws you a warning message.

The next section extends these concepts from single elements to whole variables in your data.



## Checking and changing data types in vectors and `tibbles`

In a `tibble`, each variable is a vector that can have _one-and-only-one_ data type. 

A variable can be a numeric, or character, or factor, or date, or something else entirely. 
But it can only be of one type.^[There are ways around this using 'list' variables, but this is rarely useful or necessary.]
This means that every observation in a variable must be of the same type.

Below is an example `tibble` to explore how we can check, change and use different data types.
This `tibble` is constructed by defining four vectors:


```r
eg <- tibble(
  name = c("Kate", "Jonathan", "Emily", "James"),
  numb1 = c(1, 2, 3, 4),
  numb2 = c("-10", "10", "-20", "20"),
  numb3 = c(100, 1000, 10000, "None"),
  messy = c("1", "  1  ", "0. 1", "1%")
)

eg
```

```
## # A tibble: 4 × 5
##   name     numb1 numb2 numb3 messy  
##   <chr>    <dbl> <chr> <chr> <chr>  
## 1 Kate         1 -10   100   "1"    
## 2 Jonathan     2 10    1000  "  1  "
## 3 Emily        3 -20   10000 "0. 1" 
## 4 James        4 20    None  "1%"
```

The first two variables are easy. 
`name` contains only strings and so is set to a character variable. 
`numb1` contains numbers is set to a double. 

The `numb2` and `messy` variables are also all strings, so R will store them as character variables (even if a human _may_ be able to decipher some of the strings as numbers),

`numb3` contains **both** numbers and strings. When this is the case, R converts everything to a character to preserve all the information. 


We can check the types of the variables in the `eg` dataset with the `str` function:


```r
str(eg)
```

```
## tibble [4 × 5] (S3: tbl_df/tbl/data.frame)
##  $ name : chr [1:4] "Kate" "Jonathan" "Emily" "James"
##  $ numb1: num [1:4] 1 2 3 4
##  $ numb2: chr [1:4] "-10" "10" "-20" "20"
##  $ numb3: chr [1:4] "100" "1000" "10000" "None"
##  $ messy: chr [1:4] "1" "  1  " "0. 1" "1%"
```

This tells us that our data **structure** is `tbl_df`, `tbl` and `data.frame` (i.e. a `tibble`), and the data **types** of our variables are: character, numeric, character, character and character.

The first two variables are classified as we want them. `names` should be stored as characters; `numb1` should be stored as doubles. 

But we can see that `numb2` is a set of numbers that have been stored as characters. And this means we can't use their wonderful numeric powers:


```r
eg %>% 
  mutate(numb2_div10 = numb2 / 10)
```

```
## Error: Problem with `mutate()` column `numb2_div10`.
## ℹ `numb2_div10 = numb2/10`.
## ✖ non-numeric argument to binary operator
```

If we want to change that, we redefine the `numb2` variable using the `mutate` function (from the previous chapter) and the `as.numeric` function described in the previous section:


```r
eg %>% 
  mutate(numb2 = as.numeric(numb2))
```

```
## # A tibble: 4 × 5
##   name     numb1 numb2 numb3 messy  
##   <chr>    <dbl> <dbl> <chr> <chr>  
## 1 Kate         1   -10 100   "1"    
## 2 Jonathan     2    10 1000  "  1  "
## 3 Emily        3   -20 10000 "0. 1" 
## 4 James        4    20 None  "1%"
```

The `tibble` output shows that `numb2` is now a double. Yay! And this means we can do maths on it:


```r
eg %>% 
  mutate(numb2 = as.numeric(numb2),
         numb2_div10 = numb2 / 10)
```

```
## # A tibble: 4 × 6
##   name     numb1 numb2 numb3 messy   numb2_div10
##   <chr>    <dbl> <dbl> <chr> <chr>         <dbl>
## 1 Kate         1   -10 100   "1"              -1
## 2 Jonathan     2    10 1000  "  1  "           1
## 3 Emily        3   -20 10000 "0. 1"           -2
## 4 James        4    20 None  "1%"              2
```


What about `numb3`? It has a numbers and a string that are stored as a character variable. If we use the same approach as above:


```r
eg %>% 
  mutate(numb3 = as.numeric(numb3))
```

```
## Warning in mask$eval_all_mutate(quo): NAs introduced by coercion
```

```
## # A tibble: 4 × 5
##   name     numb1 numb2 numb3 messy  
##   <chr>    <dbl> <chr> <dbl> <chr>  
## 1 Kate         1 -10     100 "1"    
## 2 Jonathan     2 10     1000 "  1  "
## 3 Emily        3 -20   10000 "0. 1" 
## 4 James        4 20       NA "1%"
```

We do convert the `numb3` variable to a numeric, which is what we wanted. But there are casualties. Because `"None"` cannot be neatly converted to a number, the string in the last observation is removed and replaced with `NA` (and we get a warning that there were `NAs introduced by coercion`). 

Converting strings to numerics made harder by data that is stored messily. The `messy` variable is made up of numbers that humans could decipher. The `as.numeric` function tries its best:


```r
eg %>% 
  mutate(messy = as.numeric(messy))
```

```
## Warning in mask$eval_all_mutate(quo): NAs introduced by coercion
```

```
## # A tibble: 4 × 5
##   name     numb1 numb2 numb3 messy
##   <chr>    <dbl> <chr> <chr> <dbl>
## 1 Kate         1 -10   100       1
## 2 Jonathan     2 10    1000      1
## 3 Emily        3 -20   10000    NA
## 4 James        4 20    None     NA
```

We again convert the variable to a numeric. The `as.numeric` function nails `"1"` and removes the leading and trailing white-spaces of `"  1  "`. But it doesn't understand the space in the middle of `"0. 1"`, and doesn't convert the percentage in `"1%"`. Luckily, we have the `warning` message that tells us this has happened.

Complications like these mean we have to watch out for how our data is read.


## Asserting data types when importing data





## Changing the data types of lots of variables




## Using character vectors

Characters contain information between quotes, like a letter or word or sentence. They can contain (almost) anything. They have no 'rules', unlike numerics, factors or dates. This freedom can be good or bad depending on your situation: sometimes restrictions are good!



```r
"hello"
```

```
## [1] "hello"
```








<img src="atlas/rstudio_newproject.png" width="66%" style="display: block; margin: auto;" />



```r
c("hello", 1) %>% typeof()
```

```
## [1] "character"
```

```r
c("hello", 1) %>% class()
```

```
## [1] "character"
```

```r
c("hello", 1) %>% str()
```

```
##  chr [1:2] "hello" "1"
```




## Using dates with `lubridate::`

Dates are hard, and dealing with dates in statistical software like R, Excel 

The `lubridate::` package

## Strings with `stringr::`

* Replacing values
* Matching values
* Separating columns

## Factors with `forcats::`

* Dangers with factors


