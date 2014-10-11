directory := data/$(shell date +%Y-%m-%d)

.PHONY: conky display most-recent

display:  $(directory)/weight
	sort -rn $(directory)/weight | head | cut -d, -f2
most-recent:
	$$(ls -d data/2*|tail -n1)/weight | sort -rn | head | cut -d, -f2
$(directory)/weight: $(directory)/addresses
	notmuch new
	./search.sh < $(directory)/addresses > $(directory)/weight
$(directory)/addresses: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/addresses
$(directory):
	mkdir -p $(directory)
