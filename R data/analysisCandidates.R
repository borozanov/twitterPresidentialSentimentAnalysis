library(twitteR)
library(plyr)
library(ggplot2)

#Fetch Tweets for each candidate respectively
tweetsObama = searchTwitter("#Obama", n=1500)
tweetsSanders = searchTwitter("#Sanders", n=1500)
tweetsTrump = searchTwitter("#DonaldTrump", n=1500)

#Extract the tweets text info
tweetsObama.text = laply(tweetsObama, function(t) t$getText())
tweetsSanders.text = laply(tweetsSanders, function(t) t$getText())
tweetsTrump.text = laply(tweetsTrump, function(t) t$getText())

#read the bank of words of positive/negative
positive = scan("positive-words.txt", what = "character", comment.char = ";")
negative = scan("negative-words.txt", what = "character", comment.char = ";")

#Reference the sentiment script for calculating score
source("sentiment.R")

#It takes the matching reuslt of positive and negative encounteres and calculates a score
resultObama = score.sentiment(tweetsObama.text, positive, negative, .progress = "text")
resultObama$candidate = "obama"

resultSanders = score.sentiment(tweetsSanders.text, positive, negative, .progress = "text")
resultSanders$candidate = "sanders"

resultTrump = score.sentiment(tweetsTrump.text, positive, negative, .progress = "text")
resultTrump$candidate = "trump"

#Example of the score output
hist(resultObama$score)

#To compare, we bind the dfs and plot the result
candidates = rbind(resultTrump, resultSanders)
ggplot(candidates, aes(score, fill = candidate)) + geom_density(alpha = 0.2)

#similar for the other two candidates
candidates = rbind(resultObama, resultSanders)
ggplot(candidates, aes(score, fill = candidate)) + geom_density(alpha = 0.2)