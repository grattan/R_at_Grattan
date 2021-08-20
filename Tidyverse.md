# Packages commonly used at Grattan

R can do a lot out of the box, but a range of [packages](#packages) make our lives easier.

Some packages - like the `tidyverse` collection of packages - are broadly popular among R users. Some - like the `grattantheme` package - are specific to Grattan Institute. Others - like the `readabs` package - are made by Grattan people, useful at Grattan, but also used outside of the Institute.

## The tidyverse! {#tidyverse}

The `tidyverse` is central to our work at Grattan. The `tidyverse` is a [collection of related R packages](https://www.tidyverse.org/packages/) for importing, wrangling, exploring and visualising data in R. The packages are designed to work well together. You install the `tidyverse` in the [usual way](#install-packages):


```r
install.packages("tidyverse")
```

The main packages in the `tidyverse` include:

* *ggplot2* for making beautiful, customisable graphs
* *dplyr* for manipulating data frames
* *tidyr* for tidying your data
* *readr* for importing data from a broad range of formats
* *purrr* for functional programming
* *stringr* for manipulating strings of text

All these packages (and more!) will automatically be loaded for you when you run the command^[There's no need to install or load the individual `tidyverse` packages - like `dplyr` - separately. Just install them all together, and load them with the single `library(tidyverse)` command. That way, you don't need to remember which functions come from `tidyr` and which from `dplyr` - they're all just `tidyverse` functions.]:


```r
library(tidyverse)
```

```
## ── Attaching packages ────────────────────────────────────────────────── tidyverse 1.2.1.9000 ──
```

```
## ✔ ggplot2 3.2.1.9000     ✔ purrr   0.3.2     
## ✔ tibble  2.1.3          ✔ dplyr   0.8.3     
## ✔ tidyr   1.0.0          ✔ stringr 1.4.0     
## ✔ readr   1.3.1          ✔ forcats 0.4.0
```

```
## ── Conflicts ────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

A range of other packages are installed on your machine as part of the `tidyverse.` These include:

* *readxl* for importing Excel spreadsheets into R
* *haven* for importing Stata, SAS and SPSS data
* *lubridate* for working with dates
* *rvest* for scraping websites

Although these packages are installed as part of the `tidyverse`, they aren't loaded automatically when you run `library(tidyverse)`. You'll need to load them individually, like:


```r
library(lubridate)
library(readxl)
```

### Why do we use the tidyverse?

The `tidyverse` makes life easier! 

The core `tidyverse` packages, like `ggplot2`, `dplyr`, and `tidyr`, are extremely popular. The `tidyverse` is probably the most popular 'dialect' of R. This means that any problem you encounter with the `tidyverse` will have been encountered many times before by other R users, so a solution will only be a Google search away.

The `tidyverse` packages are all designed to work well together, with a consistent underlying philosophy and design. This means that coding habits you learn with one `tidyverse` package, like `dplyr`, are also applicable to other packages, like `tidyr`. 

They're designed to work with data frames^[The tidyverse works with 'tibbles', which are a tidyverse-specific variant of the data frame. Don't worry about the difference between tibbles and data frames.], a rectangular data object that will be familiar to spreadsheet users that is very intuitive and convenient for the sort of work we do at Grattan. In particular, the `tidyverse` is built around the concept of [*tidy data*](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html), which has a specific meaning in this context that we'll come to later. The fact that `tidyverse` packages are all built around one type of data object makes them easier to work with.

The creator of the `tidyverse`, Hadley Wickham, places great value on code that is expressive and comprehensible to humans. This means that code written in the `tidyverse` idiom is often able to be understood even if you haven't encountered the functions before. For example, look at this chunk of code:


```r
my_data %>%
  filter(age >= 30) %>%
  mutate(relative_income = income / mean(income))
```

Without knowing what `my_data` looks like, and even if you haven't encountered these functions before, this should be reasonably intuitive. We're taking some data, and then^[you can read the pipe, `%>%`, as 'and then'] only keeping observations that relate to people aged 30 and older, then calculating a new variable, `relative_income`. The name of a `tidyverse` function - like `filter`, `group_by`, `summarise`, and so on - generally gives you a pretty good idea what the function is going to do with your data, which isn't always the case with other approaches.

Here's one way to do the same thing in base R: 


```r
transform(my_data[my_data$age >= 30, ],
          relative_income = income / mean(income))
```

The base R code gets the job done, but it's clunkier, less expressive, and harder to read. 

Code written with `tidyverse` functions is often faster than its base R equivalents. But most of our work at Grattan is with small-to-medium sized datasets (with fewer than a million rows or so), so speed isn't usually a major concern.^[When working with larger datasets, you can gain speed using other packages, such as [`data.table`](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html). Fortunately, using the `dtplyr` package you can get most of the speed benefits of `data.table` and stick to familiar `dplyr` syntax.]

The most valuable resource we deal with at Grattan is our time. Computers are cheap, people are not. If your code executes quickly, but it takes your colleague many hours to decipher it, the cost of the extra QC time more than outweighs the saving through faster computation. The `tidyverse` packages strike a good balance between expressive, comprehensible code and computational efficiency.

Most R scripts at Grattan should start with `library(tidyverse)`. Most of your work will be in data frames, and most of the time the `tidyverse` contains the core tools you'll need to do that work.

## Grattan-specific packages

A range of Grattan people have written packages that come in handy at Grattan.

## Other commonly-used packages

# Writing reproducible documents with RMarkdown
