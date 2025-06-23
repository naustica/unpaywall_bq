#!/bin/bash
#SBATCH -p medium
#SBATCH -C scratch
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 03:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nick.haupka@sub.uni-goettingen.de


module load jq

mkdir /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY}

zcat /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_FILE} | parallel --pipe --block 100M --jobs 8 --files --tmpdir /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY} --recend '}\n' "jq -c 'select(.year >= 2008 and .year <= 2025) | {doi, genre, has_repository_copy, is_paratext, is_oa, journal_is_in_doaj, journal_is_oa, journal_issn_l, journal_issns, journal_name, oa_locations, oa_locations_embargoed, oa_status, publisher, published_date, doi_updated: .updated, year}'"

for file in /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY}/*.par
do
  mv "$file" "${file%.par}.jsonl"
done

gzip -r /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY}
