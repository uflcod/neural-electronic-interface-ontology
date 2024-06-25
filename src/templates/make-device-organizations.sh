robot merge \
	  --input ../ontology/neio-edit.owl \
	template \
	  --prefix "neio: https://w3id.org/neural-electronic-interface-ontology/NEIO_" \
	  --prefix "dcterms: http://purl.org/dc/terms/" \
	  --template device-organizations.tsv \
	  --ontology-iri https://w3id.org/neural-electronic-interface-ontology/neio/components/device-organizations.owl \
	convert --format ofn \
	--output ../ontology/components/device-organizations.owl 
