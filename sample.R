# Inputs: The file of counts, and the number of addresses to sample
filename <- 'data/2014-07-23/counts' # argv[1] would be better
size <- 1

# Open the file.
counts <- read.csv(filename, sep = '\t', stringsAsFactors = FALSE)

# Weight the probabilities.
counts$prob.numerator <- sqrt(counts$personal)

# Take the sample.
address <- sample(counts$address, size, prob = counts$prob.numerator)

# Emit the result.
cat(address, '\n')
