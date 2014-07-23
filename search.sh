#!/bin/sh
set -e

alias t="tr '\n' '\t'"

printf 'address\ttotal\tpersonal\n'
while read address; do
  printf "${address}\t"
  notmuch count "${address}" | t
  notmuch count "to:${address} and (from:thomas or from:levine)" | t
  notmuch count "to:${address} and (from:thomas or from:levine) and date:..6W" | t
  printf '\n'
done < /dev/stdin
