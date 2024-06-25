robot merge \
	  --input ../ontology/neio-edit.owl \
	template \
	  --prefix "neio: https://w3id.org/neural-electronic-interface-ontology/NEIO_" \
	  --prefix "dcterms: http://purl.org/dc/terms/" \
	  --template bionic-vision-devices.tsv \
	  --ontology-iri https://w3id.org/neural-electronic-interface-ontology/neio/components/bionic-vision-devices.owl \
	convert --format ofn \
	--output ../ontology/components/bionic-vision-devices.owl