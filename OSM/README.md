# OSM Tables

We leverage OSM to help identify dwell locations and to classify devices. OSM data is stored in a PostgreSQL/PostGIS database.


## Loading Data

Basic process involves the following steps:
 - Download osm data (e.g. planet file)
 - Break the osm data up into chunks
 - Load the chunks into PostgreSQL
 - Merge chunks into unified tables



### Break the planet up into chunks
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


