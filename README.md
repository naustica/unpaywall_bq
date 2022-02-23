# Workflow for Processing and Loading Unpaywall snapshots into Google BigQuery

This repository contains instructions on how to extract and transform Unpaywall data for data analysis with Google BigQuery.

## Requirements

The following packages are required for this workflow.

- [jq](https://stedolan.github.io/jq/)

## Setting Crossref Variables

Replace the following placeholders with your credentials.

```bash
$ export WORKING_DIRECTORY="/users/haupka/upw_export"

$ export SNAPSHOT_FILE="unpaywall_snapshot_2020-04-27T153236.jsonl.gz"

$ export SNAPSHOT_DIRECTORY="upw_Apr20_08_20"
```

## Download snapshot

```bash
$ wget -P /scratch/${WORKING_DIRECTORY} https://s3-us-west-2.amazonaws.com/unpaywall-data-snapshots/${SNAPSHOT_FILE}
```

## Data transformation

```bash
$ sbatch upw_export_jq_hpc.sh
```

## Uploading Files to Google Bucket

```bash
$ gsutil -m cp -r /scratch/${WORKING_DIRECTORY}/${SNAPSHOT_DIRECTORY} gs://bigschol
```

## Creating a BigQuery Table

```bash
$ bq load --ignore_unknown_values --source_format=NEWLINE_DELIMITED_JSON subugoe-collaborative:oadoi_full.upw_Apr20_08_20 gs://bigschol/upw_Apr20_08_20/*.jsonl.gz bq_schema_apr20.json
```
