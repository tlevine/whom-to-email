directory := data/$(shell date +%Y-%m-%d)

.PHONY: conky display most-recent

display:  $(directory)/weight
	tail $(directory)/weight
most-recent:
	tail $$(ls -d data/2*|tail -n1)/weight
$(directory)/weight: $(directory)/names
	notmuch new
	./search.sh < $(directory)/names > $(directory)/weight
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
