#!/bin/bash
#SBATCH -p medium
#SBATCH -C scratch
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 6
#SBATCH -t 07:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nick.haupka@sub.uni-goettingen.de

echo -n 'Start: ' > /scratch/${WORKING_DIRECTORY}/times.txt
uptime >> /scratch/${WORKING_DIRECTORY}/times.txt

module load jq/1.6

echo -n 'Modules jq and gsutil loaded, create working directory: ' >> /scratch/${WORKING_DIRECTORY}/times.txt
uptime >> /scratch/${WORKING_DIRECTORY}/times.txt

mkdir /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY}

echo -n 'Working directory created, start exporting: ' >> /scratch/${WORKING_DIRECTORY}/times.txt
uptime >> /scratch/${WORKING_DIRECTORY}/times.txt

zcat /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_FILE} | parallel --pipe --block 100M --jobs 6 --files --tmpdir /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY} --recend '}\n' "jq -c 'select(.year >= 2008 and .year <= 2022) | {doi, genre, has_repository_copy, is_paratext, is_oa, journal_is_in_doaj, journal_is_oa, journal_issn_l, journal_issns, journal_name, oa_locations, oa_locations_embargoed, oa_status, publisher, published_date, doi_updated: .updated, year}'"

echo -n 'Export finished, start renaming: ' >> /scratch/${WORKING_DIRECTORY}/times.txt
uptime >> /scratch/${WORKING_DIRECTORY}/times.txt

for file in /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY}/*.par
do
  mv "$file" "${file%.par}.jsonl"
done

echo -n 'Renaming finished, start compressing: ' >> /scratch/${WORKING_DIRECTORY}/times.txt
uptime >> /scratch/${WORKING_DIRECTORY}/times.txt

gzip -r /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY}

echo -n 'Script finished.' >> /scratch/${WORKING_DIRECTORY}/times.txt
uptime >> /scratch/${WORKING_DIRECTORY}/times.txt
