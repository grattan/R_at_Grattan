# Grattan coding style {#coding-style}



*This page sets out the core elements of coding style we use at Grattan. If you're new to R, don't stress about remembering - or even understanding - everything on this page. Just be aware that we have a coding style, and come back to this when you're a bit further along.*

The benefits of a common coding style are well explained [by Hadley Wickham](http://r-pkgs.had.co.nz/style.html):

> Good style is important because while your code only has one author, it’ll usually have multiple readers. This is especially true when you’re writing code with others. In that case, it’s a good idea to agree on a common style up-front.

Below we describe the **key** elements of Grattan coding style, without being too tedious about it all. There are many elements of coding style we don't cover in this guide; if you're unsure about anything, [consult the `tidyverse` guide](https://style.tidyverse.org/). 

You should also see the [Using R at Grattan](#organising-projects) page for guidelines about setting up your project.

A core principle for coding at Grattan is that your code should be **readable by humans**. 

## Load packages first

Our analysis scripts will almost always involve loading some [packages](#packages). These should be laoded at the top of a script, in one block like this:


```r
library(tidyverse)
library(grattantheme)
```

If you're loading a package from Github, it's a good idea to leave a [comment](#use-comments) to say where it came from, like this:


```r
library(tidyverse)
library(grattantheme)
library(strayr) # remotes::install_github("runapp-aus/strayr")
```

Don't scatter `library()` calls throughout your script - put them all at the top. 

The only thing that should come before loading your packages is the script preamble.

## Script preamble

Describe what your script does in the first few lines using comments or within an RMarkdown document.

**Good**

```r
# This script reads ABS data downloaded from TableBuilder and combines into a single data object containing post-secondary education levels by age and gender by SA3. 
```

Your preamble might also pose a research question that the script will answer.

**Good**

```r
# Do women have higher levels of educational attainment than men, within the same geographical areas and age groups?
```

Your preamble shouldn't be a terse, inscrutable comment.

**Bad**

```r
# make ABS ed data graph
```

If it's hard to concisely describe what your script does in a few lines of plain English, that might be a sign that your script does too many things. Consider breaking your analysis into a series of scripts. See [Organising R Projects at Grattan](#organising-projects) for more.

Your preamble should anticipate and answer any questions other people might have when reviewing your script. For example:

**Good**

```r
# This script calculates average income by age group and sex using the ABS Household Expenditure Survey and joins this to health information by age groups and sex from the National Health Survey. Note that we can't use the income variable in the NHS for this purpose, as it only contains information about respondents' income decile, not the income itself.
```

The preamble should pertain the the code contained in the specific script. If you have comments or information about your analysis as a whole, put it in your [README file](#README).

## Use comments {#use-comments}

Comments are necessary where the code _alone_ doesn't tell the full story. Comments should tell the reader **why** you're doing something, rather than just **what** you're doing. 

For example, comments are important when groups are coded with numbers rather than character strings, because this might not be obvious to someone reading your script:

**Necessary to comment**

```r
data %>% 
  filter(gender == 1,   # Keep only male observations
         age == "05")   # Keep only 35-39 year-olds. 
```















































