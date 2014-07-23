#!/usr/bin/env Rscript

# The file of counts, and the number of addresses to sample
counts.file <- 'data/2014-07-23/counts' # argv[1] would be better
people.file <- '~/.mutt/aliases/people'

# The weighting function
weights <- function(counts) {
    pmax(0, (counts$personal.old)^(1/4) - counts$personal.new)
}

# A plot that can be helpful for tuning the weight function
tune.weights <- function() {
  library(ggplot2)
  counts <- counts

  p1 <- ggplot(counts) +
    aes(x = personal.old, y = personal.new, label = address) +
    geom_text() + scale_x_log10('Old') + scale_y_log10('New')

  counts$recent.contact <- factor(counts$personal.new == 0, levels = c(TRUE,FALSE))
  levels(counts$recent.contact) <- c('Yes','No')

  p2 <- ggplot(counts) +
    aes(x = everything, y = personal.old, color = recent.contact, label = address) +
    scale_color_discrete('Recent email?') +
    geom_text() + scale_x_log10('Everyone') + scale_y_log10('Me')

  p3 <- ggplot(counts) +
    aes(x = personal.old, y = weights(counts), color = recent.contact, label = address) +
    scale_color_discrete('Recent email?') +
    geom_text() + scale_x_log10('Old emails') + scale_y_continuous('Sampling weight')

  # list(p1 = p1, p2 = p2)
  p3
}

# Open the files.
counts <- read.csv(counts.file, sep = '\t', stringsAsFactors = FALSE)
connection <- file(people.file)
people <- data.frame(raw = readLines(connection))
close(connection)

# Parse the mutt file.
people$name <- sub(' .*', '', sub('alias ', '', people$raw))
people$address <- sub('.* <?([^ >]+)>?$', '\\1', people$raw)

# Weight the probabilities.
prob.numerator <- weights(counts)

# Take the sample, using the file as a seed.
set.seed(sum(counts[-1]))
addresses <- sample(counts$address, 8, prob = prob.numerator)

# Emit the result.
pattern <- paste(addresses, collapse = '|')

cat('Email the first of these people whom you haven\'t seen recently.\n\n')
cat(paste0(paste(people[grep(pattern, people$address),'name'], collapse = '\n'), '\n'))
