#!/usr/bin/env Rscript

#' The weighting function
#'
#' This function should weight highly people whom I want to email
#' but haven't it a while. It should substantially lower the weight
#' of someone whom I've just emailed.
weights <- function(counts, recent.coefficient = .3, old.intercept = -4) {
  (pmax(0,(
    pmax(1,(counts$personal.old + old.intercept)) ^ (1/2) * # more old emails makes weight higher
    pmax(1,counts$personal.new) ^ (-2) * # more recent emails makes weight lower
    sapply(counts$personal.new, function(x) if (x==0) 1 else recent.coefficient) # any recent emails lowers
  # pmax(1,counts$everything)   ^ (-1/2)
    )))
}

# Open the files.
counts <- read.csv(counts.file, sep = '\t', stringsAsFactors = FALSE)
connection <- file(people.file)
people <- data.frame(raw = readLines(connection))
close(connection)

# Parse the mutt file.
people$name <- sub(' .*', '', sub('alias ', '', people$raw))
people$address <- sub('.* <?([^ >]+)>?$', '\\1', people$raw)

# Choose the highest-weighted people.
addresses <- counts$address[order(weights(counts), decreasing = TRUE)][1:8]

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
    scale_x_log10('Old emails') + scale_y_continuous('Sampling weight')
  ggsave(sub('counts','weights.pdf', counts.file), p + geom_text(), width = 8.5, height = 14, units = 'in')
  ggsave(sub('counts','weights-anonymous.pdf', counts.file), p + geom_point(), width = 8.5, height = 14, units = 'in')

  # The weight should change noticably
  counts.bumped <- counts
  for (column in c('everything','personal.new')) {
    counts.bumped[,column] <- counts[,column] + 1
  }
  weight.changes <- data.frame(
    address = counts$address,
    present = weights(counts),
    bumped = weights(counts.bumped),
    recent.contact = counts$recent.contact
  )
  p <- ggplot(weight.changes) +
    aes(x = present, y = bumped, color = recent.contact, label = address) +
    scale_color_discrete('Recent email?') +
  # coord_equal() +
    geom_abline(intercept = 0, slope = 1) +
    scale_x_continuous('Present weight') +
    scale_y_continuous('Weight if I sent another email') +
    ggtitle('Do the weights change when I send more emails?')
  ggsave(sub('counts','weight-changes.pdf', counts.file), p + geom_text(), width = 9, height = 9, units = 'in')
  ggsave(sub('counts','weight-changes-anonymous.pdf', counts.file), p + geom_point(), width = 9, height = 9, units = 'in')
}

cat(
'Email the first person listed here,
unless that doesn\'t make sense, in
which case you should keep going down
the list.

')
cat(paste0(paste(people[grep(pattern, people$address),'name'], collapse = '\n'), '\n'))
