#!/bin/sh
set -e

# Because we don't have floats
PRECISION=100000

# Weighting coefficients
RECENT=$(($PRECISION * 3 / 10))
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


  x1=$(max $PRECISION $(( ($PRECISION * ($personal_old + $OLD)) ** (1/2) )))
  x2=$(max $PRECISION $(( $PRECISION / ($personal_new ** (2)) )))
  if test $personal_new -eq 0; then
    x3=$PRECISION
  else
    echo $RECENT
    x3=$(($PRECISION * $RECENT))
  fi

  echo "${address}", $(max 0 $(( ($x1 * $x2 * $x3) / ($PRECISION ** 3) )) )
done < /dev/stdin
