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

while read address; do
  everything=$(notmuch count "${address}")
  personal_new=$(notmuch count "to:${address} and (from:thomas or from:levine) and date:6W..")
  personal_old=$(notmuch count "to:${address} and (from:thomas or from:levine) and date:..6W")


  x1=$(max 1 $(( ($personal_old + $OLD) ** (1/2) )))
  x2=$(max 1 $(( $personal_new ** (-2) )))
  if test $personal_new -eq 0; then
    x3=1
  else
    x3=$RECENT
  fi

  echo "${address}", $(max 0 $(($x1 * $x2 * $x3)))
done < /dev/stdin
