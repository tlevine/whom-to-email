directory := data/$(shell date --rfc-3339=date)

$(directory)/counts: $(directory)/names
	printf 'address\ttotal\tpersonal\n' > $(directory)/counts
	while read address; do printf "$$address\t" >> $(directory)/counts && notmuch count "$$address" | tr '\n' '\t' >> $(directory)/counts && notmuch count "to:$$address and (from:thomas or from:levine)" >> $(directory)/counts; done < $(directory)/names
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
