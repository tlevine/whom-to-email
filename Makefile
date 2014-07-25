directory := data/$(shell date --rfc-3339=date)

.PHONY: conky

conky: $(directory)/sample
	cat $(directory)/sample
$(directory)/sample: $(directory)/counts
	./sample.R $(directory)/counts > $(directory)/sample
$(directory)/counts: $(directory)/names
	./search.sh < $(directory)/names > $(directory)/counts
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
