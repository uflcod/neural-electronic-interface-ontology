## Customize Makefile settings for neural-electronic-interface ontology
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# ----------------------------------------
# Import modules
# ----------------------------------------
# Most ontologies are modularly constructed using portions of other ontologies
# These live in the imports/ folder
# This pattern uses ROBOT to generate an import module

IMPORTS =  omo uberon ogms obi organizations bionic-vision-devices

IMPORT_ROOTS = $(patsubst %, $(IMPORTDIR)/%_import, $(IMPORTS))
IMPORT_OWL_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).owl)
IMPORT_FILES = $(IMPORT_OWL_FILES)

IMP=true # Global parameter to bypass import generation
MIR=true # Global parameter to bypass mirror generation
IMP_LARGE=true # Global parameter to bypass handling of large imports

.PRECIOUS: $(IMPORTDIR)/%_import.owl

.PHONY: all_imports
all_imports: $(IMPORT_FILES)

.PHONY: refresh-imports
refresh-imports:
	$(MAKE) IMP=true MIR=true PAT=false IMP_LARGE=true all_imports -B

.PHONY: no-mirror-refresh-imports
no-mirror-refresh-imports:
	$(MAKE) IMP=true MIR=false PAT=false IMP_LARGE=true all_imports -B

.PHONY: refresh-imports-excluding-large
refresh-imports-excluding-large:
	$(MAKE) IMP=true MIR=true PAT=false IMP_LARGE=false all_imports -B

.PHONY: refresh-%
refresh-%:
	$(MAKE) IMP=true IMP_LARGE=true MIR=true PAT=false $(IMPORTDIR)/$*_import.owl -B

.PHONY: no-mirror-refresh-%
no-mirror-refresh-%:
	$(MAKE) IMP=true IMP_LARGE=true MIR=false PAT=false $(IMPORTDIR)/$*_import.owl -B

.PHONY: all-imports
all-imports:
#	@echo $(patsubst %, $(IMPORTDIR)/%_import.owl, $(IMPORTS)) # testing
	make $(patsubst %, $(IMPORTDIR)/%_import.owl, $(IMPORTS))
#	make  imports/omo_import.owl

$(IMPORTDIR)/omo_import.owl: $(MIRRORDIR)/omo.owl
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
	  convert --format ofn \
	  --output $@.tmp.owl && mv $@.tmp.owl $@

$(IMPORTDIR)/cob-native_import.owl: $(MIRRORDIR)/cob-native.owl
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
	  convert --format ofn \
	  --output $@.tmp.owl && mv $@.tmp.owl $@

$(IMPORTDIR)/uberon_import.owl: $(MIRRORDIR)/uberon.owl $(IMPORTDIR)/uberon_terms.txt
	$(ROBOT) \
		filter \
			--input $< \
			--term-file $(word 2, $^) \
			--select "annotations self ancestors" \
			--axioms logical \
			--signature true \
			--trim true \
		remove \
			--select "owl:deprecated='true'^^xsd:boolean" \
		remove \
			--select "<http://purl.obolibrary.org/obo/NCBITaxon_*>" \
		annotate \
			--annotate-defined-by true \
			--ontology-iri $(URIBASE)/$(ONT)/$@ \
			--version-iri $(URIBASE)/$(ONT)/$@ \
		convert --format ofn \
		--output $@.tmp.owl && mv $@.tmp.owl $@

$(IMPORTDIR)/ogms_import.owl: $(MIRRORDIR)/ogms.owl $(IMPORTDIR)/ogms_terms.txt
	$(ROBOT) \
		extract \
			--input $< \
			--method MIREOT \
			--lower-terms $(word 2, $^) \
		remove \
			--select "owl:deprecated='true'^^xsd:boolean" \
		annotate \
			--annotate-defined-by true \
			--ontology-iri $(URIBASE)/$(ONT)/$@ \
			--version-iri $(URIBASE)/$(ONT)/$@ \
		convert --format ofn \
		--output $@.tmp.owl && mv $@.tmp.owl $@

$(IMPORTDIR)/omrse_import.owl: $(MIRRORDIR)/omrse.owl $(IMPORTDIR)/omrse_terms.txt
	$(ROBOT) \
		filter \
			--input $< \
			--term-file $(word 2, $^) \
			--select "annotations self ancestors" \
			--axioms logical \
			--signature true \
			--trim true \
		remove \
			--select "owl:deprecated='true'^^xsd:boolean" \
		annotate \
			--annotate-defined-by true \
			--ontology-iri $(URIBASE)/$(ONT)/$@ \
			--version-iri $(URIBASE)/$(ONT)/$@ \
		convert --format ofn \
		--output $@.tmp.owl && mv $@.tmp.owl $@

$(IMPORTDIR)/obi_import.owl: $(MIRRORDIR)/obi.owl $(IMPORTDIR)/obi_terms.txt
	$(ROBOT) \
		extract \
			--input $< \
			--method MIREOT \
			--lower-terms $(word 2, $^) \
		remove \
			--select "owl:deprecated='true'^^xsd:boolean" \
		annotate \
			--annotate-defined-by true \
			--ontology-iri $(URIBASE)/$(ONT)/$@ \
			--version-iri $(URIBASE)/$(ONT)/$@ \
		convert --format ofn \
		--output $@.tmp.owl && mv $@.tmp.owl $@

# ----------------------------------------
# Template modules
# ----------------------------------------
# When using templates (e.g. robot templates)
# you need to use the template goal

$(IMPORTDIR)/organizations_import.owl: $(TEMPLATEDIR)/organizations.tsv 
	$(ROBOT) merge --input $(SRC) \
		template \
			--prefix "neio: https://w3id.org/neural-electronic-interface-ontology/NEIO_" \
			--prefix "dcterms: http://purl.org/dc/terms/" \
			--template $^ \
			--ontology-iri  $(URIBASE)/$(ONT)/$@ \
		convert --format ofn \
		--output $@.tmp.owl && mv $@.tmp.owl $@

# NOTE: There is an implicit dependency between devices and organizations.
# If you add an organization to devices, you need to make sure it is in organizations.
$(IMPORTDIR)/bionic-vision-devices_import.owl: $(TEMPLATEDIR)/bionic-vision-devices.tsv
	$(ROBOT) merge --input $(SRC) \
		template \
			--prefix "neio: https://w3id.org/neural-electronic-interface-ontology/NEIO_" \
			--prefix "dcterms: http://purl.org/dc/terms/" \
			--template $^ \
			--ontology-iri $(URIBASE)/$(ONT)/$@ \
		convert --format ofn \
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

## ONTOLOGY: cob-native 
## The IRI for cob-native has 'cob/'; i.e. $(OBO_BASE)/cob/cob-native.owl 
## I couldn't figure out how ot use mirror-% to work with mirror-cob/native
## So, if you want to use cob-native, it has to be a special target.
# .PHONY: mirror-cob-native
# .PRECIOUS: $(MIRRORDIR)/cob-native.owl
# mirror-cob-native: | $(TMPDIR)
# 	if [ $(MIR) = true ] && [ $(IMP) = true ]; then curl -L $(OBO_BASE)/cob/cob-native.owl --create-dirs -o $(MIRRORDIR)/cob-native.owl --retry 4 --max-time 200 &&\
# 		$(ROBOT) convert -i $(MIRRORDIR)/cob-native.owl -o $@.tmp.owl &&\
# 		mv $@.tmp.owl $(TMPDIR)/$@.owl; fi

.PRECIOUS: $(MIRRORDIR)/%.owl
$(MIRRORDIR)/%.owl: 
	if [ $(MIR) = true ] && [ $(IMP) = true ] && [ $(IMP_LARGE) = true ]; then \
		$(MAKE) mirror-$*; fi

.PHONY: mirror-%
mirror-%: | $(TMPDIR)
	@echo "*** mirroring $* ***"
	if [ $(MIR) = true ] && [ $(IMP) = true ] && [ $(IMP_LARGE) = true ]; then \
		curl -L $(OBO_BASE)/$*.owl \
			--create-dirs -o $(MIRRORDIR)/$(notdir $*).temp.owl --retry 4 --max-time 200 && \
		$(ROBOT) convert \
			--input $(MIRRORDIR)/$(notdir $*).temp.owl \
			--output $(MIRRORDIR)/$(notdir $*).owl && \
		rm  $(MIRRORDIR)/$*.temp.owl; fi