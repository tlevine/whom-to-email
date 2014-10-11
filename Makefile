directory := data/$(shell date +%Y-%m-%d)

.PHONY: display most-recent

display:  $(directory)/weight most-recent

most-recent:
	sort -rn $$(ls -d data/2*[0-9]|tail -n1)/weight | head | cut -d, -f2
$(directory)/weight: $(directory)/addresses
	notmuch new
	./search.sh < $(directory)/addresses > $(directory)/weight
$(directory)/addresses: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/addresses
$(directory):
	mkdir -p $(directory)
