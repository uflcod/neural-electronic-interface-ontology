## Customize Makefile settings for bionic-device-ontology
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# ----------------------------------------
# ontology imports
# ----------------------------------------

IMPORTS =  omo cob-native uberon

IMPORT_ROOTS = $(patsubst %, $(IMPORTDIR)/%_import, $(IMPORTS))
IMPORT_OWL_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).owl)
IMPORT_FILES = $(IMPORT_OWL_FILES)

.PHONY: all-imports
all-imports:
#	@echo $(patsubst %, $(IMPORTDIR)/%_import.owl, $(IMPORTS)) # testing
	make $(patsubst %, $(IMPORTDIR)/%_import.owl, $(IMPORTS))
#	make  imports/omo_import.owl

$(IMPORTDIR)/omo_import.owl: $(MIRRORDIR)/omo.owl.gz
	$(ROBOT) \
	  remove \
		--input $< \
		--select "owl:deprecated='true'^^xsd:boolean" \
	  remove \
		--select classes \
	  annotate \
		--annotate-defined-by true \
		--ontology-iri $(URIBASE)/$(ONT)/$@ \
		--version-iri $(URIBASE)/$(ONT)/$@ \
	  --output $@.tmp.owl && mv $@.tmp.owl $@

$(IMPORTDIR)/cob-native_import.owl: $(MIRRORDIR)/cob-native.owl.gz
	$(ROBOT) \
	  filter \
		--input $< \
		--prefix "COB: http://purl.obolibrary.org/obo/COB_" \
		--term COB:0000031 \
		--term COB:0000502 \
		--term COB:0000006 \
		--term COB:0000034 \
	  remove \
		--select "owl:deprecated='true'^^xsd:boolean" \
	  annotate \
		--annotate-defined-by true \
		--ontology-iri $(URIBASE)/$(ONT)/$@ \
	  --output $@.tmp.owl && mv $@.tmp.owl $@

$(IMPORTDIR)/uberon_import.owl: $(MIRRORDIR)/uberon.owl.gz $(IMPORTDIR)/uberon_terms.txt
	$(ROBOT) \
		extract \
			--method BOT \
			--input $< \
			--term-file $(word 2, $^) \
		remove \
			--select "owl:deprecated='true'^^xsd:boolean" \
		remove \
			--select "<http://purl.obolibrary.org/obo/NCBITaxon_*>" \
		annotate \
			--annotate-defined-by true \
			--ontology-iri $(URIBASE)/$(ONT)/$@ \
		--output $@.tmp.owl && mv $@.tmp.owl $@

# previous robot command using MIREOT
# $(ROBOT) \
#   extract \
# 	--input $< \
# 	--method MIREOT \
# 	--upper-term GO:0008150 \
# 	--upper-term UBERON:0000465 \
# 	--lower-term GO:0050908 \
# 	--lower-term UBERON:0000970 \
# 	--individuals exclude \
#   remove \
# 	--select "owl:deprecated='true'^^xsd:boolean" \
#   remove \
# 	--select "<http://purl.obolibrary.org/obo/NCBITaxon_*>" \
#   annotate \
#   	--annotate-defined-by true \
# 	--ontology-iri $(URIBASE)/$(ONT)/$@ \
#   --output $@.tmp.owl && mv $@.tmp.owl $@

# ----------------------------------------
# Mirroring upstream ontologies
# ----------------------------------------

.PHONY: all-mirrors
all-mirrors:
#	@echo $(patsubst %, $(MIRRORDIR)/%.owl.gz, $(IMPORTS)) # testing
	make $(patsubst %, $(MIRRORDIR)/%.owl.gz, $(IMPORTS))

download-mirrors:
#	@echo $(patsubst %, $(MIRRORDIR)/%.owl, $(IMPORTS)) # testing
	make $(patsubst %, $(MIRRORDIR)/%.owl, $(IMPORTS))

# --- gzip ontology mirrors ---

$(MIRRORDIR)/omo.owl.gz:
	gzip -fk $(MIRRORDIR)/omo.owl

$(MIRRORDIR)/cob-native.owl.gz: 
	gzip -fk $(MIRRORDIR)/cob-native.owl


$(MIRRORDIR)/uberon.owl.gz: 
	gzip -fk $(MIRRORDIR)/uberon.owl

## ONTOLOGY: omo
.PHONY: mirror-omo
.PRECIOUS: $(MIRRORDIR)/omo.owl
mirror-omo: | $(TMPDIR)
	if [ $(MIR) = true ] && [ $(IMP) = true ]; then curl -L $(OBO_BASE)/omo.owl --create-dirs -o $(MIRRORDIR)/omo.owl --retry 4 --max-time 200 &&\
		$(ROBOT) convert -i $(MIRRORDIR)/omo.owl -o $@.tmp.owl &&\
		mv $@.tmp.owl $(TMPDIR)/$@.owl; fi


## ONTOLOGY: cob-native ### NOTE: you have to add 'cob/'
.PHONY: mirror-cob-native
.PRECIOUS: $(MIRRORDIR)/cob-native.owl
mirror-cob-native: | $(TMPDIR)
	if [ $(MIR) = true ] && [ $(IMP) = true ]; then curl -L $(OBO_BASE)/cob/cob-native.owl --create-dirs -o $(MIRRORDIR)/cob-native.owl --retry 4 --max-time 200 &&\
		$(ROBOT) convert -i $(MIRRORDIR)/cob-native.owl -o $@.tmp.owl &&\
		mv $@.tmp.owl $(TMPDIR)/$@.owl; fi


## ONTOLOGY: uberon
.PHONY: mirror-uberon
.PRECIOUS: $(MIRRORDIR)/uberon.owl
mirror-uberon: | $(TMPDIR)
	if [ $(MIR) = true ] && [ $(IMP) = true ] && [ $(IMP_LARGE) = true ]; then curl -L $(OBO_BASE)/uberon.owl --create-dirs -o $(MIRRORDIR)/uberon.owl --retry 4 --max-time 200 &&\
		$(ROBOT) convert -i $(MIRRORDIR)/uberon.owl -o $@.tmp.owl &&\
		mv $@.tmp.owl $(TMPDIR)/$@.owl; fi


$(MIRRORDIR)/%.owl: mirror-% | $(MIRRORDIR)
	if [ $(IMP) = true ] && [ $(MIR) = true ] && [ -f $(TMPDIR)/mirror-$*.owl ]; then if cmp -s $(TMPDIR)/mirror-$*.owl $@ ; then echo "Mirror identical, ignoring."; else echo "Mirrors different, updating." &&\
		cp $(TMPDIR)/mirror-$*.owl $@; fi; fi