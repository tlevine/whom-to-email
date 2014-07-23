tmp/names:
	cat ~/.mutt/aliases/people | cut -d '<' -f 2 | cut -d '>' -f 1 > tmp/names
tmp/counts: tmp/names
	while read address; do printf "$$address\t" >> tmp/counts ; notmuch count "$$address" >> tmp/counts; break; done < tmp/names
	# while read address; do address=$$(echo "$$address" | tr -d '\n'); notmuch count "$$address" >> tmp/counts; done < tmp/names
