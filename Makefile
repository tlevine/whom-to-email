tmp/names:
	cat ~/.mutt/aliases/people | cut -d '<' -f 2 | cut -d '>' -f 1 > tmp/names
tmp/counts: tmp/names
	printf 'address\ttotal\tpersonal\n' > tmp/counts
	while read address; do printf "$$address\t" >> tmp/counts && notmuch count "$$address" | tr '\n' '\t' >> tmp/counts && notmuch count "to:$$address and (from:thomas or from:levine)" >> tmp/counts; done < tmp/names
