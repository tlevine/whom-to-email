#!/usr/bin/env Rscript

# The file of counts, and the number of addresses to sample
counts.file <- 'data/2014-07-23/counts' # argv[1] would be better
people.file <- '~/.mutt/aliases/people'

# Open the files.
counts <- read.csv(counts.file, sep = '\t', stringsAsFactors = FALSE)
connection <- file(people.file)
people <- data.frame(raw = readLines(connection))
people$name <- sub(' .*', '', sub('alias ', '', people$raw))
people$address <- sub('.* <?([^ >]+)>?$', '\\1', people$raw)

# Weight the probabilities.
prob.numerator <- sqrt(counts$personal)

# Take the sample, using the file as a seed.
set.seed(sum(counts[-1]))
addresses <- sample(counts$address, 8, prob = prob.numerator)

# Emit the result.
pattern <- paste(addresses, collapse = '|')

cat('Email the first of these people whom you haven\'t seen recently.')
cat(paste0(paste(people[grep(pattern, people$address),'name'], collapse = '\n'), '\n'))
