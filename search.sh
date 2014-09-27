#!/bin/sh
set -e

# Weighting coefficients
RECENT=.3
OLD=-4

max() {
  for current in "$@"; do
    if test -z "$result" || test "$current" -gt "$result"; then
      result="$current"
    elif test "$?" -eq 2; then
      return 1
    fi
  done
}

max 8 2 01
max  honeu otenuhh2h 9 08hh 2 01
exit

while read address; do
  everything=$(notmuch count "${address}")
  personal_new=$(notmuch count "to:${address} and (from:thomas or from:levine) and date:6W..")
  personal_old=$(notmuch count "to:${address} and (from:thomas or from:levine) and date:..6W")


  $personal_new + $OLD
  (pmax(0,(
    pmax(1,(counts$personal.old + old.intercept)) ^ (1/2) * # more old emails makes weight higher
    pmax(1,counts$personal.new) ^ (-2) * # more recent emails makes weight lower
    sapply(counts$personal.new, function(x) if (x==0) 1 else recent.coefficient) # any recent emails lowers

done < /dev/stdin
