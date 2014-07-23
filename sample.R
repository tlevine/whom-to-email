#!/usr/bin/env Rscript

# The file of counts, and the number of addresses to sample
counts.file <- 'data/2014-07-23/counts' # argv[1] would be better
people.file <- '~/.mutt/aliases/people'

# The weighting function
weights <- function(counts) {
    sqrt(pmax(0, (counts$personal.old - counts$personal.new) / sqrt(counts$everything + 1)))
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

# A plot that can be helpful for tuning the weight function
if (require(ggplot2)) {
  counts <- counts

  counts$recent.contact <- factor(counts$personal.new > 0, levels = c(TRUE,FALSE))
  levels(counts$recent.contact) <- c('Yes','No')

  p <- ggplot(counts) +
    aes(x = personal.old, y = weights(counts), color = recent.contact, label = address) +
    scale_color_discrete('Recent email?') +
    geom_text() + scale_x_log10('Old emails') + scale_y_continuous('Sampling weight')
  ggsave(sub('counts','weights.pdf', counts.file), p, width = 8.5, height = 14, units = 'in')
}

cat('Email the first of these people whom you haven\'t seen recently.\n\n')
cat(paste0(paste(people[grep(pattern, people$address),'name'], collapse = '\n'), '\n'))
