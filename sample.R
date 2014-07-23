#!/usr/bin/env Rscript

# Inputs: The file of counts, and the number of addresses to sample
filename <- 'data/2014-07-23/counts' # argv[1] would be better
size <- 10

# Open the file.
counts <- read.csv(filename, sep = '\t', stringsAsFactors = FALSE)


# Weight the probabilities.
prob.numerator <- sqrt(counts$personal)

# Take the sample, using the file as a seed.
seed <- sum(counts[-1])
set.seed(seed)
address <- sample(counts$address, size, prob = prob.numerator)

# Emit the result.
cat(address, '\n')
