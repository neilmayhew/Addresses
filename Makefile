
#	Makefile for address labels
#
#	Neil Mayhew - 26 Apr 2006

.DELETE_ON_ERROR:

FOP = fop

ADDRESSES = Addresses.xml
LABELS    = Labels.xml
FO        = $(LABELS:%.xml=%.fo)
PDF       = $(LABELS:%.xml=%.pdf)

all: $(PDF)

.PHONY: all

clean:
	$(RM) $(LABELS) $(FO) $(PDF)

.PHONY: clean

lint:
	xmllint --noout --valid $(ADDRESSES)

.PHONY: lint

Labels.xml: labelize.xsl Addresses.xml
	xsltproc -o $@ $^

Labels.fo: table-fo.xsl Labels.xml
	xsltproc --stringparam title "Labels" -o $@ $^

# Generic rule to turn .fo into .pdf

%.pdf: %.fo
	$(FOP) -q -fo $< -pdf $@
