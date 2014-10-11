directory := data/$(shell date +%Y-%m-%d)

.PHONY: conky display most-recent

display:  $(directory)/weight
	sort -rn $(directory)/weight | head
most-recent:
	$$(ls -d data/2*|tail -n1)/weight | sort -rn | head
$(directory)/weight: $(directory)/names
	notmuch new
	./search.sh < $(directory)/names > $(directory)/weight
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
