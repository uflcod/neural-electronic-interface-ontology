robot template \
	  --prefix "neio: https://w3id.org/neural-electronic-interface-ontology/NEIO_" \
	  --prefix "dcterms: http://purl.org/dc/terms/" \
	  --input ../neio-edit.owl \
	  --template organizations.tsv \
	  --ontology-iri https://w3id.org/neural-electronic-interface-ontology/neio/imports/organizations_import.owl \
	convert --format ofn \
	--output ../imports/organizations.owl 
