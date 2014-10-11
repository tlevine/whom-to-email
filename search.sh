#!/bin/sh
set -e

# Weighting coefficients
RECENT=.3
OLD=-4

max() {
  for current in "$@"; do
    if test -z "$result" || test 1 -eq $(echo "${current} > ${result}" | bc); then
      result="$current"
    elif test "$?" -eq 2; then
      return 1
    fi
  done
  echo "${result}"
}

while read address; do
  everything=$(notmuch count "${address}")
  personal_new=$(notmuch count "to:${address} and (from:thomas or from:levine) and date:6W..")
  personal_old=$(notmuch count "to:${address} and (from:thomas or from:levine) and date:..6W")
  echo $everything, $personal_new, $personal_old
  max 3 2 4 

  x1=$(echo "sqrt($personal_old + $OLD)" | bc -l)
  x2=$(max 1 $(echo "1 / ($personal_new) ^ (2)" | bc -l)) # more recent emails makes weight lower
  x3=$(echo "$personal_new == 0" | bc)

  score=$(max 0 $(echo "$x1 * $x2 * $x3 | bc -l"))

  echo "${address},${score}"
done < /dev/stdin
