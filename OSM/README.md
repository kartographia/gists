# OSM Tables

We leverage OSM to help identify dwell locations and to classify devices. OSM data is stored in a PostgreSQL/PostGIS database. 

## Workflow
The basic process involves the following steps:
 - Download osm data (e.g. planet file)
 - Break the osm data up into chunks
 - Load the chunks into PostgreSQL
 - Merge chunks into unified tables



## Subsetting the Data
We use osmium to subset osm into chunks prior to loading everything into PostgreSQL. We do this in order to help the loader insert data into PostgreSQL (e.g. avoid out of memory issues).

We have a python script called `partition_planet` that automates the chunking process. The script is found in the scripts directory and is used as follows:
```
python3 py/partition_planet.py \
    -m 8e8 \
    -i planet-latest.osm.pbf \
    -o /mnt/nvme1/chunks/
```
The `-m` option is maximum file size in bytes, and can be in the form of an integer (e.g. `800000000`) or abbreviated in the python style (e.g. `8e8`).

The `-i` option specifies the location of the planet file.

The `-o` option specifies the output directory into which the chunks will be put.

## Loading Data into PostgreSQL
We use osm2pgsql to load osm into PostgreSQL. As mentioned before, we ususally break up the osm data into chunks to avoid out-of-memory issues with osm2pgsql. 

We have a python script called `upload_chunks` that automates the loading process. The script is found in the scripts directory and is used as follows:

Make sure that your working directory has the `default.style` file, which is required by the `osm2pgsql` program. Download the with cURL:
```
curl -O https://raw.githubusercontent.com/openstreetmap/osm2pgsql/master/default.style
```
Make sure that the python module `pexpect` is installed by running `pip3 install pexpect`.

Run the python script to load all the chunks into a postgresql database as separate tables:
```
python3 py/upload_chunks.py -d /mnt/nvme1/chunks
```
This script takes 5-6 hours to run.
The result is 4 tables per chunk: one each for points, lines, polygons and roads. Thus with 135 chunks you will get 540 tables.
