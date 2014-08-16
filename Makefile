directory := data/$(shell date +%Y-%m-%d)

.PHONY: conky display

display:  $(directory)/sample
	cat $(directory)/sample
conky: $(directory)/sample
	sed -n -e 's/\./ /g' -e '6,$$ s/^/  /p' $(directory)/sample 
$(directory)/sample: $(directory)/counts
	./sample.R $(directory)/counts > $(directory)/sample
$(directory)/counts: $(directory)/names
	./search.sh < $(directory)/names > $(directory)/counts
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
