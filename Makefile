tmp/names:
	cat ~/.mutt/aliases/people | cut -d '<' -f 2 | cut -d '>' -f 1 > tmp/names

