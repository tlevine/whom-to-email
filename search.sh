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

  adjusted_old=$(echo "${personal_old} + ${OLD}" | bc -l)
  if test 1 -eq $(echo "${adjusted_old} < 0" | bc -l); then
    x1=0
  else
    x1=$(echo "sqrt(${adjusted_old})" | bc -l)
  fi

  if test "${personal_new}" -eq 0; then
    x2=1
    x3=1
  else
    x2=$(max 1 $(echo "${personal_new} ^ (-2)" | bc -l)) # more recent emails makes weight lower
    x3="${RECENT}"
  fi

  score=$(max 0 $(echo "$x1 * $x2 * $x3" | bc -l))

  echo "${score},${address}"
done < /dev/stdin
