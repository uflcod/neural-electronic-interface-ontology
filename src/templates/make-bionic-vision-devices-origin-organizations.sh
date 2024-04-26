robot merge \
	  --input ../ontology/neio-edit.owl \
	template \
	  --prefix "neio: https://w3id.org/neural-electronic-interface-ontology/NEIO_" \
	  --prefix "dcterms: http://purl.org/dc/terms/" \
	  --template bionic-vision-device-origin-organizations.tsv \
	  --ontology-iri https://w3id.org/neural-electronic-interface-ontology/neio/imports/bionic-vision-device-origin-organizations_import.owl \
	convert --format ofn \
	--output ../ontology/imports/bionic-vision-device-origin-organizations_import.owl
