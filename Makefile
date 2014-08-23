directory := data/$(shell date +%Y-%m-%d)

.PHONY: conky display most-recent

display:  $(directory)/weight
	cat $(directory)/weight
most-recent:
	cat $$(ls -d data/2*|tail -n1)/weight
conky: $(directory)/weight
	sed -n -e 's/\./ /g' -e '6,$$ s/^/  /p' $(directory)/weight 
$(directory)/weight: $(directory)/counts
	./weight.R $(directory)/counts > $(directory)/weight
$(directory)/counts: $(directory)/names
	notmuch new
	./search.sh < $(directory)/names > $(directory)/counts
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
