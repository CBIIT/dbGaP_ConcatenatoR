# dbGaP_ConcatenatoR
This script takes two directories of dbGaP submission files and combine them into one submission file packet.

Run the following command in a terminal where R is installed for help.

```
Rscript --vanilla dbGaP_ConcatenatoR.R -h
Usage: dbGaP_ConcatenatoR.R [options]

dbGaP_ConcatenatoR.R v2.0.0

Submit two directories that contain the dbGaP submission files for SA, SSM and, SC_DS.

Options:
	-d CHARACTER, --directory_1=CHARACTER
		The first directory of dbGaP files.

	-i CHARACTER, --directory_2=CHARACTER
		The second directory of dbGaP files.

	-o CHARACTER, --output=CHARACTER
		The output directory the merge files will be written out. (This will create a directory if one does not exist.)

	-h, --help
		Show this help message and exit
```

An example use of the code would be:

```
Rscript --vanilla dbGaP_ConcatenatoR.R -d test/set_a -i test/set_b/ -o test/set_ab/
```

The input from the two submission files would be ingested, concatenated and duplicates removed. The output would be placed in the newly created directory if the directory, "set_ab", did not previously exist.
