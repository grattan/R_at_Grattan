# (PART) Advanced topics {-}

# Functional programming: making and using your own functions

Why on earth would you create your own function?

It can be useful to make your own function

## Set up

We will use the `tidyverse` and `purrr` in this chapter.


```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✔ ggplot2 3.3.5     ✔ purrr   0.3.4
## ✔ tibble  3.1.3     ✔ dplyr   1.0.7
## ✔ tidyr   1.1.3     ✔ stringr 1.4.0
## ✔ readr   2.0.0     ✔ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

```r
library(purrr)
```




## Defining simple functions

Like your data, a function is an `object` that is defined. 

Let's say you wanted to take whatever value you had and add one to it. 
We could define a function called `add_one` to do this:


```r
add_one <- function(x) {
  x + 1
}
```

There are four elements to what we just did:

1. Created a new function using the `function()` function.
1. Defined one argument (input) to the new function: `x`
1. Gave the function instructions to 'take `x` and add one':  `x + 1`. 
1. Assigned this function to the object `add_one`.

Now that you've done all that, you can call the function like you would any other:


```r
add_one(1)
```

```
## [1] 2
```

```r
add_one(2)
```

```
## [1] 3
```

```r
add_one(100)
```

```
## [1] 101
```

You can define functions can take more than one argument: 


```r
add_together_plus_one <- function(x, y, z) {
  x + y + z + 1
}

add_together_plus_one(1, 2, 3)
```

```
## [1] 7
```

As the above takes three arguments, and there are no defaults provided,
we'll get an error if we fotget one:


```r
add_together_plus_one(1, 2)
```

```
## Error in add_together_plus_one(1, 2): argument "z" is missing, with no default
```

So you can also provide _default_ values to your function when you define it:


```r
make_power <- function(x, n = 2) {
 x^n 
}
```

If you don't provide a value for `n` when you call the `make_power` function,
it will default to `2`:


```r
make_power(10)
```

```
## [1] 100
```

And you can override that by providing your own value:


```r
make_power(10, 4)
```

```
## [1] 10000
```

We can also assign the result of this function (`10000` above) to 
an object of its own:


```r
my_power_number <- make_power(10, 4)
```

For this reason, and a few others described in a [section to follow](#functions-returned), a function
can only return one _thing_ (a number, or a vector, or dataset, or list, and so on).


## Using conditional statements and categorical arguments {#functions-conditionals}

Sometimes you will want your function to behave differently under different 
circumstances. For example, you might want to do one thing if your input is a 
<b style='font-size:bigger'>REALLY BIG</b> number, and another if it's <span style='font-size:smaller'>very small</span>.

Conditional `if` statements -- which evaluate an expression and proceed _if_ `TRUE` -- can be useful for these occasions. 
The function below takes one argument -- `x` -- and transforms it depending on how large it is:


```r
make_smaller <- function(x) {
  if (x > 10) {
    return_number <- x - 10
  }
  if (x <= 10) {
    return_number <- x - 5
  }
  return_number
}
```

If the input number is greater than 10, the `make_smaller` function will take
`10` off it; if it's 10 or less, it will just take `5` off:


```r
make_smaller(7)
```

```
## [1] 2
```

```r
make_smaller(13)
```

```
## [1] 3
```

Making use of the `return()` function could make this clearer.
If `x` is greater than `10`, the `make_smaller` function will now subtract `10`
and immediately return the value, ignoring everything else below it:


```r
make_smaller <- function(x) {
  if (x > 10) {
    return(x - 10)
  }
  if (x <= 10) {
    return(x - 5)
  }
}

make_smaller(7)
```

```
## [1] 2
```

```r
make_smaller(13)
```

```
## [1] 3
```

These conditional statements can be used for input options to your functions. 
Let's say you had a vector of ages of people in your office, `office_ages`:


```r
office_ages <- c(-6, 12, 21, 36, 56, 67, 200)
office_ages
```

```
## [1]  -6  12  21  36  56  67 200
```

To summarise your office by age, you might want a function that would round each age to the nearest `10`. You could make a function that rounds a number to the nearest `10`, 
using the `round()` function with `digits` set to `-1` (i.e. round to the nearest `10`):


```r
make_age10 <- function(age) {
  round(age, digits = -1)
}

make_age10(office_ages)
```

```
## [1] -10  10  20  40  60  70 200
```

Perfect. But some of those ages look implausible, and you might also want your function to validate them, by, say, capping ages to be between zero and `100`. You could let `validate_ages` be an argument, defaulting to `TRUE`, and _if it is `TRUE`_, then you could perform the validation:


```r
make_age10 <- function(age,
                       validate_ages = TRUE) {
  
  # First, validate ages IF ASKED FOR
  if (validate_ages) {
    age <- if_else(age > 100, 100, age)
    age <- if_else(age < 0, 0, age)
  }
  
  # Then round ages to the nearest 10:
  round(age, digits = -1)
}
```

Now, if `validate_ages == TRUE` (the default), the numbers over `100` will be replaced with `100`, and those less than `0` with `0`:


```r
make_age10(office_ages)
```

```
## [1]   0  10  20  40  60  70 100
```

And you can turn that behaviour off by setting `validate_ages` to `FALSE`:


```r
make_age10(office_ages, validate_ages = FALSE)
```

```
## [1] -10  10  20  40  60  70 200
```

However, we might not trust an age entry of `-6` or `200` at all, and might want to give the user the option to remove them rather than assume they are `0` or `100`. We could provide that option in one of two ways. 

The first is to add another argument, shown below.


```r
make_age10 <- function(age,
                       validate_ages = TRUE,
                       remove_implausible = FALSE) {
  
  # First, validate ages
  if (validate_ages) {
    if (remove_implausible) {
      # Replace implausible ages with NAs
      age <- if_else(age > 100 | age < 0, NA_real_, age)
    }
    if (!remove_implausible) {
      # Replace implausible ages with their nearest plausible age
      age <- if_else(age > 100, 100, age)
      age <- if_else(age < 0, 0, age)
    }
  }
  
  # Then round ages to the nearest 10:
  round(age, digits = -1)
}
```


This is fine! By default, the function still works like it did previously:


```r
make_age10(office_ages, validate_ages = TRUE)
```

```
## [1]   0  10  20  40  60  70 100
```


And if the user wants to validate ages **and** they want to remove the 
implausible ages, then they will be replaced with `NA`:^[Note that when _creating_ 
an `NA` value, like we've done above, we have to specify what _type_ of `NA` 
value it is: a number `NA_real_`, an integer `NA_integer`, or a character 
`NA_character_`.] 


```r
make_age10(office_ages, validate_ages = TRUE, remove_implausible = TRUE)
```

```
## [1] NA 10 20 40 60 70 NA
```


But those nested conditional statements -- which are often 
needed! -- can be a bit of a headache.
There is another way we can do this, which might be neater in this instance.
The `validate_ages` argument could take a character string that tells it which 
validation method to use. We could use `"remove"` and `"adjust"` to indicate the
validation methods:


```r
make_age10 <- function(age,
                       validate_ages = "remove") {
  
  # First, validate ages
  if (validate_ages == "remove") {
    age <- if_else(age > 100 | age < 0, NA_real_, age)
  }
  
  if (validate_ages == "adjust") {
    # Replace implausible ages with their nearest plausible age
    age <- if_else(age > 100, 100, age)
    age <- if_else(age < 0, 0, age)
  }
  
  # Then round ages to the nearest 10:
  round(age, digits = -1)
}
```

Now we can use the `validate_ages` argument by itself to get the results we want:


```r
make_age10(office_ages, validate_ages = "adjust")
```

```
## [1]   0  10  20  40  60  70 100
```

```r
make_age10(office_ages, validate_ages = "remove")
```

```
## [1] NA 10 20 40 60 70 NA
```



## What is 'returned' from a function? {#functions-returned}



A function can do lots of things in the background.
For example, you might want to take a vector, square every number,
and then add all those numbers up:


```r
sum_squares <- function(x) {
  # first, add one to each using the function we defined above
  added <- add_one(x)
  # then sum all the numbers in the vector
  summed <- sum(added)
  # then return the summed object
  summed
}
```

Running that function on a vector of numbers \(1, 2, 3, ..., 10\) (created with `1:10`) does what we want:


```r
sum_squares(1:10)
```

```
## [1] 65
```

But look in your **Environment** window. The two objects that were created in the
function -- `added` and `summed` -- aren't there! They are instead calculated,
stored in the background, and removed when the function is finished. 

A function only returns **one thing**; everything else that is created in it 
is discarded.^[Unless they are explicitly stored in your environment, but this is not recommended.] 
This behaviour keeps your environment clean and tidy, but it can cause some frustration when you're getting started. 

That **one thing** that is returned is -- by default -- the last thing printed in
the function.  _this is a bad explanation that I need to make better_
For `sum_squares` above, we defined two objects and then passed the `summed` to 
the end of the function. If we omitted the last step, the function wouldn't return _anything_:


```r
empty_sum_squares <- function(x) {
  # first, add one to each using the function we defined above
  added <- add_one(x)
  # then sum all the numbers in the vector
  summed <- sum(added)
}

empty_sum_squares(1:10)
```

The `empty_sum_squares` function took the `1:10` vector, then added one, then
summed the resulting numbers. But it didn't _return_ anything.
It just assigned values to the `added` and `summed` objects, then the function
finished and those objects vanished.

The `return()` function can help you make this behaviour clear. Using `return()`
will stop your function in its tracks and pass the object out of the function.
We can use it in the `sum_squares` function:


```r
sum_squares <- function(x) {
  # first, add one to each using the function we defined above
  added <- add_one(x)
  # then sum all the numbers in the vector
  summed <- sum(added)
  # then return the summed object
  return(summed) # function stops here!
}
```

Ensuring your function _returns_ the object you want in the form you want is the second step in writing your own functions.




## Using functions on datasets within `mutate()`

Recall that when you are adding (or changing) a variable in a dataset with `mutate`, the length of the output must be either the length of the dataset or one (which is then repeated). Anything else will throw an error:


```r
office_df <- tibble(office_ages)
office_df
```

```
## # A tibble: 7 × 1
##   office_ages
##         <dbl>
## 1          -6
## 2          12
## 3          21
## 4          36
## 5          56
## 6          67
## 7         200
```

```r
# A single element will be repeated:
office_df %>% 
  mutate(fave_colour = "#F68B33")
```

```
## # A tibble: 7 × 2
##   office_ages fave_colour
##         <dbl> <chr>      
## 1          -6 #F68B33    
## 2          12 #F68B33    
## 3          21 #F68B33    
## 4          36 #F68B33    
## 5          56 #F68B33    
## 6          67 #F68B33    
## 7         200 #F68B33
```

```r
# A vector of length of the dataset is fine:
office_df %>% 
  mutate(fave_number = c(10, 4, 1, 4, 0, 99, 100))
```

```
## # A tibble: 7 × 2
##   office_ages fave_number
##         <dbl>       <dbl>
## 1          -6          10
## 2          12           4
## 3          21           1
## 4          36           4
## 5          56           0
## 6          67          99
## 7         200         100
```

```r
# BUT a vector of a different length will cause an error:
office_df %>% 
  mutate(fave_lunch = c("pasta salad", "a variety"))
```

```
## Error: Problem with `mutate()` column `fave_lunch`.
## ℹ `fave_lunch = c("pasta salad", "a variety")`.
## ℹ `fave_lunch` must be size 7 or 1, not 2.
```

In [the section above](#functions-conditionals), we created the `make_age10` function and applied it to our little vector of ages. The function took a vector and returned a vector of the same length:


```r
office_ages %>% length()
```

```
## [1] 7
```

```r
make_age10(office_ages) %>% length()
```

```
## [1] 7
```




## Using the `purrr` family of functions


_Section to be finished_; see https://github.com/grattan/R_at_Grattan/issues/59


## Using functions for visualisations


## Sharing your useful functions with Grattan and the world


