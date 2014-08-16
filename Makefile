directory := data/$(shell date +%Y-%m-%d)

.PHONY: conky display

display:  $(directory)/weight
	cat $(directory)/weight
conky: $(directory)/weight
	sed -n -e 's/\./ /g' -e '6,$$ s/^/  /p' $(directory)/weight 
$(directory)/weight: $(directory)/counts
	./weight.R $(directory)/counts > $(directory)/weight
$(directory)/counts: $(directory)/names
	./search.sh < $(directory)/names > $(directory)/counts
$(directory)/names: $(directory)
	cat ~/.mutt/aliases/people | sed -e 's/>\? *$$//' -e 's/^.* <\?//g' > $(directory)/names
$(directory):
	mkdir -p $(directory)
