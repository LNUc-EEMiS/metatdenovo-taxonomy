# metatdenovo-taxonomy

Taxonomy files for nf-core/metatdenovo

## General information

Author: Daniel Lundin, Linnaeus University

Contact e-mail: daniel.lundin@lnu.se

DOI: 10.17044/scilifelab.28211678

License: CC BY 4.0

This readme file was last updated: 2025-02-13

Please cite as: Daniel Lundin (2025).

The data in this repository can be used to assign taxonomy to sequences with Diamond [Buchfink et al. 2015], particularly using the `--diamond_dbs` parameter in nf-core/metatdenovo, release 1.1 or later.

Currently, the data available represents species-representative genomes from Genome Taxonomy Database (GTDB), release R09-RS220 [Parks et al. 2018].

## File preparation

All species-representative genomes from the GTDB were downloaded from the National Center for Biotechnology Information (NCBI) and annotated with Prokka [v. 1.14.6; Seemann 2014], and the sequences for all resulting proteins were used for this data.
The taxonomy dump files (in NCBI taxonomy dump format) were created from the GTDB metadata with TaxonKit [v. 0.18.0; Shen and Ren 2021] and the Diamond database with Diamond [v. 2.1.10; Buchfink et al. 2015] in "taxonomy mode", i.e. using the taxonomy dump created with TaxonKit.
(See below for commands used.)

## File descriptions

There are five files:

* gtdb-r220.faa.gz: Fasta file with protein sequences. Not used by nf-core/metatdenovo but can be used to create the Diamond database below.
* gtdb-r220.taxonomy.dmnd: Diamond database with taxonomy information.
* gtdb-r220.names.dmp: Taxonomy dump file.
* gtdb-r220.nodes.dmp: Nodes dump file.
* gtdb-r220.seqid2taxid.tsv.gz: Mapping from protein accession to taxon.

The Diamond database and taxonomy dump files can be used with nf-core/metatdenovo (Version >1.1) by providing a csv file like below to the --diamond_dbs parameter.
(Although Nextflow can use https-urls for paths, it is usually better to download the very large files and keep local copies.)

```csv
db,dmnd_path,taxdump_names,taxdump_nodes,ranks,parse_with_taxdump
gtdb,gtdb_r220_repr.dmnd,gtdb_taxdump/names.dmp,gtdb_taxdump/nodes.dmp,domain;phylum;class;order;genus;species;strain,
```

## Commands used to prepare taxonomy dump files and the Diamond database

Taxonomy dump: `cut -f 1,19-20 *metadata.tsv | grep -v 'accession' | awk 'BEGIN { FS="\t" } { if ( $2 == "t" ) { print $1 "\t" $3 } }' | taxonkit create-taxdump --gtdb -O`.

(Where `*metadata.tsv`  are the GTDB metadata files, downloadable from here: https://data.gtdb.ecogenomic.org/releases/release220/220.0/.)

Diamond database: `gunzip -c gtdb-r220.faa.gz | sed '/^>/s/ .*//' | diamond makedb --taxonmap gtdb-r220.seqid2taxid.tsv.gz --taxonnames gtdb-r220.names.dmp --taxonnodes gtdb-r220.nodes.dmp --db gtdb-r220.taxonomy.dmnd --no-parse-seqids`

## Revision history

20250211 First version

## Repository

https://github.com/LNUc-EEMiS/metatdenovo-taxonomy

## References

Buchfink, Benjamin, Chao Xie, and Daniel H Huson. “Fast and Sensitive Protein Alignment Using DIAMOND.” Nature Methods 12, no. 1 (January 2015): 59–60. https://doi.org/10.1038/nmeth.3176.

Parks, Donovan H., Maria Chuvochina, David W. Waite, Christian Rinke, Adam Skarshewski, Pierre-Alain Chaumeil, and Philip Hugenholtz. “A Standardized Bacterial Taxonomy Based on Genome Phylogeny Substantially Revises the Tree of Life.” Nature Biotechnology, August 27, 2018. https://doi.org/10.1038/nbt.4229.

Seemann, Torsten. “Prokka: Rapid Prokaryotic Genome Annotation.” Bioinformatics, March 18, 2014, btu153. https://doi.org/10.1093/bioinformatics/btu153.

Shen, Wei, and Hong Ren. “TaxonKit: A Practical and Efficient NCBI Taxonomy Toolkit.” Journal of Genetics and Genomics, Special issue on Microbiome, 48, no. 9 (September 20, 2021): 844–50. https://doi.org/10.1016/j.jgg.2021.03.006.
