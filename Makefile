directory := data/$(shell date --rfc-3339=date)

	

$(directory)/sample: $(directory)/counts
	./sample.R $(directory)/names > $(directory)/sample
$(directory)/counts: $(directory)/names
	./search.sh < $(directory)/names > $(directory)/counts
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
