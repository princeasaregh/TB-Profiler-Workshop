#!/bin/bash

# Your genomes should be in a folder named "fastq"

echo "id,read1,read2" > samplesheet.csv

for i in fastq/*_1.fastq.gz
do
sample=${i%_1.fastq.gz}
echo "$sample,$(readlink -f $i),$(readlink -f ${sample}_2.fastq.gz)" >> samplesheet.csv
done
