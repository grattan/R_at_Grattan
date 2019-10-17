# (PART) Load, manipulate and visualise data {-}
# Reading data {#reading-data}

## Importing data

### Reading CSV files

#### `read_csv()`

The `read_csv()` function from the `tidyverse` is quicker and smarter than `read.csv` in base R. 

Pitfalls:
1. read_csv is quicker because it surveys a sample of the data

We can also compress `.csv` files into `.zip` files and read them _directly_ using `read_csv()`:


```r
read_csv("data/my_data.zip")
```

This is useful for two reasons: 

1. The data takes up less room on your computer; and
2. The original data, which shouldn't ever be directly edited, is protected and cannot be directly edited.

#### `data.table::fread()`

The `fread` function from `data.table` is quicker than both `read.csv` and `read_csv`. 



### `readxl::read_excel()`

### `rio` 

### `readabs`



## Reading common files:

- TableBuilder CSVSTRINGs
- HES household file
- SIH
- LSAY and derivatives

See data directory for a list of microdata available to Grattan.



## Appropriately renaming variables

As shown in the style guide

Add `rename_abs` function to a common Grattan package?


## Getting to tidy data

`pivot_long()` and `pivot_wide()`
_Make sure these are stable btw_


