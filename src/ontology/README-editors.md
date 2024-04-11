These notes are for the EDITORS of pain

This project was created using the [ontology development kit](https://github.com/INCATools/ontology-development-kit). See the site for details.

For more details on ontology management, please see the [OBO tutorial](https://github.com/jamesaoverton/obo-tutorial) or the [Gene Ontology Editors Tutorial](https://go-protege-tutorial.readthedocs.io/en/latest/)

You may also want to read the [GO ontology editors guide](http://go-ontology.readthedocs.org/)

## Requirements

 1. Protege (for editing)
 2. A git client (we assume command line git)
 3. [docker](https://www.docker.com/get-docker) (for managing releases)

## Editors Version

Make sure you have an ID range in the [idranges file](neio-idranges.owl)

If you do not have one, get one from the maintainer of this repo.

The editors version is [neio-edit.owl](neio-edit.owl)

** DO NOT EDIT neio.obo OR neio.owl in the top level directory **

[../../neio.owl](../../neio.owl) is the release version

To edit, open the file in Protege. First make sure you have the repository cloned, see [the GitHub project](https://github.com/uflcod/neural-electronic-interface-ontology) for details.

You should discuss the git workflow you should use with the maintainer
of this repo, who should document it here. If you are the maintainer,
you can contact the odk developers for assistance. You may want to
copy the flow an existing project, for example GO: [Gene Ontology
Editors Tutorial](https://go-protege-tutorial.readthedocs.io/en/latest/).

In general, it is bad practice to commit changes to main. It is
better to make changes on a branch, and make Pull Requests.

## ID Ranges

These are stored in the file

 * [neio-idranges.owl](neio-idranges.owl)

** ONLY USE IDs WITHIN YOUR RANGE!! **

If you have only just set up this repository, modify the idranges file
	and add yourself or other editors. Note Protege does not read the file
- it is up to you to ensure correct Protege configuration.


### Setting ID ranges in Protege

We aim to put this up on the technical docs for OBO on http://obofoundry.org/

For now, consult the [GO Tutorial on configuring Protege](http://go-protege-tutorial.readthedocs.io/en/latest/Entities.html#new-entities)

## Imports

All import modules are in the [imports/](imports/) folder.

There are two ways to include new classes in an import module

 1. Reference an external ontology class in the edit ontology. In Protege: "add new entity", then paste in the PURL
 2. Add to the imports/ont_terms.txt file, for example imports/go_terms.txt

After doing this, you can run

`./run.sh make all_imports`

to regenerate imports.

Note: the ont_terms.txt file may include 'starter' classes seeded from
the ontology starter kit. It is safe to remove these.

## Release Manager notes

You should only attempt to make a release AFTER the edit version is
committed and pushed, AND the travis build passes.

These instructions assume you have
[docker](https://www.docker.com/get-docker). This folder has a script
[run.sh](run.sh) that wraps docker commands.

to release:

first type

    git branch

to make sure you are on main

    cd src/ontology
    sh run.sh make all

If this looks good type:

    sh run.sh make prepare_release

This generates derived files such as neio.owl and neio.obo and places
them in the top level (../..).

Note that the versionIRI value automatically will be added, and will
end with YYYY-MM-DD, as per OBO guidelines.

Commit and push these files.

    git commit -a

And type a brief description of the release in the editor window

Finally type:

    git push origin main

IMMEDIATELY AFTERWARDS (do *not* make further modifications) go here:

 * https://github.com/uflcod/neural-electronic-interface-ontology/releases
 * https://github.com/uflcod/neural-electronic-interface-ontology/releases/new

__IMPORTANT__: The value of the "Tag version" field MUST be

    vYYYY-MM-DD

The initial lowercase "v" is REQUIRED. The YYYY-MM-DD *must* match
what is in the `owl:versionIRI` of the derived neio.owl (`data-version` in
neio.obo). This will be today's date.

This cannot be changed after the fact, be sure to get this right!

Release title should be YYYY-MM-DD, optionally followed by a title (e.g. "january release")

You can also add release notes (this can also be done after the fact). These are in markdown format.
In future we will have better tools for auto-generating release notes.

Then click "publish release"

