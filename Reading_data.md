# (PART) Part II: Loading and transforming data {-}

# Reading data {#reading-data}

_Introduction_

## Set-up and packages

This section uses the package XX.



```r
library(tidyverse)
```


## Different data file types

There are lots of different ways to store data on a computer.
A common way, and a useful starting point, is a 'comma separated value', or CSV file.

CSVs are incredibly simple. They are a text file that contain characters separated by commas to indicate new columns, and new lines to indicate rows. A `.csv` file looks something like this:


```r
name, age
Will, 95
James, 16
Anika, -50
```

Simple! A bunch of programs are able to read -- or 'parse' -- a `.csv` file. They've very versatile and -- along with their cousin 'tab separated value', or `.tsv` files -- are used widely.

But there are limitation to `.csv` files. They're plain text, meaning they can't store 'metadata' -- additional information -- about the rows or columns. For example, if we wanted to store the data above but include the information that the `name` column is a character and the `age` column is a numeric, we would need a different data file type. 

An Excel file is the next most common type. An `.xlsx` file^[or `.xls` if the data is very old.] file contains more than just the data shown in the rows and columns. The same goes for Google Sheets files. They contain information about cell formats ('this cell is a DATE'; 'this cell is YELLOW'; 'this cell is merged with the one next to it because you like chaos') and formulas contained within them. This makes Excel/Sheets files very useful for use with Excel or Google Sheets, but not elsewhere.^[This is called 'data serialisation', a process described entertainingly in Danielle Navarro's blogpost about [data serialisation in R]( https://blog.djnavarro.net/posts/2021-11-15_serialisation-with-rds/).]

The same goes for data files created and exported from Stata (`.dta` files), SPSS (`.sav`), SAS (`.sas7bdat` et al).

And these are just _rectangular_ data files. Other, non-rectangular data types exist for other purposes too. For example, there is a whole world of mapping software and data file types that are designed specifically for that purpose. Files hosted and used on the internet are often stored in 'JSON' files.

Different file types will often require a specialised function to be read into R in a usable way. This chapter covers the key packages and functions we use to read data types often seen in the wild.


## Reading common data files

There are different ways to read the same data type into your R session.
We focus here on the 'best practice' methods that align with Grattan's style.


### Reading CSVs`.csv`

The `read_csv` function from the `dplyr` package is the weakly-preferred method for reading CSV files.
This function is well documented, provides clear messages and warnings, and is just a safe bet all-round.


```r
sa3_income <- read_csv("data/sa3_income.csv")
```

```
## Rows: 47899 Columns: 16
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (8): sa3_name, sa4_name, gcc_name, state, occupation, occ_short, prof, g...
## dbl (8): sa3, sa3_sqkm, sa3_income_percentile, year, median_income, average_...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

::: {.rmdwarning}
**Warning:** `read_csv` is quicker because uses the first 1,000 rows to determine the type of each column. But if some of your columns in a large dataset have empty rows -- e.g. if the particular variable was only collected for a small subsample of observations -- then this process can **incorrectly** allocate the column types, replacing data elements with `NA`. 
:::

An alternative is `fread` from the `data.table` package, which has the benefits of being faster and less prone to the error described above (because `fread` uses a [sample of 10,000 rows](https://www.rdocumentation.org/packages/data.table/versions/1.14.2/topics/fread) from '100 contiguous rows are read from 100 equally spaced points throughout the file including the beginning, middle and the very end.')

We can also compress `.csv` files into `.zip` files and read them _directly_ using both `read_csv()` and `fread()`:


```r
read_csv("data/my_data.zip")
```

This is useful for two reasons: 

1. The data takes up less room on your computer; and
2. The original data, which shouldn't ever be directly edited, is protected and cannot be directly edited.

### Reading Excel files with `readxl::read_excel()`

### Reading shapefiles with `sf::read_sf()`

### `grattandata::read_microdata()` {#read_microdata}


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


