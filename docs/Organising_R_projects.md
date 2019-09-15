# Organising an R project at Grattan {#organising-projects} 

All our work, in R or otherwise, should heed the "hit by a bus" rule - if you're not around, colleagues should be able to access, understand, verify, and build on the work you've done.

Organising your analysis in a predictable, consistent way helps to make your work reproducible by others, including yourself in the future. This is really important! If your analysis is messy, you're more likely to make errors, and less likely to spot them. Other people will find it hard to check your analysis and you'll find it harder to return to it down the track. 

This page sets out some guidelines for organising your work in R at Grattan. It covers:

* Using RStudio projects and relative filepaths
* Using a consistent subfolder structure
* Naming your scripts and keeping them manageable
* Coding style at Grattan

## Use RStudio projects, not `setwd()`

You'll almost always be reading and/or writing files to disk as part of your analysis in R. To do this, R needs to know where to read files from and save files to. By default, it uses your working directory. 

One way to tell R which folder to use as your working directory is using the command `setwd()`, like `setwd("~/Desktop/some random folder")` or `setwd("C:\Users\mcowgill\Documents\Somerandomfolder")`. **This is a bad idea!** If anyone - including you - tries to run your script on a different machine, with a different folder structure, it probably won't work. If people can't get past the first line when they're trying to run your script, there's an annoying and unnecessary hurdle to reproducing and checking your analysis.

In the [words of Jenny Bryan](https://www.tidyverse.org/articles/2017/12/workflow-vs-script/):

> if the first line of your R script is `setwd("C:\Users\jenny\path\that\only\I\have")` I will come into your office and SET YOUR COMPUTER ON FIRE. 

Seems fair. 

Creating a 'project' in RStudio sets your working directory in a way that's portable across machines. Creating an RStudio project is straightforward: **click File, then New Project**. You can then choose to start your project in a new directory, or an existing directory. Simple!

<img src="atlas/rstudio_newproject.png" width="66%" style="display: block; margin: auto;" />

RStudio will then create a file with an .Rproj extension in the folder you've chosen. When you want to work in this project, just open the .Rproj file, or click File -> Open project in RStudio. Your working directory will be set to the directory that contains the .Rproj file.

## Keep your stuff together

Your script(s), data, and output should generally all live in the same place. ^[This isn't always possible, like when you're working with restricted-access microdata. But unless there's a really good reason why you can't keep your data together with the rest of your work, you should do it.] That place should be the folder that contains the .Rproj file that was created when you created an RStudio project, and subfolders of that folder. 

Don't just put everything in your project folder itself. This can get really overwhelming and confusing, particularly for anyone trying to understand and check your work. Instead, separate your code, your source data, and your output into subfolders.

A good structure is to have a subfolder for:

- your code - called 'R'
- your source data - called 'data'
- your graphs - called 'atlas', like in our LaTeX projects
- your non-graph output, like formatted tables, called 'output'

Sometimes your data folder might have subfolders - 'raw' for data that you've done nothing to, and 'clean' for data you've modified in some way.^[Other folder structures are OK and might make more sense for your project. The important thing is to **have** a folder structure, and to use a structure that is easily comprehensible to anyone else looking at your analysis.] 

## Include a README file {#README}

Your analysis workflow might seem completely obvious to you. Let's say that in one script you load raw ABS microdata, run a particular script to clean it up, save the cleaned data somewhere, then load that cleaned data in a second script to produce a summary table, then use a third script to produce a graph based on the summary table. Easy! 

Except that might not seem easy or self-explanatory to anyone who comes along and tries to figure out how your analysis works, including you in the future. 

Make things easier by including a short text file - called README - in the project folder. This should explain the purpose of the project, the key files, and (if it isn't clear) the order in which they should be run. If you got the data from somewhere non-obvious, explain that in the README file.

## Use relative filepaths

When you read or write files with R, don't use filepaths that are specific to your machine. For one thing, these machine-specific filepaths will fail when someone else tries to run your script. For another, they're super annoying! Who wants to type out a full filepath everytime you load or save a file? 

**Bad**

```r
hes <- read_csv("/Users/mcowgill/Desktop/hes1516.csv")
hes <- read_csb("C:\Users\mcowgill\Desktop\hes1516.csv")
grattan_save("/Users/mcowgill/Desktop/images/expenditure_by_income.pdf")
```

Instead, use relative filepaths. These are filepaths that are relative (hence the name) to your project folder, which you set by creating an RStudio project.

**Good**


```r
hes <- read_csv("data/HES/hes1516.csv")
grattan_save("atlas/expenditure_by_income.pdf")
```

The first example above tells R to look in the 'data' subdirectory of your project folder, and then the 'HES' subdirectory of 'data', to find the 'hes1516.csv' file. This file path isn't specific to your machine, so your code is more shareable this way.

## Keep your scripts manageable {#manageable}

Unless your project is very simple, it's probably not a good idea to put all your work into one R script. Instead, break your analysis into discrete pieces and put each piece in its own file. Number the files to make it clear what order they're supposed to be run in.

Here's a useful structure: 

- 01_import.R
- 02_tidy.R
- 03_model.R
- 04_visualise.R

It should be clear what each script is trying to do. Use meaningful filenames that clearly indicate the overarching purpose of the script. Use comments to explain why you're doing things! 

## Omit needless code

Don't retain code that ultimately didn't lead anywhere. If you produced a graph that ended up not being used, don't keep the code in your script - if you want to save it, move it to a subfolder named 'archive' or similar. Your code should include the steps needed to go from your raw data to your output - and not extraneous steps. If you ask someone to QC your work, they shouldn't have to wade through 1000 lines of code just to find the 200 lines that are actually required to produce your output.

When you're doing data analysis, you'll often give R interactive commands to help you understand what your data looks like. For example, you might view a dataframe with `View(mydf)` or `str(mydf)`. This is fine, and often necessary, when you're doing your analysis. **Don't keep these commands in your script**. These type of commands should usually be entered straight into the R console, not in a script.

## Rules_9a_FINAL_FINAL_MC

We're all familiar with this hellish scenario: you do some work in a Word document (shudder, shudder, etc.), email it to a colleague, the colleague edits it and sends it back with a tweaked filename, like `cool_word_doc_002.docx`. Try to avoid replicating this nightmare in R.

**Don't** create multiple versions of the same script (like `analysis_FINAL_002_MC.R` and `analysis_FINALFINAL_003_MC_WM.R`.) If you do end up with multiple versions, put everything other than the latest version in a subfolder of your "R" folder, called "R/archive". To avoid a horrible mess of `analysis_FINAL_002.R` type documents cluttering up your folder, consider using [Git for version control](#version-control).

