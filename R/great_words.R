
great_words <- c("very good",
                   "superb",
                   "outstanding",
                   "magnificent",
                   "of high quality",
                   "of the highest quality",
                   "of the highest standard",
                   "exceptional",
                   "marvellous",
                   "wonderful",
                   "sublime",
                   "perfect",
                   "eminent",
                   "pre-eminent",
                   "supreme",
                   "first-rate",
                   "first-class",
                   "superior",
                   "superlative",
                   "splendid",
                   "admirable",
                   "worthy",
                   "sterling",
                   "fine",
                   "super",
                   "ace",
                   "great",
                   "terrific",
                   "tremendous",
                   "fantastic",
                   "fab",
                   "top-notch",
                   "tip-top",
                   "class",
                   "awesome",
                   "magic",
                   "wicked",
                   "cool",
                   "out of this world",
                   "too good to be true",
                   "mind-blowing",
                   "brilliant",
                   "brill",
                   "smashing",
                   "champion",
                   "badass",
                   "awesomesauce",
                   "on fleek",
                   "legit",
                   "beaut",
                   "bonzer",
                   "swell",
                   "shit hot",
                   "applaudable")


great <- function() {
  n <- round(runif(1, 0, length(great_words)), 0)
  great_words[n]
}

Great <- function() {
  n <- round(runif(1, 0, length(great_words)), 0)
  word <- great_words[n]
  substr(word, 1, 1) <- toupper(substr(word, 1, 1))
  word
}

