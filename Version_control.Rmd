# Version control {#version-control}

This chapter explores version control and lays out the tools we use for version control.

## Version control is important and intimidating

Version control is great! And although it's initially quite complicated and stress-inducing, in the long run you'll find it actually makes so much sense, and wish you'd known about it while you were writing university essays! 

Why? Two reasons.

1. Version control allows us to go back in time. 

2. Version control allows multiple analysts to work on a project simultaneously, in a way that Excel just doesn't.

### Step back in time

Let's talk first about going back in time. Version control means we have multiple snapshots of a project at different stages during development. This means if you get into a big mess in your code one day, you can easily jump back to an earlier point and start again. 

And if used properly, version control also stores the project's journey, allowing you to record why you made the decisions you did. This can be really useful -- if you need to edit multiple files at once to make a big change, it's useful to have a record of when and why you made those changes. This does not diminish the need to have lots of comments in your code, however; those remain vitally important for explaining what the code does.

### Get outta my way

As for working together simultaneously, there are two extreme situations we often encounter (and version control bridges the gap). 

Situation 1: you're working on an Excel model, and your teammate needs to make a change. They jump in, make a change, and save the file (despite Dropbox's warning that someone else is editing the document). Soon after, you save your changes. Boom! Now you have a conflicted copy on the Dropbox. 

Situation 2: two of you are working in a Google Sheet. This is so much more collaborative -- you can see each other in the document, and see what cell you're working in. But then your teammate changes a formula in cell B45, which happens to affect the analysis you're doing in cell A3 on the next sheet. Now you're not sure if your formula is right or not, because the value you were expecting to see is not appearing. How annoying! 

Version control allows you both to work on a document at the same time, but only implement the other person's changes when you want to. And if your edits conflict with theirs, instead of getting a new conflicted copy document in the Dropbox, your version control software can tell you exactly where the conflict arose so you can quickly decide how to fix it. 

Need more convincing? [Jenny Bryan](https://peerj.com/preprints/3159v2/) from RStudio eloquently explains why you need version control in your life. Seriously. It's a great article. It convinced us.


## Using Github

We use Github to version-control and share reports in LaTeX, so you're already a bit set-up. 

If version control is akin to writing history, Github is the library where that information is archived and where you can go to easily retrieve the information.

Git, on the other hand, is the printing press that makes the books. Or, to try another tortured metaphor, if Github is like iTunes then Git is the software to make MP3s. 

To go back into the past and look at old versions of our analysis, we'd normally visit [Github](http://github.com) to find our project and its history. Github is also the place where we can raise issues about the code to alert team members, assign team members specific tasks, and deal with code conflicts if/when they arise.

Make sure you have a personal Github account, and then ask a Grattan staff member (e.g. Will or James) to add you to Grattan's organisation-wide Github account. If you've set up a LaTeX document, you've probably already completed these steps.

### Setting up a Github account and Github Desktop

To set up a Github account, follow these steps:

- Go to [github.com](github.com) and click **Sign up**.
- Complete the sign up form. You can use your personal (recommended) or Grattan email address.^[Personal email addresses are recommended because you _may_ want to keep your Github account after you have left Grattan. Although that may be wishful thinking from the authors.]

You access Github through your browser. But we need to connect and sync our local files as well. To do this, we use Github Desktop.^[This is definitely not the only way to do this. You can sync with Github through ]
To download and use Github Desktop, follow these steps:

- Create a Github account.
- Go to [desktop.github.com](desktop.github.com) and download **Github Desktop**.
- From Github Desktop, sign into your account and authorise Github Desktop.
- If asked to 'Configure Git', select **Use my Github account name and email address** and click **Finish**. 

That should do it. 

### Getting started with Github

The 10-minute `hello-world` tutorial made by the people at Github is informative and useful.
It explains the key terms used in the world of Git -- a few of them used below -- and runss your through how to:

- Create and use a **repository**
- Start and manage a new **branch**
- Make changes to a file and **push** them to GitHub as commits
- Open and merge a **pull** request

Take the time to do it now: http://guides.github.com/activities/hello-world


### Some Git tips

1. Commit early, commit often
    + By committing lots of small changes individually, you'll have a richer history of the project. It's a bit like trying to beat a difficult level of a video game. If you mess up but have saved often, you'll have a more recent place to go back to. But you if save rarely, then you'll need to go quite a way back to your last savefile. 

2. Pull before pushing
    + After commiting your changes locally, this steps makes sure you've got the most up-to-date version of the project on your machine, so you can see where your commits might conflict with changes others have made. 

3. Write meaningful, descriptive commit messages
    + You'll thank yourself later. 

4. Use the `.gitignore` file to -- shockingly! -- tell Git and Github to ignore specific files. This can be useful for system files, like `.DS_Store` and your `.Rproj` that do not need to be synced with your project folder. It can also be useful for large datasets (i.e. those over 50MB).
