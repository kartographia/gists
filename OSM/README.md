# OSM Tables

We leverage OSM to help identify dwell locations and to classify devices. OSM data is stored in a PostgreSQL/PostGIS database.


## Loading Data

Basic process involves the following steps:
 - Download osm data (e.g. planet file)
 - Break the osm data up into chunks
 - Load the chunks into PostgreSQL
 - Merge chunks into unified tables


### Break the planet up into chunks
Create a directory to put your planet chunks:
```
mkdir /mnt/nvme1/chunks
```
Then run the python script that turns `planet-latest.osm.pbf` into the chunks:
```
python3 py/partition_planet.py \
    -m 8e8 \
    -i planet-latest.osm.pbf \
    -o /mnt/nvme1/chunks/
```
The `-m` option is maximum file size in bytes, and can be in the form of an integer (e.g. `800000000`) or abbreviated in the python style (e.g. `8e8`).

The `-i` option specifies the location of the planet file.

The `-o` option specifies the output directory into which the chunks will be put.


