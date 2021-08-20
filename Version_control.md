# Version control {#version-control}

## Version control is important and intimidating

Version control is great! And although it's initially quite complicated and stress-inducing, in the long run you'll find it actually makes so much sense, and wish you'd known about it while you were writing university essays! 

Why? Two reasons.

1. Version control allows us to go back in time. 

2. Version control allows multiple analysts to work on a project simulataneously, in a way that Excel just doesn't.

### Step back in time

Let's talk first about going back in time. Version control means we have multiple snapshots of a project at different stages during development. This means if you get into a big mess in your code one day, you can easily jump back to an earlier point and start again. 

And if used properly, version control also stores the project's journey, allowing you to record why you made the decisions you did. This can be really useful -- if you need to edit multiple files at once to make a big change, it's useful to have a record of when and why you made those changes. This does not diminish the need to have lots of comments in your code, however; those remain vitally important for explaining what the code does.

### Get outta my way

As for working together simultaneously, there are two extreme situations we often encounter (and version control bridges the gap). 

Situation 1: you're working on an Excel model, and your teammate needs to make a change. They jump in, make a change, and save the file (despite Dropbox's warning that someone else is editing the document). Soon after, you save your changes. Boom! Now you have a conflicted copy on the Dropbox. 

Situation 2: two of you are working in a Google Sheet. This is so much more collaborative -- you can see each other in the document, and see what cell you're working in. But then your teammate changes a formula in cell B45, which happens to affect the analysis you're doing in cell A3 on the next sheet. Now you're not sure if your formula is right or not, because the value you were expecting to see is not appearing. How annoying! 

Version control allows you both to work on a document at the same time, but only implement the other person's changes when you want to. And if your edits conflict with theirs, instead of getting a new conflicted copy document in the Dropbox, your version control software can tell you exactly where the conflict arose so you can quickly decide how to fix it. 

Need more convincing? [Jenny Bryan](https://peerj.com/preprints/3159v2/) from RStudio eloquently explains why you need version control in your life. Seriously. It's a great article. It convinced us.

## Github

We use Github to version-control and share reports in LaTeX, so you're already a bit set-up. 

If version control is akin to writing history, Github is the library where that information is archived and where you can go to easily retrieve the information.

Git, on the other hand, is the printing press that makes the books. Or, to try another tortured metaphor, if Github is like iTunes then Git is the software to make MP3s. 

To go back into the past and look at old versions of our analysis, we'd normally visit [Github](http://github.com) to find our project and its history. Github is also the place where we can raise issues about the code to alert team members, assign team members specific tasks, and deal with code conflicts if/when they arise.

Make sure you have a personal Github account, and then ask a Grattan staff member (e.g. Will or James) to add you to Grattan's organisation-wide Github account. If you've set up a LaTeX document, you've probably already completed these steps.

## Git

Git is our preferred version control software. And what's nice is that you can set up RStudio to allow you use Git seamlessly.^[The alternatives to using Git in RStudio are to use Git via the Github Desktop app (speak to Will if you'd rather do this) or directly from the command line. But the point-and-click functionality of RStudio is a much nicer way to get used to version control.]

Jenny Bryan from RStudio will walk you through the installation steps in Chatpers 4-7 (they're extremely short chapters):

[Click here to access the definitive Git installation guide.](https://happygitwithr.com/install-intro.html) 
Of course, if you get stuck, ask!

Now that you're installed, we need to connect RStudio with Github so you can use Git. 

The best guide on how to do that is by Simon Brewer (link below). Jenny Bryan's guide offers similar advice, but I found Simon's easier to follow. 

[Click here for how to connect RStudio and Github](http://rstudio-pubs-static.s3.amazonaws.com/485236_9e71a253a02748cba293213a8aec5fe8.html)

There are some pretty unfriendly pieces of jargon in these steps. The worst is `SSH`, or "Secure Shell Protocol". In brief, it's how you'll login to Github account from RStudio. Instead of submitting your username and password every time, you'll have to set up an `SSH key pair` **one time per device** on which you want to link RStudio and Github. That's probably just your work computer, and maybe a laptop too if you need. 

`SSH` is a more secure way of logging into Github from other applications (in this case, RStudio), and by [August 2021](https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/) it will be the **only** method approved by Github. 

Again, this set up stuff is confusing, so please ask if you need help! It's likely to be *much* faster if you ask a fellow staff member than try to solve an unexpected problem on your own.



## Using Git

Chapter 15 onwards of [Happy Git with R](https://happygitwithr.com/install-intro.html) will walk you through some early examples of how to use Git. 

Another good option is to prod a Grattan staff member to run a tank-time on version control. If it's a been a while, and there's more than one new staff member, then this might be the most efficient way to get associates/fellows engaged in the topic and improve organisation-wide practice.

If you're using SSH to log into Git, you may run into an unexpected error when trying to clone a project from Github to your machine (this has happened to James twice). The solution is clone the project using the command line, rather than the RStudio interface. You can access the command line directly from RStudio, however. Go to `Tools` -> `Terminal` -> `New Terminal`, and then use the command 
```{}
git clone git@github.com:grattan/MyRepoNameHere ~/path_to_the_folder_where_i_want_the_project_on_my_machine
```

Some guiding principles to leave you with: 

1. Commit early, commit often
    + By committing lots of small changes individually, you'll have a richer history of the project. It's a bit like trying to beat a difficult level of a video game. If you mess up but have saved often, you'll have a more recent place to go back to. But you if save rarely, then you'll need to go quite a way back to your last savefile. 

2. Pull before pushing
    + After commiting your changes locally, this steps makes sure you've got the most up-to-date version of the project on your machine, so you can see where your commits might conflict with changes others have made. 

3. Write meaningful, descriptive commit messages
    + You'll thank yourself later. 

