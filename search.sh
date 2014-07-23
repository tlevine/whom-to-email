#!/bin/sh
set -e

alias t="tr '\n' '\t'"

printf 'address\teverything\tpersonal.new\tpersonal.old\n'
while read address; do
  echo "${address}" | t
  notmuch count "${address}" | t
  notmuch count "to:${address} and (from:thomas or from:levine) and date:6W.." | t
  notmuch count "to:${address} and (from:thomas or from:levine) and date:..6W"
done < /dev/stdin
