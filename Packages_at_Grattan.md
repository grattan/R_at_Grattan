# Using packages {#packages}

## What are packages? 

R comes with a lot of functions - commands - built in to do a broad range of tasks. You could, if you really wanted, import a dataset, clean it up, estimate a model, and make a plot just using the functions that come with R - known as 'base R'^[Technically some of the 'built-in' functions are part of packages, like the `tools`, `utils` and `stats` packages that come with R. We'll refer to all these as base R.]. But using packages will make your life easier.

Like R itself, packages are free and open source. You can install them from within RStudio using the methods described below.

## How to install packages {#install-packages}

You'll typically install packages using the console in RStudio. That's the part of the window that, by default, sits in the bottom-left corner of the screen.

In our work at Grattan, we use packages from two different source: the Comprehensive R Archive Network (CRAN) and Github. The main difference you need to know about is that we use different commands to install packages from these two sources.

To install a package from CRAN, we use the command `install.packages()`.

For example, this code will install the `ggplot2` package from CRAN:


```r
install.packages("ggplot2")
```

The easiest way to install a package from Github is to use the function `install_github()`. Unfortunately, this function doesn't come with base R. The `install_github()` function is part of the `remotes` package. To use it, we first need to install `remotes` from CRAN:


```r
install.packages("remotes")
```

Now we can install packages from Github using the `install_github()` function from the `remotes` package. For example, here's how we would install the Grattan `ggplot2` theme, which we'll discuss later in this website:


```r
remotes::install_github("grattan/grattantheme", dependencies = TRUE, upgrade = "always")
```

## Get set up: install packages for Grattan {#install-grattan-packages}

Just starting out or setting up a new machine? Run this block of code to get yourself all set up:


```r
cran_packages <- c("devtools", "tidyverse", "readabs", "janitor", 
                   "rio", "sf")

install.packages(cran_packages)

github_packages <- c("grattan/grattantheme", "grattan/grattandata",
                     "runapp-aus/strayr",  "grattan/grattanReporter")

remotes::install_github(github_packages,
                        dependencies = TRUE,
                        upgrade = "always")
```

## Using packages

Before using a function that comes from a package, you need to tell R where to look for the function. There are two main ways to do that. 

We can either load (aka 'attach') the package by using the `library()` function. We typically do this at the top of a script.


```r
library(remotes)

# Now that the `remotes` package is loaded, we can use its `install_github()` function:

install_github("grattan/grattantheme")
```

Or, we can use two colons `::` to tell R to use an individual function from a package without loading it:


```r
remotes::install_github("grattan/grattantheme")
```

It usually makes sense to load a package with `library()`, unless you only need to use one of its function once or twice. There's no harm to using the `::` operator even if you have already loaded a package with `library()`. This can remove ambiguity both for R and for humans reading your code, particularly if you're using an obscure function - it makes it clearer where the function comes from.

## Package versions

### Updating packages

It's generally a good idea to keep your packages up-to-date. The easiest way to do this is to run this code:


```r
devtools::update_packages()
```

This will upgrade all your packages - including those you've installed from CRAN and Github. 

When you run the above command, it will prompt you to ask which packages you want to update - press 1 for 'All'. 

If it asks you 'Do you want to install from sources the package which needs compilation?' type 'no' and press enter.^[Nothing against installing from source, but this part of the guide is aimed at people who are not familiar with R and may not have the tools installed to build from source.]

### Downgrading packages 

Sometimes, when packages change, their functions evolve. The arguments to a function might change, or a function might be phased out ('deprecated') in favour of another. You can usually just adapt your workflow to the package's new version without much fuss. If you find this isn't the case, and you want to downgrade to an earlier version of a package, it's straightforward. Just use the `install_version()` function, like this:


```r
devtools::install_version("devtools", "1.13.3")
```

It's rare that you'd need to downgrade. Better to stay up to date, and adapt your code when necessary to changes in packages.


## Packages commonly used at Grattan

Some packages we use at Grattan - like the `tidyverse` collection of packages - are very popular among R users. Some - like the `grattantheme` package - are specific to Grattan Institute. Others - like the `readabs` package - are made by Grattan people, useful at Grattan, but also used outside of the Institute. To install a core set of packages we use at Grattan, [click here and run the code chunk](#install-grattan-packages).

### Using the `tidyverse`

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
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✔ ggplot2 3.3.5     ✔ purrr   0.3.4
## ✔ tibble  3.1.6     ✔ dplyr   1.0.8
## ✔ tidyr   1.2.0     ✔ stringr 1.4.0
## ✔ readr   2.1.2     ✔ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
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


### Grattan-specific packages {#grattan-specific-packages}

A range of Grattan people have written packages that come in handy at Grattan. 
* *grattantheme* The `grattantheme` package, by Matt Cowgill and Will Mackey, helps to make your ggplot2 charts Grattan-y. We cover the package extensively in the data visualisation chapter. Find it on [Github](https://github.com/grattan/grattantheme).

* *grattandata* The `grattandata` package, by Matt Cowgill and Jonathan Nolan, is used to load microdata from the Grattan microdata repository. We cover this in the [reading data](#reading-data) chapter. Find it on [Github](https://github.com/grattan/grattandata).

* *grattan* The `grattan` package, created by Hugh Parsonage, contains two broad sets of functions. One set of functions (sometimes known by the nickname "Grattax") is used for modelling the personal income tax system. Another set of functions ("Grattools") are useful for a lot of our work, like converting dates to financial years (`grattan::date2fy()`) or a version of `dplyr::ntile()` that uses weights (`grattan::weighted_ntile()`).  Find it on [Github](https://github.com/hughparsonage/grattan).

* *grattanReporter* The `grattanReporter` package, created by Hugh Parsonage (and currently maintained by Will Mackey), runs a series of checks on Grattan's LaTeX reports to ensure consistent style. Find it on [Github](https://github.com/grattan/grattanreporter).

### Other commonly-used, useful packages

There are other packages we commonly use at Grattan, including some developed by Grattan staff. These include:

* *strayr* This package, by Will Mackey and others, is very handy for working with Australian classifications (eg ANZSCO, ANZSIC, ASCED), and for using Australian spatial data. You'll want it if you're going to be making maps.  Find it on [Github](https://github.com/runapp-aus/strayr).

* *readabs* The `readabs` package, by Matt Cowgill, provides an easy way to download, tidy, and import ABS time series data in R. Find it on [Github](https://github.com/mattcowgill/readabs).
