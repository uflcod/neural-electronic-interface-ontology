robot template \
	  --prefix "neio: https://w3id.org/neural-electronic-interface-ontology/NEIO_" \
	  --prefix "dcterms: http://purl.org/dc/terms/" \
	  --input ../imports/obi_import.owl \
	  --input ../neio-edit.owl \
	  --template bionic-vision-devices.tsv \
	  --ontology-iri https://w3id.org/neural-electronic-interface-ontology/neio/imports/bionic-vision-devices_import.owl \
	convert --format ofn \
	--output ../imports/bionic-vision-devices_import.owl
