# Why use R?

We can break this question into two parts:

1. Why use script-based software to analyse data?
2. Why use R, specifically?

## Why use script-based software? {#why-script}

It's important for our analyses to be **reproducible**. This means that all of the steps that were taken to go from your raw data to your final outputs are clearly set out and can be reproduced if necessary. 

Reproducibility is very important for quality control ("QC"), particularly of complex analyses - if it's not clear what you've done, it's hard for someone to check your work. It also makes things easier for you in the future - coming back to an old analysis a few months or years down the track is much easier if it's reproducible. At Grattan, most of us rotate from program to program periodically -- your colleagues will probably need to revisit your work at some point in the future, and they'll thank you if it's in a reproducible script.

Script-based analyses are more likely to be reproducible.^[Using a script-based approach doesn't guarantee that your analysis will be truly reproducible. If your work involves some steps that aren't documented in the script - such as data "cleaning" in Excel - then it is not fully reproducible. If your script will only run on your machine - because there are undocumented options, for example - it is not reproducible.] A script sets out all the steps that were taken from reading in data, to tidying it, to estimating models or summary statistics and generating output. 

Analysis that isn't script based, like work done in Excel, is almost never reproducible. It is generally unclear what steps were taken, in which order, to go from the raw data to the output. It isn't even always clear in a spreadsheet what is the 'raw data' and what has been modified in some way.

Using scripts makes us less susceptible to the sort of errors [famously made by the economists Reinhart and Rogoff](https://en.wikipedia.org/wiki/Growth_in_a_Time_of_Debt#Methodological_flaws) in their Excel-based analysis of the effect of public debt on economic growth. It's still quite possible to make errors in a script-based analysis, but those errors are easier to find when the analysis is more transparent.

![](atlas/reinhart_rogoff.jpg)<!-- -->

Script-based analysis software also allows us to:

* Work with larger data sets;
* Work with data in a broader range of formats;
* Easily combine different data sets;
* Automate tasks and build from previous analyses; and
* Estimate a broad range of statistical models.

## Why use R specifically? {#why-R}

Doing reproducible, script-based, research doesn't necessarily involve using R. It's perfectly possible to do reproducible work in Stata or Python (though somewhat harder in SPSS, where data is often manipulated by clicking things).

We use R specifically because:

* It's free!
* It's open source.
* It's powerful, particularly when it comes to statistics and data science.
* It's flexible and customisable.
* It has an active community extending its capabilities all the time and providing support online.
* It can be used to make publication-quality graphs.
* It's becoming the norm in academic research and common in the corporate world.
